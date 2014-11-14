//
//  UIImage+FileStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIImage+FileStorage.h"

@implementation UIImage (FileStorage)

- (NSData *)dataPresentation
{
	return UIImagePNGRepresentation(self);
}

@end
