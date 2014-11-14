//
//  ASScheduleDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASScheduleDataSource.h"
#import "NSArray+AL.h"
#import "ALScheduleManager.h"

#define kSDSCounterNumber				6
#define kSDSDefaultTimeInterval			2

/*************************
 *  ASCounterTask
 *************************/
@implementation ASCounterTask

@end

#pragma mark -

/*************************
 *  ASScheduleDataSource
 *************************/
@implementation ASScheduleDataSource

- (void)dealloc
{
	[[ALScheduleManager sharedManager] unScheduleAllTasks];
}

- (void)loadData
{
	[self beginBatchUpdate];
	self.masterCount = 0;
	
	NSMutableArray *counterList = [NSMutableArray array];
	
	for (int i = 0; i < 6; i++) {
		ASCounterTask *counterTask = [ASCounterTask new];
		counterTask.currentCount = i;
		counterTask.timeInterval = kSDSDefaultTimeInterval;
		counterTask.counterID = [NSString stringWithFormat:@"%d", i];
		
		[counterList addObject:counterTask];
	}
	
	self.counterList = counterList;
	[self endBatchUpdate];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateMasterCount) userInfo:nil repeats:YES];
	for (ASCounterTask *counterTask in self.counterList) {
		
		//--to not capture the counter task in block since it will be dealloc when list updated
		NSString *counterID = counterTask.counterID;
		__weak ASScheduleDataSource *selfPointer = self;
		
		//--create the schedule task
		ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:counterTask.timeInterval taskBlock:^{
			if (selfPointer) {
				NSMutableArray *updatedArray = [NSMutableArray arrayWithArray:selfPointer.counterList];
				for (ASCounterTask *counterTask in updatedArray) {
					if ([counterTask.counterID isEqualToString:counterID]) {
						counterTask.currentCount = counterTask.currentCount + 1;
						break;
					}
				}
				
				self.counterList = [NSArray arrayWithArray:updatedArray];
			}
			
		}];
		
		[scheduledTask setTerminationFlags:[ALScheduledTask defaultTerminationFlags]];
		[scheduledTask setResumeFlags:[ALScheduledTask defaultResumeFlags]];
		
		[[ALScheduleManager sharedManager] scheduleTask:scheduledTask];
	}
}

- (NSDictionary *)selectiveUpdateMap
{
	return @{@"masterCountText":@"masterCount"};
}

- (ASCounterTask *)counterTaskAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.counterList al_objectAtIndex:indexPath.item];
}

- (void)updateTimeInterval:(NSTimeInterval)timeInterval forIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *updatedArray = [NSMutableArray arrayWithArray:self.counterList];
	ASCounterTask *counterTask = [updatedArray al_objectAtIndex:indexPath.item];
	if (counterTask) {
		counterTask.timeInterval = timeInterval;
		self.counterList = [NSArray arrayWithArray:updatedArray];
	}
}

- (NSString *)masterCountText
{
	return [NSString stringWithFormat:@"%ld", self.masterCount];
}

#pragma mark - Updater

- (void)updateMasterCount
{
	self.masterCount = self.masterCount + 1;
}

@end
