//
//  ASBindingDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASBindingDataSource.h"

@implementation ASBindingDataSource

#pragma mark - ULViewDataSource Subclass

/**
 *  Overide this to provide initial data
 */
- (void)loadData
{
	//--UI Automatic update when value is set
	self.numberUpdate = @(3);
	
	[self updateText];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateValueProcess) userInfo:nil repeats:YES];
}

- (void)updateValueProcess
{
	//--grabing new value
	NSInteger nextUpdate = [self.numberUpdate integerValue] + 1;
	
	//--UI Automatic update when value is set
	self.numberUpdate = @(nextUpdate);
	
	[self updateText];
}

- (NSDictionary *)selectiveUpdateMap
{
	return @{}; //--need to fix this
}

- (void)updateText
{
	NSString *timeStamp = [NSString stringWithFormat:@"%@", [NSDate date]];
	NSInteger subStringLength = [self.numberUpdate integerValue] % 7;
	
	//--UI Automatic update when value is set
	self.textUpdate = [timeStamp  substringToIndex:subStringLength];
}

@end
