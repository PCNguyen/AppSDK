//
//  DLStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLStorage : NSObject

/**
 *  if cache is disable, object are written directly to persistent store
 *	default is YES if a cache is provided with initWithCache:
 */
@property (nonatomic, assign) BOOL enableCache;

/**
 *  construct a storage with a cache
 *
 *  @param cache the cache to store data
 *
 *  @return instance of DLStorage
 */
- (instancetype)initWithCache:(NSCache *)cache;

/**
 *  lazy created a cache if one is not provided in the constructor
 *	the default cache created will have maximum cost and limit
 *
 *  @return the interal cache for storage
 */
- (NSCache *)cache;

@end
