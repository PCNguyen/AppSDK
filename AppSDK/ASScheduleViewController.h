//
//  ASScheduleViewController.h
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASScheduleDataSource.h"

@class ASTimerCell;

@protocol ASTimerCellDelegate <NSObject>

@optional
- (void)timerCell:(ASTimerCell *)timerCell updateInterval:(CGFloat)interval;

@end

@interface ASTimerCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) UITextField *intervalTextField;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, weak) id<ASTimerCellDelegate>delegate;

@end

@interface ASScheduleViewController : UIViewController <ULViewDataBinding>

@end
