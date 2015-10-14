//
//  HomeTimeModelSpec.m
//  HomeTime
//
//  Created by Tasvir H Rohila on 19/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "HomeTimeModel.h"

@interface HomeTimeModel (Spec)

@property (strong, nonatomic) NSURLSession *session;
@property (assign, nonatomic) BOOL loadingNorth;
@property (assign, nonatomic) BOOL loadingSouth;
@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) HomeTimeData* northTramsData;
@property (copy, nonatomic) HomeTimeData* southTramsData;

@end

/*
 describe "what I want"
 context "the context I am in"
 it "should do something"
 context...
 */
SPEC_BEGIN(HomeTimeModelSpec)
describe(@"HomeTimeModelSpec", ^{
    __block HomeTimeModel *objHomeTimeModel = Nil;
    
    beforeAll(^{
        objHomeTimeModel = [[HomeTimeModel alloc] init];
        objHomeTimeModel.loadingNorth = YES;
        objHomeTimeModel.loadingSouth = YES;
    });

    afterAll(^{
        
        objHomeTimeModel = nil;
        
    });

    //init
    context(@"When initialising a new HomeTimeModel object", ^{
        
        it(@"HomeTimeModel should not be Nil", ^{
            [objHomeTimeModel shouldNotBeNil];
        });//it
        
    });//context
    
    //
    //fetchApiToken
    context(@"When fetching API token", ^{
        
        it(@"token should not be Nil", ^{
            ////Call the model object to fetch API token
            [objHomeTimeModel stub:@selector(loadTramData) withBlock:^id(NSArray *params) {
                /*
                 void (^completion)(NSArray *responseData, NSError *error) = params[1];
                completion(@[@{@"PredictedArrivalDateTime": @"/Date(1426821588000+1100)/"}],nil);
                */
                [objHomeTimeModel.token shouldNotBeNil];
                
                return nil;
            }];
        });//it
             
    });//context
    
    //
    //loadTramData
    context(@"When loading north-bound tram data", ^{
        
        it(@"northTramData should not be Nil", ^{
            ////Call the model object to fetch API token
            [objHomeTimeModel stub:@selector(loadTramData) withBlock:^id(NSArray *params) {
                
                [objHomeTimeModel.northTramsData shouldNotBeNil];
                return nil;
            }];
        });//it
        
    });//context
    
    //
    //loadTramData
    context(@"When loading south-bound tram data", ^{
        
        it(@"southTramsData and northTramData should not be Nil", ^{
            ////Call the model object to fetch API token
            [objHomeTimeModel stub:@selector(loadTramData) withBlock:^id(NSArray *params) {
                
                [objHomeTimeModel.southTramsData shouldNotBeNil];
                return nil;
            }];
        });//it
        
    });//context
    /*
     NOTE: Below are set of private methods that cannot be unit tested. Need to implement a category and then find a way aroung to unit-test these. So basically as a rule Your public interfaces should be pretty stable, and will exercise your private methods.
     */
    //
    //- (void)loadTramApiResponseFromUrl:(NSString *)tramsUrl completion:(void (^)(NSArray *responseData, NSError *error))completion
    context(@"when loadTramApiResponseFromUrl", ^{
        
        pending(@"the response data should exist", ^{
            
        });
    });//context
        //
        //- (void)loadTramDataUsingToken:(NSString *)token
    context(@"when loadTramApiResponseFromUrl", ^{
        
        pending(@"the response data should exist", ^{
            
        });
    });//context
    
    //
    //- (NSString *)urlForStop:(NSString *)stopId token:(NSString *)token
    context(@"when formatting URL for tram stops", ^{
        
        pending(@"the response should not be nil", ^{
            
        });
    });//context
    
}); //describe

SPEC_END
