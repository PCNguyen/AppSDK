//
//  ULManagedDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULManagedDataSource.h"
#import "ULDataSourceManager.h"

@implementation ULManagedDataSource

- (id)init
{
	if (self = [super init]) {
		[self ignoreUpdateProperty:@selector(managedServices)];
	}
	
	return self;
}

#pragma mark - Managed Service

- (void)setManagedService:(NSString *)managedService
{
	if ([self.managedServices count] > 0) {
		[self removeCurrentManagedService];
	}
	
	if ([managedService length] > 0) {
		_managedServices = @[managedService];
		[[ULDataSourceManager sharedManager] registerDataSource:self forService:managedService];
	}
}

- (void)setManagedServices:(NSArray *)managedServices
{
	_managedServices = managedServices;
	for (NSString *service in self.managedServices) {
		if ([service length] > 0) {
			[[ULDataSourceManager sharedManager] registerDataSource:self forService:service];
		}
	}
}

- (void)removeCurrentManagedService
{
	for (NSString *service in self.managedServices) {
		if ([service length] > 0) {
			[[ULDataSourceManager sharedManager] unRegisterDataSource:self fromService:service];
		}
	}
}

- (void)loadDataForAllExistingInstances
{
	[[ULDataSourceManager sharedManager] loadDataForAllClassInstances:[self class]];
}

#pragma mark - Subclass Hook

- (void)handleDataUpdatedForService:(NSString *)serviceName
{
	/* Subclass Override this */
	
	[self loadData];
}

@end
