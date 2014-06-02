//
//  UIViewController+DataBinding.h
//  UISDK
//
//  Created by PC Nguyen on 5/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ULViewDataSource.h"

@interface UIViewController (DataBinding) <ULViewDataSourceBindingDelegate>

- (ULViewDataSource *)ul_currentBinderSource;

- (BOOL)bindingExist;

@end
