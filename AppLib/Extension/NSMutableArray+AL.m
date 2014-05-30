//
//  NSMutableArray+AL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSMutableArray+AL.h"

@implementation NSMutableArray (AL)

- (void)al_addObject:(id)object
{
	if (object) {
		[self addObject:object];
	}
}

@end
