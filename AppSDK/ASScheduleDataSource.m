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
	ASCounterTask *counterTask = [self counterTaskAtIndexPath:indexPath];
	counterTask.timeInterval = timeInterval;
}

- (NSString *)masterCountText
{
	return [NSString stringWithFormat:@"%ld", self.masterCount];
}

@end
