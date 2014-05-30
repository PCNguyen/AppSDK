//
//  NSObject+AL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AL)

#pragma mark - Swizzling

+ (void)al_swizzleSelector:(SEL)originalSelector bySelector:(SEL)swizzledSelector dispatchToken:(dispatch_once_t)onceToken;

#pragma mark - Associate Object

- (id)al_setAssociateObjectWithSelector:(SEL)objectSelector;

- (id)al_associateObjectForSelector:(SEL)selector;

#pragma mark - Perform Selector

- (id)al_objectFromSelector:(SEL)selector;

- (void)al_performSelector:(SEL)selector withObject:(id)object;

@end
