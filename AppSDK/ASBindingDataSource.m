//
//  ASBindingDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASBindingDataSource.h"

@implementation ASBindingDataSource

- (instancetype)init
{
	if (self = [super init]) {
		[self ignoreUpdateProperty:@selector(timer)];
	}
	
	return self;
}

#pragma mark - ULViewDataSource Subclass

/**
 *  Overide this to provide initial data
 */
- (void)loadData
{
	//--UI Automatic update when value is set
	self.numberUpdate = @(3);
	
	[self updateText];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateValueProcess) userInfo:nil repeats:YES];
}

- (void)updateValueProcess
{
	//--grabing new value
	NSInteger nextUpdate = [self.numberUpdate integerValue] + 1;
	
	//--use begin and end batch update when changing multiple item
	[self beginBatchUpdate];
	self.numberUpdate = @(nextUpdate);
	[self updateText];
	[self endBatchUpdate];
}

- (void)updateText
{
	NSString *timeStamp = [NSString stringWithFormat:@"%@", [NSDate date]];
	NSInteger subStringLength = [self.numberUpdate integerValue] % 7;
	
	//--UI Automatic update when value is set
	self.textUpdate = [timeStamp  substringToIndex:subStringLength];
}

@end
