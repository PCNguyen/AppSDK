//
//  ASScheduleDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ASCounterTask : NSObject

@property (nonatomic, strong) NSString *counterID;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSInteger currentCount;

@end

@interface ASScheduleDataSource : ULViewDataSource

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger masterCount;
@property (nonatomic, strong) NSArray *counterList;

- (ASCounterTask *)counterTaskAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateTimeInterval:(NSTimeInterval)timeInterval forIndexPath:(NSIndexPath *)indexPath;

- (NSString *)masterCountText;

@end
