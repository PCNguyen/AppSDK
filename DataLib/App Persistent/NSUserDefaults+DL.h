//
//  NSUserDefaults+DL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DL)

/**
 *  save the value to NSUserDefault and synchornize immediately
 *
 *  @param object the object to be stored
 *  @param key    the key to identify the object
 */
+ (void)dl_saveValue:(id)object forKey:(NSString *)key;

/**
 *  save the value to NSUserDefault with the option to sync immediately or not
 *
 *  @param object     the object to be stored
 *  @param key        the key to identify the object
 *  @param shouldSync whether or not we should call synchronize on NSUserDefault
 */
+ (void)dl_saveObject:(id)object forKey:(NSString *)key sync:(BOOL)shouldSync;

/**
 *  load the value stored in NSUserDefault based on specific key
 *
 *  @param key the key to identify the object
 *
 *  @return the stored object
 */
+ (id)dl_loadValueForKey:(NSString *)key;

@end
