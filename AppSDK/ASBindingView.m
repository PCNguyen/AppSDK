//
//  ASBindingView.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASBindingView.h"
#import "UIView+DataBinding.h"

@interface ASBindingView ()

@property (nonatomic, strong) UILabel *dynamicLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ASBindingView

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.dynamicLabel];
		[self addSubview:self.numberLabel];
		
		//--DEBUG: Comment this out to see what happen
		[self ul_setLayoutOnDataChange:YES];
		
		//--load initial data
		[[self dataSource] loadData];
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.dynamicLabel.frame = [self dynamicLabelFrame];
	self.numberLabel.frame = [self numberLabelFrame:self.dynamicLabel.frame];
}

#pragma mark - ULViewDataBinding Protocol

- (Class)ul_binderClass
{
	return [ASBindingDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{
			 @"dynamicLabel.text":@"textUpdate",      //--direct bind to ui element
			 @"handleNumberUpdate:":@"numberUpdate"   //--bind to a method handler
			 };
}

- (ASBindingDataSource *)dataSource
{
	return (ASBindingDataSource *)[self ul_currentBinderSource]; //--convenient access to binder source via UIView categorys
}

- (void)handleNumberUpdate:(NSNumber *)number
{
	self.numberLabel.text = [NSString stringWithFormat:@"%@", number];
}

#pragma mark - Dynamic Label

- (CGRect)dynamicLabelFrame
{
	CGFloat xOffset = 5.0f;
	CGFloat yOffset = 5.0f;
	CGFloat height = 20.0f;
	CGFloat width = [self.dynamicLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)dynamicLabel
{
	if (!_dynamicLabel) {
		_dynamicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_dynamicLabel.backgroundColor = [UIColor greenColor];
		_dynamicLabel.textAlignment = NSTextAlignmentLeft;
		_dynamicLabel.font = [UIFont systemFontOfSize:18.0f];
	}
	
	return _dynamicLabel;
}

#pragma mark - Number label

- (CGRect)numberLabelFrame:(CGRect)preferenceFrame
{
	CGFloat xOffset = preferenceFrame.origin.x + preferenceFrame.size.width + 10.0f;
	CGFloat yOffset = preferenceFrame.origin.y;
	CGFloat height = 20.0f;
	CGFloat width = [self.numberLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)numberLabel
{
	if (!_numberLabel) {
		_numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_numberLabel.backgroundColor = [UIColor yellowColor];
		_numberLabel.textAlignment = NSTextAlignmentLeft;
		_numberLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	}
	
	return _numberLabel;
}

@end
