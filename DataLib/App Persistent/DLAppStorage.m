//
//  DLAppStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLAppStorage.h"
#import "NSUserDefaults+DL.h"

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

@end
