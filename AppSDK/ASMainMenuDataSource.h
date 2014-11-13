//
//  ASMainMenuDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ASMenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) Class viewControllerClass;

@end

@interface ASMainMenuDataSource : ULViewDataSource

@property (nonatomic, strong) NSMutableArray *topicList;

- (ASMenuItem *)menuItemAtIndexPath:(NSIndexPath *)indexPath;

@end
