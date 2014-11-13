//
//  ASBindingViewController.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASBindingViewController.h"
#import "ASBindingView.h"
#import "UIViewController+UL.h"

@interface ASBindingViewController ()

@property (nonatomic, strong) UILabel *dynamicWidthLabel;
@property (nonatomic, strong) ASBindingView *autoUpdateView;

@end

@implementation ASBindingViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self ul_adjustIOS7Boundaries];
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self.view addSubview:self.dynamicWidthLabel];
	[self.view addSubview:self.autoUpdateView];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.autoUpdateView.frame = [self autoUpdateFrame];
	self.dynamicWidthLabel.frame = [self dynamicWidthLabelFrame:self.autoUpdateView.frame];
}

#pragma mark - ULViewDataBinding Protocol

- (Class)ul_binderClass
{
	return [ASBindingDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"dynamicWidthLabel.text":@"textUpdate"};
}

#pragma mark - Label

- (CGRect)dynamicWidthLabelFrame:(CGRect)preferenceFrame
{
	CGFloat xOffset = preferenceFrame.origin.x + preferenceFrame.size.width;
	CGFloat yOffset = preferenceFrame.origin.y;
	CGFloat height = 40.0f;
	CGFloat width = [self.dynamicWidthLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)dynamicWidthLabel
{
	if (!_dynamicWidthLabel) {
		_dynamicWidthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_dynamicWidthLabel.backgroundColor = [UIColor yellowColor];
		_dynamicWidthLabel.font = [UIFont systemFontOfSize:18.0f];
		_dynamicWidthLabel.textAlignment = NSTextAlignmentLeft;
		_dynamicWidthLabel.numberOfLines = 1;
	}
	
	return _dynamicWidthLabel;
}

#pragma mark - autoUpdateView

- (CGRect)autoUpdateFrame
{
	CGFloat xOffset = 10.0f;
	CGFloat yOffset = 50.0f;
	CGFloat height = 100.0f;
	CGFloat width = 200.0f;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (ASBindingView *)autoUpdateView
{
	if (!_autoUpdateView) {
		_autoUpdateView = [[ASBindingView alloc] initWithFrame:CGRectZero];
		_autoUpdateView.backgroundColor = [UIColor redColor];
	}
	
	return _autoUpdateView;
}

@end
