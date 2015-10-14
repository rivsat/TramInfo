//
//  HomeTimeDataSpec.m
//  HomeTime
//
//  Created by Tasvir H Rohila on 19/08/15.
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "HomeTimeData.h"
#import "Defines.h"

@interface HomeTimeData (Spec)

@property (nonatomic, strong) NSArray* arrivalTime;
@property (nonatomic, strong) NSArray* minutesToGo;
@property (nonatomic, strong) NSString* strDirection;

@end


/*
 describe "what I want"
 context "the context I am in"
 it "should do something"
 context...
 */
SPEC_BEGIN(HomeTimeDataSpec)
describe(@"Tests for HomeTimeData", ^{
    __block HomeTimeData *objHomeTimeData = Nil;
    __block NSArray *arrSchedule;
    arrSchedule = @[@{@"PredictedArrivalDateTime": @"/Date(1426821588000+1100)/"}];
    beforeAll(^{
        objHomeTimeData = [[HomeTimeData alloc] initWithTimeTable:arrSchedule forDirection:NORTH];
    });
    
    afterAll(^{
        
        objHomeTimeData = nil;
        
    });
    
    //init
    context(@"When initialising a new HomeTimeData object", ^{
        
        it(@"HomeTimeModel should not be Nil", ^{
            [objHomeTimeData shouldNotBeNil];
        });//it
        
    });//context
    
    //init
    context(@"When populating HomeTimeData object", ^{
        
        it(@"arrivalTime should exist", ^{
            NSDictionary *dic = objHomeTimeData.arrivalTime[0];
            NSString * value = [dic valueForKey:@"PredictedArrivalDateTime"];
            [[value should] equal:@"/Date(1426821588000+1100)/"];
        });//it
        
    });//context
}); //describe

SPEC_END
