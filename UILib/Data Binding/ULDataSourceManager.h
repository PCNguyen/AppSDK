//
//  ULDataSourceManager.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULManagedDataSource;

@interface ULDataSourceManager : NSObject

+ (instancetype)sharedManager;

- (void)registerDataSource:(ULManagedDataSource *)dataSource forService:(NSString *)serviceName;

- (void)unRegisterDataSource:(ULManagedDataSource *)dataSource fromService:(NSString *)serviceName;

- (void)notifyDataSourcesOfService:(NSString *)serviceName;

@end
