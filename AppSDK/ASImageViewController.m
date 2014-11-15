//
//  ASImageViewController.m
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASImageViewController.h"
#import "UIView+LayoutPosition.h"
#import "UIViewController+UL.h"

@interface ASImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ASImageViewController

- (instancetype)initWithImage:(UIImage *)image
{
	if (self = [super init]) {
		self.imageView.image = image;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.imageView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self layoutViews];
}

- (void)layoutViews
{
	[self.view addConstraints:[self.imageView ul_pinWithInset:UIEdgeInsetsZero]];
}

#pragma mark - WebView

- (UIImageView *)imageView
{
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithImage:nil];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[_imageView ul_enableAutoLayout];
	}
	
	return _imageView;
}

@end
