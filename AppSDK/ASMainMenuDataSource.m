//
//  ASMainMenuDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASMainMenuDataSource.h"
#import "NSArray+AL.h"

#import "ASScheduleViewController.h"
#import "ASBindingViewController.h"

@implementation ASMenuItem

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@: title:%@, class:%@",
			[super description], self.title, NSStringFromClass(self.viewControllerClass)];
}

@end

@implementation ASMainMenuDataSource

- (NSMutableArray *)topicList
{
	if (!_topicList) {
		_topicList = [NSMutableArray array];
	}
	
	return _topicList;
}

- (void)loadData
{
	[self beginBatchUpdate];
	[self addTopic:@"Scheduler" viewControllerClass:[ASScheduleViewController class]];
	[self addTopic:@"View Binding" viewControllerClass:[ASBindingViewController class]];
	[self endBatchUpdate];
}

- (void)addTopic:(NSString *)title viewControllerClass:(Class)viewControllerClass
{
	ASMenuItem *menuItem = [ASMenuItem new];
	menuItem.title = title;
	menuItem.viewControllerClass = viewControllerClass;
	
	[self.topicList addObject:menuItem];
}

- (ASMenuItem *)menuItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.topicList al_objectAtIndex:indexPath.row];
}

@end
