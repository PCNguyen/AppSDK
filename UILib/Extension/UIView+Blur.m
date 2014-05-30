//
//  UIView+Blur.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+Blur.h"
#import "UIImage+StackBlur.h"

static int kUIViewBlurOverlayTag = -2000;

@implementation UIView (Blur)

- (UIImage *)ul_screenShot
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[[self layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return screenshot;
}

- (UIImageView *)__blurImageView
{
	UIImage *screenShot = [self ul_screenShot];
	screenShot = [screenShot ul_stackBlur:10];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:screenShot];
	imageView.frame = self.bounds;
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.tag = kUIViewBlurOverlayTag;
	
	return imageView;
}

- (void)ul_blur
{
	[self ul_clearBlur];
	[self addSubview:[self __blurImageView]];
}

- (void)ul_clearBlur
{
	for (UIView *subView in self.subviews) {
		if (subView.tag == kUIViewBlurOverlayTag) {
			[subView removeFromSuperview];
		}
	}
}

@end
