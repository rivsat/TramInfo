//
//  HomeTimeModel.m
//  HomeTime
//
//  Created by Tasvir H Rohila on 18/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTimeModel.h"
#import "Defines.h"


@interface HomeTimeModel ()

//class extension, which is another way to add private methods and variables to a class so that external classes will not know about them
@property (strong, nonatomic) NSURLSession *session;
@property (assign, nonatomic) BOOL loadingNorth;
@property (assign, nonatomic) BOOL loadingSouth;
@property (copy, nonatomic) NSString *token;

@property (retain, nonatomic) HomeTimeData* northTramsData;
@property (retain, nonatomic) HomeTimeData* southTramsData;
@end

@implementation HomeTimeModel

/*
 Method Name: init
 Parameters: none
 Return: object of type HomeTimeModel
 Purpose:  Initializer method for HomeTimeModel
*/
-(id) init
{
    self = [super init];
    if (self) {
        @try {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        }
        @catch(NSException *ex) {
            NSLog(@"Exception in HomeTimeModel::init. Description:%@",ex.description);
        }
    }
    return self;
}

/*
 Method Name: loadTramData
 Parameters: none
 Return: void
 Purpose:  retrieves tram data by calling requisite API and parsing the JSON object
 */
- (void)loadTramData
{
    @try {
        self.loadingNorth = YES;
        self.loadingSouth = YES;
        
        if (self.token != nil)
        {
            NSLog(@"Token: %@", self.token);
            [self loadTramDataUsingToken:self.token];
        }
        else
        {
            //Call the model object to fetch API token
            [self fetchApiToken:^(NSString *token, NSError *error) {
                if (error != nil)
                {
                    self.loadingNorth = NO;
                    self.loadingSouth = NO;
                    //Call delegate to notify of error
                    //NSLog(@"Error retrieving token: %@", error);
                    NSString *errorString = [[NSString alloc] initWithFormat:@"Error retrieving token: %@", error];
                    NSLog(@"%@",errorString);
                    [self.homeTimedelegate failToLoadTimeTable:errorString];
                }
                else
                {
                    self.token = token;
                    NSLog(@"Token: %@", self.token);
                    [self loadTramDataUsingToken:token];
                }
            }];
        }
    }
    @catch(NSException *ex) {
        NSString *errorString = [[NSString alloc] initWithFormat:@"Exception in loadTramData. Description: %@",
                                 ex.description ];
        NSLog(@"%@",errorString);
        [self.homeTimedelegate failToLoadTimeTable:errorString];
    }
}

/*
 Method Name: fetchApiToken
 Parameters: block void (^)(NSString *token, NSError *error))completion
 Return: void
 Purpose: fetches the API  token required to query the server for tram data
 */
- (void)fetchApiToken:(void (^)(NSString *token, NSError *error))completion
{
    NSString *tokenUrl = @"http://ws3.tramtracker.com.au/TramTracker/RestService/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS";
    
    [self loadTramApiResponseFromUrl:tokenUrl
                          completion:^(NSArray *response, NSError *error) {
                              NSDictionary *tokenObject = response.firstObject;
                              NSString *token = tokenObject[@"DeviceToken"];
                              completion(token, error);
                          }];
}

/*
 Method Name: loadTramApiResponseFromUrl
 Parameters: tramsUrl, block void (^)(NSArray *responseData, NSError *error))completion
 Return: void
 Purpose:  parses the tram API response received as the JSON object
 */
- (void)loadTramApiResponseFromUrl:(NSString *)tramsUrl completion:(void (^)(NSArray *responseData, NSError *error))completion
{
    @try
    {
        NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:tramsUrl]
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
                                                     if (requestError != nil)
                                                     {
                                                         completion(nil, requestError);
                                                     }
                                                     else
                                                     {
                                                         NSError *jsonError = nil;
                                                         NSDictionary *jsonRespsone = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&jsonError];
                                                         
                                                         if (jsonRespsone == nil)
                                                         {
                                                             completion(nil, jsonError);
                                                         }
                                                         else
                                                         {
                                                             completion(jsonRespsone[@"responseObject"], nil);
                                                         }
                                                     }
                                                 }];
        [task resume];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception in loadTramApiResponseFromUrl. Description: %@",ex.description);
    }
}

/*
 Method Name: setHomeTimeData
 Parameters: HomeTimeData
 Return: void
 Purpose: setter for HomeTimeData
 */
-(void) setHomeTimeData:(HomeTimeData *)timeData
{
    if ([timeData.strDirection isEqualToString:NORTH])
        self.northTramsData = timeData;
    else if ([timeData.strDirection isEqualToString:SOUTH])
        self.southTramsData = timeData;
}

/*
 Method Name: loadTramDataUsingToken
 Parameters: token
 Return: void
 Purpose: calls the url for stop as per stopId and retrieves response
 */
- (void)loadTramDataUsingToken:(NSString *)token
{
    @try
    {
        //NOTE: Ideally I would have wanted to read the northStopId and southStopId from a web service URL
        NSString *northStopId = @"4055";
        NSString *northTramsUrl = [self urlForStop:northStopId token:token];
        [self loadTramApiResponseFromUrl:northTramsUrl
                              completion:^(NSArray *trams, NSError *error) {
                                  self.loadingNorth = NO;
                                  if (error != nil)
                                  {
                                      NSLog(@"Error retrieving trams: %@", error);
                                  }
                                  else
                                  {
                                      HomeTimeData *tramsData = [[HomeTimeData alloc] initWithTimeTable:trams forDirection:NORTH];

                                      [self setHomeTimeData:tramsData];
                                      [self.homeTimedelegate displayTimeTable:tramsData];
                                  }
                              }];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception in loadTramDataUsingToken for NORTH. Description: %@",ex.description);
    }
    @try
    {
        NSString *southStopId = @"4155";
        NSString *southTramsUrl = [self urlForStop:southStopId token:token];
        [self loadTramApiResponseFromUrl:southTramsUrl
                              completion:^(NSArray *trams, NSError *error) {
                                  self.loadingSouth = NO;
                                  if (error != nil)
                                  {
                                      NSLog(@"Error retrieving trams: %@", error);
                                  }
                                  else
                                  {
                                      HomeTimeData *tramsData = [[HomeTimeData alloc] initWithTimeTable:trams forDirection:SOUTH];
                                      [self setHomeTimeData:tramsData];
                                      [self.homeTimedelegate displayTimeTable:tramsData];
                                  }
                              }];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception in loadTramDataUsingToken for SOUTH. Description: %@",ex.description);
    }

}

/*
 Method Name: urlForStop
 Parameters: stopId, token
 Return: url
 Purpose: constructs the URL by replacing the placeholders {STOP_ID} and {TOKEN}
 */
- (NSString *)urlForStop:(NSString *)stopId token:(NSString *)token
{
    @try
    {
        NSString *urlTemplate = @"http://ws3.tramtracker.com.au/TramTracker/RestService/GetNextPredictedRoutesCollection/{STOP_ID}/78/false/?aid=TTIOSJSON&cid=2&tkn={TOKEN}";
        return [[urlTemplate stringByReplacingOccurrencesOfString:@"{STOP_ID}" withString:stopId] stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:token];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception in loadTramDataUsingToken for SOUTH. Description: %@",ex.description);
        return nil;
    }
}

@end