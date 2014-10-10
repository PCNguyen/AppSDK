//
//  NSUserDefaults+DL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSUserDefaults+DL.h"

@implementation NSUserDefaults (DL)

+ (void)dl_saveValue:(id)object forKey:(NSString *)key
{
	[self dl_saveObject:object forKey:key sync:YES];
}

+ (void)dl_saveObject:(id)object forKey:(NSString *)key sync:(BOOL)shouldSync
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:object];
	[userDefaults setObject:objectData forKey:key];
	
	if (shouldSync) {
		[userDefaults synchronize];
	}
}

+ (id)dl_loadValueForKey:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *objectData = [userDefaults objectForKey:key];
	
	id object = nil;
	
	if (objectData.length > 0) {
		object = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
	}
    
	return object;
}

@end
