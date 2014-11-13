//
//  ULManagedDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ULManagedDataSource : ULViewDataSource

@property (nonatomic, strong) NSArray *managedServices;

#pragma mark - Managed Service

/***
 * register this dataSource with USDataSourceManager
 */
- (void)setManagedService:(NSString *)managedService;

/***
 * register this dataSource with USDataSourceManager for multiple services
 */
- (void)setManagedServices:(NSArray *)managedServices;

/***
 * unRegister this dataSource from ULDataSourceManager
 * 
 * IMPORTANT:Should be called on when dealloc view
 */
- (void)removeCurrentManagedService;

/**
 *  trigger loadData on all existing instance of this class
 */
- (void)loadDataForAllExistingInstances;

#pragma mark - Subclass Hook

/***
 * this get called on [ULDataSourceManager notifyDataSourcesOfService:]
 * if managedService match notified service
 * if not override, it will call loadData by default
 */
- (void)handleDataUpdatedForService:(NSString *)serviceName;

@end
