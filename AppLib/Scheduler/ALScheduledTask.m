//
//  ALScheduledTask.m
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALScheduledTask.h"

@interface ALScheduledTask ()

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (readwrite, copy) ALScheduledTaskHandler taskBlock;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *terminationFlags;

@end

@implementation ALScheduledTask

- (id)initWithTaskInterval:(NSTimeInterval)interval taskBlock:(ALScheduledTaskHandler)taskBlock
{
	if (self = [super init]) {
		_timeInterval = interval;
		_taskBlock = taskBlock;
	}
	
	return self;
}

#pragma mark - Scheduling

- (void)start
{
	self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(triggerTask) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stop
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)triggerTask
{
	if (self.taskBlock) {
		self.taskBlock();
	}
}

#pragma mark - Termination Flag

@end
