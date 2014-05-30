//
//  UIImage+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIImage+UL.h"
#import "UIDevice+Compatibility.h"

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;}

@implementation UIImage (UL)

+ (UIImage *)ul_imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
	
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)ul_screenImageNamed:(NSString *)name
{
	if ([UIDevice al_isWideScreen]) {
		return [UIImage imageNamed:[NSString stringWithFormat:@"%@-568h.png",name]];
	} else {
		return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]];
	}
}

- (UIImage *)ul_tintedImageWithColor:(UIColor *)tintColor
{
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextSetFillColorWithColor(context, [tintColor CGColor]);
	CGContextFillRect(context, rect);
	UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImage *flippedImage = [UIImage imageWithCGImage:tintedImage.CGImage
												scale:[[UIScreen mainScreen] scale]
										  orientation:UIImageOrientationDownMirrored];
	return flippedImage;
}

- (UIImage *)ul_imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
	
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
	
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
