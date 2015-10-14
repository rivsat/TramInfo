//
//  HomeTimeModel.h
//  HomeTime
//
//  Created by Tasvir H Rohila on 18/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#ifndef HomeTime_HomeTimeModel_h
#define HomeTime_HomeTimeModel_h
#import "HomeTimeData.h"

@protocol HomeTimeModelDelegate <NSObject>

@required
-(void)displayTimeTable:(HomeTimeData *) tramData;

@optional
- (void)failWithException:(NSException *)exception;
-(void)failToLoadTimeTable:(NSString *)error;

@end

@interface HomeTimeModel : NSObject

//Public Methods
- (void)loadTramData;

//delegate
@property (nonatomic, weak) id<HomeTimeModelDelegate> homeTimedelegate;

@end



#endif
