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
	self.numberUpdate = @(0);
	
	//--Same with this
	self.textUpdate = [NSString stringWithFormat:@"%@", [NSDate date]];
	
	[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateValueProcess) userInfo:nil repeats:YES];
}

- (void)updateValueProcess
{
	//--grabing new value
	NSInteger nextUpdate = [self.numberUpdate integerValue];
	
	//--UI automatic update via binding for free! You are welcome!
	self.numberUpdate = @(nextUpdate++);
	
	//--same with this
	self.textUpdate = [NSString stringWithFormat:@"%@", [NSDate date]];
}

@end
