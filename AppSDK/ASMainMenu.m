//
//  ASMainMenu.m
//  AppSDK
//
//  Created by PC Nguyen on 10/27/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASMainMenu.h"
#import "UIViewController+DataBinding.h"

@implementation ASMainMenu

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self ul_loadData];
}

#pragma mark - ULViewDataBinding

- (Class)ul_binderClass
{
	return [ASMainMenuDataSource class];
}

- (ASMainMenuDataSource *)dataSource
{
	return (ASMainMenuDataSource *)[self ul_currentBinderSource];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"reloadMenuItems:":@"topicList"};
}

- (void)reloadMenuItems:(NSArray *)menuItem
{
	[self.tableView reloadData];
}

#pragma mark - TableView Delegate / DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self dataSource] topicList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"menuTableCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	}
	
	ASMenuItem *menuItem = [[self dataSource] menuItemAtIndexPath:indexPath];
	cell.textLabel.text = menuItem.title;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASMenuItem *menuItem = [[self dataSource] menuItemAtIndexPath:indexPath];
	
	Class viewControllerClass = menuItem.viewControllerClass;
	
	UIViewController *itemViewController = [[viewControllerClass alloc] init];
	
	[self.navigationController pushViewController:itemViewController animated:YES];
}

@end
