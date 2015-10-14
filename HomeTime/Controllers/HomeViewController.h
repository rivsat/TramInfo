//
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTimeModel.h"
#import "HomeTimeModel.h"

//NOTE: I've renamed ViewController to HomeViewController to clearly distinguish it from other viewControllers that may get added (for additional functionality)
@interface HomeViewController : UIViewController <HomeTimeModelDelegate>

//function to clear tram data
- (void)clearTramData;

//Model object to fetch time table over the network
@property (nonatomic, strong) HomeTimeModel *timeTableModel;

@end

