//
//  AppLibShared.h
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#ifndef AppSDK_AppLibShared_h
#define AppSDK_AppLibShared_h

/***************************************
 * Macros
 ***************************************/

#define SHARE_INSTANCE_BLOCK(block) \
	static dispatch_once_t onceToken; \
	__strong static id _sharedObject = nil; \
	dispatch_once(&onceToken, ^{ \
		_sharedObject = block(); \
	}); \
	return _sharedObject; \

#endif
