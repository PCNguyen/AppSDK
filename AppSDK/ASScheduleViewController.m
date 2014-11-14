//
//  ASScheduleViewController.m
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASScheduleViewController.h"
#import "ALScheduleManager.h"
#import "UIViewController+DataBinding.h"
#import "UIView+LayoutPosition.h"

/****************
 *  ASTimerCell
 ****************/
@implementation ASTimerCell

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self.contentView addSubview:self.updateButton];
		[self.contentView addSubview:self.intervalTextField];
		[self.contentView addSubview:self.counterLabel];
		
		[self layoutViews]; //--quick autolayout since we have only a couple of cell
	}
	
	return self;
}

- (void)layoutViews
{
	[self.contentView addConstraints:[self.updateButton ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
	[self.contentView addConstraints:[self.intervalTextField ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.updateButton distance:2.0f topToBottom:YES]];
	[self.contentView addConstraints:[self.intervalTextField ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, kUIViewUnpinInset, 0.0f)]];
	[self.contentView addConstraints:[self.counterLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.intervalTextField distance:0.0f topToBottom:YES]];
	[self.contentView addConstraints:[self.counterLabel ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
}

- (UILabel *)counterLabel
{
	if (!_counterLabel) {
		_counterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_counterLabel.font = [UIFont systemFontOfSize:16.0f];
		_counterLabel.textAlignment = NSTextAlignmentCenter;
		_counterLabel.backgroundColor = [UIColor clearColor];
		[_counterLabel ul_enableAutoLayout];
	}
	
	return _counterLabel;
}

- (UITextField *)intervalTextField
{
	if (!_intervalTextField) {
		_intervalTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		_intervalTextField.textAlignment = NSTextAlignmentCenter;
		_intervalTextField.borderStyle = UITextBorderStyleLine;
		[_intervalTextField ul_enableAutoLayout];
	}
	
	return _intervalTextField;
}

- (UIButton *)updateButton
{
	if (!_updateButton) {
		_updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[_updateButton setTitle:@"Update" forState:UIControlStateNormal];
		[_updateButton ul_enableAutoLayout];
		[_updateButton addTarget:self action:@selector(handleUpdateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _updateButton;
}

- (void)handleUpdateButtonTapped:(id)sender
{
	NSString *intervalText = self.intervalTextField.text;
	if ([self stringIsNumeric:intervalText] && [intervalText floatValue] > 0) {
		if ([self.delegate respondsToSelector:@selector(timerCell:updateInterval:)]) {
			[self.delegate timerCell:self updateInterval:[self.intervalTextField.text floatValue]];
		}
	}
}

#pragma mark Private

- (BOOL)stringIsNumeric:(NSString *)text {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	NSNumber *number = [formatter numberFromString:text];
	return (number != nil); // If the string is not numeric, number will be nil
}

@end

/****************************
 *  ASScheduleViewController
 ****************************/

NSString *const SVCCellIdentifier = @"SVCCellIdentifier";

@interface ASScheduleViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ASTimerCellDelegate>

@property (nonatomic, strong) UILabel *mainCounter;
@property (nonatomic, strong) UICollectionView *counterView;

@end

@implementation ASScheduleViewController

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.mainCounter];
	[self.view addSubview:self.counterView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

#pragma mark - ULViewDataBinding

- (Class)ul_binderClass
{
	return [ASScheduleDataSource class];
}

- (ASScheduleDataSource *)dataSource
{
	return (ASScheduleDataSource *)[self ul_currentBinderSource];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"mainCounter.text":@"masterCountText",
			 @"updateCounterList:":@"counterList"};
}

- (void)updateCounterList:(NSArray *)counterList
{
	[self.counterView reloadData];
}

#pragma mark - CollectionView

- (UICollectionView *)counterView
{
	if (!_counterView) {
		_counterView = [[UICollectionView alloc] initWithFrame:CGRectZero];
		_counterView.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
		[_counterView registerClass:[ASTimerCell class] forCellWithReuseIdentifier:SVCCellIdentifier];
		_counterView.delegate = self;
		_counterView.dataSource = self;
	}
	
	return _counterView;
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[[self dataSource] counterList] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ASTimerCell *timerCell = [collectionView dequeueReusableCellWithReuseIdentifier:SVCCellIdentifier forIndexPath:indexPath];
	
	ASCounterTask *counterTask = [[self dataSource] counterTaskAtIndexPath:indexPath];
	timerCell.counterLabel.text = [NSString stringWithFormat:@"%ld", counterTask.currentCount];
	timerCell.intervalTextField.text = [NSString stringWithFormat:@"%f", counterTask.timeInterval];
	timerCell.delegate = self;
	
	return timerCell;
}

#pragma mark - ASTimerCellDelegate

- (void)timerCell:(ASTimerCell *)timerCell updateInterval:(CGFloat)interval
{
	//--TODO: change the dataSource sync interval
}

@end
