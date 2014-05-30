//
//  ULDataSourceManager.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULDataSourceManager.h"
#import "ULManagedDataSource.h"

@interface ULDataSourceManager ()

@property (nonatomic, strong) NSMutableDictionary *registeredDataSources;

@end

@implementation ULDataSourceManager

+ (instancetype)sharedManager
{
	static ULDataSourceManager *manager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		manager = [[ULDataSourceManager alloc] init];
		
	});
	
	return manager;
}

- (NSMutableDictionary *)registeredDataSources
{
	if (!_registeredDataSources) {
		_registeredDataSources = [[NSMutableDictionary alloc] init];
	}
	
	return _registeredDataSources;
}

- (void)notifyDataSourcesOfService:(NSString *)serviceName
{
	NSSet *dataSources = [self dataSourcesForService:serviceName];
	
	for (ULManagedDataSource *subscribedDataSource in dataSources) {
		[subscribedDataSource handleDataUpdatedForService:serviceName];
	}
	
}

- (void)registerDataSource:(ULManagedDataSource *)dataSource forService:(NSString *)serviceName
{
	NSSet *existingDataSources = [self dataSourcesForService:serviceName];
	NSMutableSet *modifiedDataSources = [existingDataSources mutableCopy];
	
	if (dataSource) {
		[modifiedDataSources addObject:dataSource];
		[self.registeredDataSources setValue:modifiedDataSources forKey:serviceName];
	}
}

- (void)unRegisterDataSource:(ULManagedDataSource *)dataSource fromService:(NSString *)serviceName
{
	NSSet *existingDataSources = [self dataSourcesForService:serviceName];
	NSMutableSet *modifiedDataSources = [existingDataSources mutableCopy];
	
	if ([modifiedDataSources containsObject:dataSource]) {
		[modifiedDataSources removeObject:dataSource];
		[self.registeredDataSources setValue:modifiedDataSources forKey:serviceName];
	}
}

#pragma mark - Private

- (NSSet *)dataSourcesForService:(NSString *)serviceName
{
	NSSet *serviceDataSources = [self.registeredDataSources valueForKey:serviceName];
	if (serviceDataSources == nil) {
		serviceDataSources = [NSSet set];
	}
	
	return serviceDataSources;
}

@end
