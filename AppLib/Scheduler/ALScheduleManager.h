//
//  ALScheduleManager.h
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALScheduledTask.h"

@interface ALScheduleManager : NSObject

@property (nonatomic, assign) NSTimeInterval defaultTimeInterval;
@property (nonatomic, strong) NSArray *defaultTerminationFlags;
@property (nonatomic, strong) NSArray *defaultResumeFlags;

+ (instancetype)sharedManager;

#pragma mark - Scheduling

- (ALScheduledTask *)scheduleTaskBlock:(void (^)())taskBock;

- (void)scheduleTask:(ALScheduledTask *)task;

#pragma mark - Unscheduling

- (void)unScheduleTaskID:(NSString *)taskID;

#pragma mark - Accessing

- (ALScheduledTask *)scheduledTaskForID:(NSString *)taskID;

@end
