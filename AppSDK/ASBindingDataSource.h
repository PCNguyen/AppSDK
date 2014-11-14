//
//  ASBindingDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ASBindingDataSource : ULViewDataSource

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *textUpdate;

@property (nonatomic, strong) NSNumber *numberUpdate;

@end
