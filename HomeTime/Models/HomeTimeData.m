//
//  HomeTimeData.m
//  HomeTime
//
//  Created by Tasvir H Rohila on 18/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTimeData.h"

@implementation HomeTimeData

-(id) initWithTimeTable: (NSArray *) timeTable forDirection:(NSString *)direction
{
    self = [super init];
    if (self)
    {
        _arrivalTime = timeTable;
        _strDirection = direction;
    }
    return self;
}

@end
