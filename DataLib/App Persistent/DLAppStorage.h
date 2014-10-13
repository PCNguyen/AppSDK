//
//  DLAppStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

@class DLAppStorage;

@protocol DLAppStorageDelegate <NSObject>

@optional

/**
 *  provide an entry point to custom save cache object with calculating cost
 *	default to save to cache without cost calculation
 *
 *  @param storage the appStorage
 *  @param object  the object to be saved to cache
 *  @param key     the key to identify the object
 */
- (void)appStorage:(DLAppStorage *)storage saveCacheObject:(id)object forKey:(NSString *)key;

/**
 *  provide an entry point to custom remove cache object
 *
 *  @param storage the appStorage
 *  @param key     the key to identify the object
 */
- (void)appStorage:(DLAppStorage *)storage removeCacheObjectForKey:(NSString *)key;

@end

@interface DLAppStorage : DLStorage

@property (nonatomic, weak) id<DLAppStorageDelegate>delegate;

/**
 *  Save specific value for key, nil to remove the previous value
 *	Will also save to cache if cache is enabled
 *	Saving nil will remove persistent and cache object for the particular key
 *
 *  @param value the object to be saved
 *  @param key   the key to identifi the object
 */
- (void)saveValue:(id)value forKey:(NSString *)key;

/**
 *  load the previous saved value, 
 *	if cache is enable, it will load from cache first
 *
 *  @param key the key to identify the object
 *
 *  @return the object in cache or persisted object if cache not exist
 */
- (id)loadValueForKey:(NSString *)key;

@end
