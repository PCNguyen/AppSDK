//
//  UIView+LayoutPosition.h
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger kUIViewAquaDistance	= -2;
static NSInteger kUIViewUnpinInset		= -1;

@interface UIView (LayoutPosition)

#pragma mark - Configure

- (void)ul_enableAutoLayout;
- (void)ul_disableAutoLayout;

#pragma mark - Sizing

- (NSMutableArray *)ul_fixedSize:(CGSize)size;
- (NSMutableArray *)ul_matchSizeOfView:(UIView *)view ratio:(CGSize)sizeRatio;

#pragma mark - Alignment

- (NSMutableArray *)ul_horizontalAlign:(NSLayoutFormatOptions)alignmentOption
						   withView:(UIView *)siblingView
						   distance:(NSInteger)distance
						leftToRight:(BOOL)isLeftToRight;

- (NSMutableArray *)ul_verticalAlign:(NSLayoutFormatOptions)alignmentOption
						 withView:(UIView *)siblingView
						 distance:(NSInteger)distance
					  topToBottom:(BOOL)isTopToBottom;

- (NSMutableArray *)ul_centerAlignWithView:(UIView *)view;

- (NSLayoutConstraint *)ul_centerAlignWithView:(UIView *)view direction:(NSString *)direction;

#pragma mark - Containment

- (NSMutableArray *)ul_pinWithInset:(UIEdgeInsets)inset;

@end
