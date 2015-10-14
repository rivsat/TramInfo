//
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTime-Swift.h"
#import "Defines.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tramTimesTable;
@property (strong, nonatomic) NSArray *northTrams;
@property (strong, nonatomic) NSArray *southTrams;
@property (assign, nonatomic) BOOL loadingNorth;
@property (assign, nonatomic) BOOL loadingSouth;
@end

@implementation HomeViewController

- (void)awakeFromNib
{
    //Initialize our Data Model and assign self as the delegate
    _timeTableModel = [[HomeTimeModel alloc] init];
    _timeTableModel.homeTimedelegate = self;
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self clearTramData];
}

#pragma mark - Actions

- (IBAction)clearButtonTapped:(UIBarButtonItem *)sender
{
  [self clearTramData];
}

- (void)clearTramData
{
  self.northTrams = nil;
  self.southTrams = nil;
  self.loadingNorth = NO;
  self.loadingSouth = NO;
  
  [self.tramTimesTable reloadData];
}

- (IBAction)loadButtonTapped:(UIBarButtonItem *)sender
{
  [self clearTramData];
  [self loadTramData];
}

- (void)loadTramData
{
    self.loadingNorth = YES;
    self.loadingSouth = YES;

    //NOTE: request the model to retrieve data for the trams
    [_timeTableModel loadTramData];
}

/*
 Callback function (Delegate) from the data model to indicate that tram time-table has arrived
 */
-(void)displayTimeTable:(HomeTimeData *) tramData
{
    //Check data for which direction has arrived and populate data accordingly
    if ([tramData.strDirection isEqualToString:NORTH]) {
        self.northTrams = tramData.arrivalTime;
    }
    else if ([tramData.strDirection isEqualToString:SOUTH]) {
        self.southTrams = tramData.arrivalTime;
    }
    [self.tramTimesTable reloadData];
    
}

-(void)failToLoadTimeTable:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:error
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK" ,nil];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
      return (section == 0) ? NORTH : SOUTH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      if (section == 0)
      {
            return (self.northTrams != nil) ? self.northTrams.count : 1;
      }
      else
      {
            return (self.southTrams != nil) ? self.southTrams.count : 1;
      }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TramCellIdentifier" forIndexPath:indexPath];
      
      NSArray *trams = [self tramsForSection:indexPath.section];
      if (trams != nil)
      {
            NSDictionary *tram = trams[indexPath.row];
            NSString *arrivalDateString = tram[@"PredictedArrivalDateTime"];
            DotNetDateConverter *dateConverter = [[DotNetDateConverter alloc] init];
            NSMutableString *strArrivalDateWithDue = [[NSMutableString alloc] initWithString:[dateConverter formattedDateFromString:arrivalDateString]];
          
            //NOTE: if the json structure also returned a parameter for "how far away the tram is from the current time"
            //we could fetch it as tram["MinutesToGo"] and append it to strArrivalDateWithDue. But right now I'm just hardcoding the string.
            [strArrivalDateWithDue appendString:@" (3 mins)"];
            cell.textLabel.text = strArrivalDateWithDue;
      }
      else if([self isLoadingSection:indexPath.section])
      {
            cell.textLabel.text = @"Loading upcoming trams...";
      }
      else
      {
            cell.textLabel.text = @"No upcoming trams. Tap load to fetch";
      }
      
      return cell;
}

- (NSArray *)tramsForSection:(NSInteger)section
{
      return (section == 0) ? self.northTrams : self.southTrams;
}

- (BOOL)isLoadingSection:(NSInteger)section
{
      return (section == 0) ? self.loadingNorth : self.loadingSouth;
}

#pragma mark - UITableViewDelegate


@end
