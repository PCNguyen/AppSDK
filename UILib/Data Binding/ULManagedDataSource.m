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
		[self ignoreUpdateProperty:@selector(serializedQueue)];
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

#pragma mark - Threading

- (void)serializedBlock:(void (^)())actionBlock
{
	[self.serializedQueue addOperationWithBlock:actionBlock];
}

- (NSOperationQueue *)serializedQueue
{
	if (!_serializedQueue) {
		_serializedQueue = [[NSOperationQueue alloc] init];
		_serializedQueue.maxConcurrentOperationCount = 1;
	}
	
	return _serializedQueue;
}

#pragma mark - Subclass Hook

- (void)handleDataUpdatedForService:(NSString *)serviceName
{
	/* Subclass Override this */
	
	[self loadData];
}

- (void)handleDataUpdatedForService:(NSString *)serviceName error:(NSError *)error
{
	/* Subclass Override this */
	
	if (!error) {
		[self handleDataUpdatedForService:serviceName];
	}
}

@end
