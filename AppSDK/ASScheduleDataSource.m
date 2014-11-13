//
//  ASScheduleDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASScheduleDataSource.h"
#import "NSArray+AL.h"

@implementation ASScheduleDataSource

- (void)loadData
{

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
