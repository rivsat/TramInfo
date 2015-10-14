#import <Kiwi/Kiwi.h>
#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController (Spec)
@property (strong, nonatomic) IBOutlet UITableView *tramTimesTable;
@property (copy, nonatomic) NSString *token;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSArray *northTrams;
@property (strong, nonatomic) NSArray *southTrams;
@property (assign, nonatomic) BOOL loadingNorth;
@property (assign, nonatomic) BOOL loadingSouth;

- (void)loadTramData;
@end

SPEC_BEGIN(ViewControllerSpec)
      describe(@"HomeViewController", ^{
        __block HomeViewController *viewController;
        __block NSArray *arrSchedule;
        __block HomeTimeData *southTramsData, *northTramsData;
        beforeEach(^{
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

              [viewController view];
                arrSchedule = @[@{@"PredictedArrivalDateTime": @"/Date(1426821588000+1100)/"}];
                southTramsData = [[HomeTimeData alloc] initWithTimeTable:arrSchedule forDirection:SOUTH];
                northTramsData = [[HomeTimeData alloc] initWithTimeTable:arrSchedule forDirection:NORTH];
            
              //viewController.token = @"theToken";
        });

        it(@"should have sections for north and south", ^{
              NSInteger sections = [viewController.tramTimesTable numberOfSections];
              [[theValue(sections) should] equal:@2];
        });

        it(@"should initialize no tram data", ^{
              UITableView *tramsTable = viewController.tramTimesTable;

              NSInteger north = [tramsTable numberOfRowsInSection:0];
              [[theValue(north) should] equal:@1];

              UITableViewCell *placeholderCell = [tramsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
              NSString *placeholder = placeholderCell.textLabel.text;
              [[theValue([placeholder containsString:@"No upcoming trams"]) should] beTrue];

              NSInteger south = [tramsTable numberOfRowsInSection:1];
              [[theValue(south) should] equal:@1];

        });

        it(@"should display arriveDateTime on table after load api response", ^{
              [viewController stub:@selector(loadTramData) withBlock:^id(NSArray *params) {
                void (^completion)(NSArray *responseData, NSError *error) = params[1];
                completion(@[@{@"PredictedArrivalDateTime": @"/Date(1426821588000+1100)/"}],nil);
                  
                  [viewController displayTimeTable:northTramsData];
                  
                  UITableViewCell *northTramCell = [viewController.tramTimesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                  [[northTramCell.textLabel.text should] equal:@"14:19 (3 mins)"];
                  
                  [viewController displayTimeTable:southTramsData];
                  UITableViewCell *southTramCell = [viewController.tramTimesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                  [[southTramCell.textLabel.text should] equal:@"14:19 (3 mins)"];

                  
                return nil;
          }];
/*
          [viewController displayTimeTable:northTramsData];

          UITableViewCell *northTramCell = [viewController.tramTimesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
          [[northTramCell.textLabel.text should] equal:@"14:19 (3 mins)"];

          [viewController displayTimeTable:southTramsData];
          UITableViewCell *southTramCell = [viewController.tramTimesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
          [[southTramCell.textLabel.text should] equal:@"14:19 (3 mins)"];
 */
        }); //it

          
      //- (void)clearTramData
          //
          context(@"When clearing tram data", ^{
              
              it(@"northTrams, southTrams, loadingNorth, loadingSouth should be cleared", ^{
                  ////Call the model object to fetch API token
                  [viewController stub:@selector(clearTramData) withBlock:^id(NSArray *params) {

                      NSString *strResult = @"YES";
                      //loadingSouth
                      strResult = (viewController.loadingSouth==YES ? @"YES" : @"NO");
                      [[strResult should] equal:@"NO"];

                      //loadingNorth
                      strResult = (viewController.loadingNorth==YES ? @"YES" : @"NO");
                      [[strResult should] equal:@"NO"];
                    
                      [[viewController.northTrams should] equal:nil];
                      [[viewController.southTrams should] equal:nil];
                      
                      return nil;
                  }];
              });//it
              
          });//context

      });
SPEC_END