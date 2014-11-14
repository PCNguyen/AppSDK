//
//  DLAppStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLAppStorage.h"
#import "DataLibShared.h"

@implementation DLAppStorage

- (void)saveValue:(id)value forKey:(NSString *)key
{
	if (self.enableCache) {
		if (value) {
			[self saveCacheObject:value forKey:key];
		} else {
			[self removeCacheObjectForKey:key];
		}
	}
		
	[NSUserDefaults dl_saveValue:value forKey:key];
}

- (id)loadValueForKey:(NSString *)key
{
	if (self.enableCache) {
		return [[self cache] objectForKey:key];
	}
	
	return [NSUserDefaults dl_loadValueForKey:key];
}

- (void)wipe
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[NSUserDefaults dl_wipe];
}

- (void)wipeExceptKeys:(NSArray *)excludedKeys
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[NSUserDefaults dl_wipeExceptKeys:excludedKeys];
}

- (void)saveCacheObject:(id)object forKey:(NSString *)key
{
	if ([self.delegate respondsToSelector:@selector(appStorage:saveCacheObject:forKey:)]) {
		[self.delegate appStorage:self saveCacheObject:object forKey:key];
	} else {
		[[self cache] setObject:object forKey:key];
	}
}

- (void)removeCacheObjectForKey:(NSString *)key
{
	if ([self.delegate respondsToSelector:@selector(appStorage:removeCacheObjectForKey:)]) {
		[self.delegate appStorage:self removeCacheObjectForKey:key];
	} else {
		[[self cache] removeObjectForKey:key];
	}
}

@end
