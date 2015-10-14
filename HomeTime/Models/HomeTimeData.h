//
//  HomeTimeData.h
//  HomeTime
//
//  Created by Tasvir H Rohila on 18/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#ifndef HomeTime_HomeTimeData_h
#define HomeTime_HomeTimeData_h

//Class that serves as data structure for holding the time-table
@interface HomeTimeData : NSObject

@property (nonatomic, strong) NSArray* arrivalTime;
@property (nonatomic, strong) NSArray* minutesToGo; //For future use
@property (nonatomic, strong) NSString* strDirection;

/*
 Class Methods
 */
//  Method to init the object.
-(id) initWithTimeTable: (NSArray *) timeTable forDirection:(NSString*) direction;

@end

#endif
