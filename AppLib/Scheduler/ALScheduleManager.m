//
//  ALScheduleManager.m
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALScheduleManager.h"
#import "AppLibShared.h"

@interface ALScheduleManager ()

@property (nonatomic, strong) NSMutableArray *scheduleList;

@end

@implementation ALScheduleManager

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

- (instancetype)init
{
	if (self = [super init]) {
		_defaultTimeInterval = [ALScheduledTask defaultScheduleInterval];
		_defaultTerminationFlags = [ALScheduledTask defaultTerminationFlags];
		_defaultResumeFlags = [ALScheduledTask defaultResumeFlags];
	}
	
	return self;
}

#pragma mark - Scheduling

- (ALScheduledTask *)scheduleTaskBlock:(void (^)())taskBock
{
	ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:self.defaultTimeInterval taskBlock:taskBock];
	[scheduledTask setTerminationFlags:self.defaultTerminationFlags];
	[scheduledTask setResumeFlags:self.defaultResumeFlags];
	[scheduledTask start];
	
	[self.scheduleList addObject:scheduledTask];
	return scheduledTask;
}

- (void)scheduleTask:(ALScheduledTask *)task
{
	if (task) {
		[task start];
		[self.scheduleList addObject:task];
	}
}

#pragma mark - Unscheduling

- (void)unScheduleTaskID:(NSString *)taskID
{
	ALScheduledTask *runningTask = [self scheduledTaskForID:taskID];
	if (runningTask) {
		[runningTask stop];
		[self.scheduleList removeObject:runningTask];
	}
}

#pragma mark - Accessing

- (ALScheduledTask *)scheduledTaskForID:(NSString *)taskID
{
	NSPredicate *idMatchPredicate = [NSPredicate predicateWithFormat:@"taskID == %@", taskID];
	NSArray *matchedTask = [self.scheduleList filteredArrayUsingPredicate:idMatchPredicate];
	if ([matchedTask count] > 0) {
		return [matchedTask firstObject];
	}
	
	return nil;
}

@end
