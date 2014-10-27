//
//  ASScheduleDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ASCounterTask : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSInteger currentCount;

@end

@interface ASScheduleDataSource : ULViewDataSource

@property (nonatomic, strong) NSNumber *masterCount;
@property (nonatomic, strong) NSArray *counterList;

@end
