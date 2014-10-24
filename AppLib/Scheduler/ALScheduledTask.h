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

- (id)initWithTaskInterval:(NSTimeInterval)interval taskBlock:(ALScheduledTaskHandler)taskBlock;

#pragma mark - Scheduling

- (void)start;
- (void)stop;
- (void)triggerTask;

@end
