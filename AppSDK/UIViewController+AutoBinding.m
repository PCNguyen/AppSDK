//
//  UIViewController+AutoBinding.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIViewController+AutoBinding.h"
#import "UIViewController+DataBinding.h"
#import "UIView+DataBinding.h"

#import "AppLibExtension.h"

@implementation UIViewController (AutoBinding)

+ (void)load
{
	static dispatch_once_t token;
	[self al_swizzleSelector:@selector(viewDidLoad)
				  bySelector:@selector(__swizzlingViewWillDidLoad)
			   dispatchToken:token];
	[self al_swizzleSelector:@selector(viewWillAppear:)
				  bySelector:@selector(viewWillAppear:) dispatchToken:token];
}

#pragma mark - SWIZZLING - DANGEROUS STUFF

- (void)__swizzlingViewWillDidLoad
{
	[self __swizzlingViewWillDidLoad];
	
	[self ul_loadData]; //--load data on view controller
	
	for (UIView *subView in self.view.subviews) {
		[subView ul_loadData]; //--load data on sub view
	}
}

@end
