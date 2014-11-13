//
//  ALScheduledTask.h
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ALScheduledTaskHandler)();

@interface ALScheduledTask : NSObject

@property (nonatomic, readonly) NSString *taskID;

- (id)initWithTaskInterval:(NSTimeInterval)interval taskBlock:(ALScheduledTaskHandler)taskBlock;

#pragma mark - Scheduling

/**
 *  start scheduling the task on specified interval.
 *	this only put the task on schedule. To execute it immediately, use triggerTask
 */
- (void)start;

/**
 *  stop scheduling the task
 *	this does not interupt the task that is currently executing
 */
- (void)stop;

/**
 *  execute the task immediately, does not affecting any scheduling
 */
- (void)triggerTask;

#pragma mark - Termination Flags

/**
 *  adding a set of notification flags that would terminate the schedule of the task
 *
 *  @param terminationFlags a string array of notification names
 */
- (void)setTerminationFlags:(NSArray *)terminationFlags;

/**
 *  adding a notification flag that terminate the schedule of the task
 *
 *  @param terminationFlag the notification name
 */
- (void)addTerminationFlag:(NSString *)terminationFlag;

/**
 *  removing a notification flag that terminate the schedule of the task
 *
 *  @param terminationFlag the notification name
 */
- (void)removeTerminationFlag:(NSString *)terminationFlag;

#pragma mark - Resume Flags

/**
 *  adding a set of notification flags that would resume the schedule of the task
 *
 *  @param resumeFlags a string array of notification names
 */
- (void)setResumeFlags:(NSArray *)resumeFlags;

/**
 *  adding a notification flag that resume the schedule of the task
 *
 *  @param resumeFlag the notification name
 */
- (void)addResumeFlag:(NSString *)resumeFlag;

/**
 *  removing a notification flag that terminate the schedule of the task
 *
 *  @param resumeFlag the notification name
 */
- (void)removeResumeFlag:(NSString *)resumeFlag;

@end
