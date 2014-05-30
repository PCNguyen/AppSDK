//
//  UIImage+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UL)

+ (UIImage *)ul_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)ul_screenImageNamed:(NSString *)name;

- (UIImage *)ul_tintedImageWithColor:(UIColor *)tintColor;
- (UIImage *)ul_imageRotatedByDegrees:(CGFloat)degree;

@end
