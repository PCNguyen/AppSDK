//
//  UIView+DataBinding.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ULViewDataSource.h"

@interface UIView (DataBinding) <ULViewDataSourceBindingDelegate>

- (ULViewDataSource *)ul_currentBinderSource;

@end