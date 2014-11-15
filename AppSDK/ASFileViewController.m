//
//  ASFileViewController.m
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASFileViewController.h"
#import "ASImageViewController.h"
#import "UIViewController+DataBinding.h"

NSString *const FVCCellIdentifier = @"FVCCellIdentifier";

@interface ASFileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ASFileViewController

- (void)loadView
{
	[super loadView];
	
	self.navigationItem.rightBarButtonItem = [self addImageItem];
}

#pragma mark - ULViewDataBinding Protocol

- (Class)ul_binderClass
{
	return [ASFileDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"handleFileList:" : @"fileList"};
}

- (void)handleFileList:(NSArray *)fileList
{
	[self.tableView reloadData];
}

- (ASFileDataSource *)dataSource
{
	return (ASFileDataSource *)[self ul_currentBinderSource];
}

#pragma mark UITableView Delegate / DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self dataSource].fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FVCCellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FVCCellIdentifier];
	}
	
	NSString *fileName = [[self dataSource].fileList objectAtIndex:indexPath.row];
	cell.textLabel.text = fileName;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *fileName = [[self dataSource].fileList objectAtIndex:indexPath.row];
	UIImage *image = [[self dataSource] imageForName:fileName];
	
	ASImageViewController *imageViewController = [[ASImageViewController alloc] initWithImage:image];
	[self.navigationController pushViewController:imageViewController animated:YES];
}

#pragma mark - Navigation Item

- (UIBarButtonItem *)addImageItem
{
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddImageItemTapped:)];
	
	return barButtonItem;
}

- (void)handleAddImageItemTapped:(id)sender
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
	NSArray *imageMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"image"]];
	imagePicker.mediaTypes = imageMediaTypesOnly;
	[self presentViewController:imagePicker animated:YES completion:NULL];
}

#pragma mark - Image Handling

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	
	if (image) {
		[[self dataSource] saveImage:image];
	}
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
