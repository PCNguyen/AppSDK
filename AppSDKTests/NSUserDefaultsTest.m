//
//  NSUserDefaultsTest.m
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSUserDefaults+DL.h"

NSString *const UDNumberKey = @"UDNumberKey";
NSString *const UDStringKey = @"UDStringKey";
NSString *const UDArrayKey = @"UDArrayKey";
NSString *const UDDictionaryKey = @"UDDictionaryKey";

@interface NSUserDefaultsTest : XCTestCase

@property (nonatomic, strong) NSNumber *numberValue;
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSArray *arrayValue;
@property (nonatomic, strong) NSDictionary *dictionaryValue;

@end

@implementation NSUserDefaultsTest

- (void)setUp {
    [super setUp];
	
	self.numberValue = @(2);
	self.stringValue = @"String Value";
	self.arrayValue = @[@"item 1", @"item 2", @"item 3"];
	self.dictionaryValue = @{@"string Key":self.stringValue,
							 @"number Key":self.numberValue,
							 @"object key":self.arrayValue};
}

- (void)tearDown {
	self.numberValue = nil;
	self.stringValue = nil;
	self.arrayValue = nil;
	self.dictionaryValue = nil;
	
    [super tearDown];
}

- (void)testSaveValue
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--save something
	[NSUserDefaults dl_saveValue:self.numberValue forKey:UDNumberKey];
	[NSUserDefaults dl_saveValue:self.stringValue forKey:UDStringKey];
	[NSUserDefaults dl_saveValue:self.arrayValue forKey:UDArrayKey];
	[NSUserDefaults dl_saveValue:self.dictionaryValue forKey:UDDictionaryKey];
	
	//--test it
	XCTAssertNotNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNotNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNotNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNotNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--wipe it
	[NSUserDefaults dl_saveValue:nil forKey:UDNumberKey];
	[NSUserDefaults dl_saveValue:nil forKey:UDStringKey];
	[NSUserDefaults dl_saveValue:nil forKey:UDArrayKey];
	[NSUserDefaults dl_saveValue:nil forKey:UDDictionaryKey];
	
	//--test it
	XCTAssertNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
}

- (void)testLoadValue
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	[NSUserDefaults dl_saveValue:self.dictionaryValue forKey:UDDictionaryKey];
	NSDictionary *dictionary = [NSUserDefaults dl_loadValueForKey:UDDictionaryKey];
	XCTAssertEqualObjects(dictionary, self.dictionaryValue);
	
	//--clean up
	[NSUserDefaults dl_saveValue:nil forKey:UDDictionaryKey];
}

- (void)testRemoveValue
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	[NSUserDefaults dl_saveValue:self.dictionaryValue forKey:UDDictionaryKey];
	[NSUserDefaults dl_removeObjectForKey:UDDictionaryKey sync:YES];
	NSDictionary *dictionary = [NSUserDefaults dl_loadValueForKey:UDDictionaryKey];
	
	XCTAssertNil(dictionary);
}

- (void)testWipe
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger systemKeyCount = [[[userDefault dictionaryRepresentation] allKeys] count];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--save something
	[NSUserDefaults dl_saveValue:self.numberValue forKey:UDNumberKey];
	[NSUserDefaults dl_saveValue:self.stringValue forKey:UDStringKey];
	[NSUserDefaults dl_saveValue:self.arrayValue forKey:UDArrayKey];
	[NSUserDefaults dl_saveValue:self.dictionaryValue forKey:UDDictionaryKey];
	
	//--wipe
	[NSUserDefaults dl_wipe];
	
	//--test
	XCTAssertNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--make sure we didn't wipe system keys
	XCTAssertEqual([[[userDefault dictionaryRepresentation] allKeys] count], systemKeyCount);
}

- (void)testWipeExcluded
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger systemKeyCount = [[[userDefault dictionaryRepresentation] allKeys] count];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--save something
	[NSUserDefaults dl_saveValue:self.numberValue forKey:UDNumberKey];
	[NSUserDefaults dl_saveValue:self.stringValue forKey:UDStringKey];
	[NSUserDefaults dl_saveValue:self.arrayValue forKey:UDArrayKey];
	[NSUserDefaults dl_saveValue:self.dictionaryValue forKey:UDDictionaryKey];
	
	//--wipe everthing except String and Numbers
	[NSUserDefaults dl_wipeExceptKeys:@[UDStringKey, UDNumberKey]];
	
	//--test
	XCTAssertNotNil([userDefault objectForKey:UDNumberKey]);
	XCTAssertNotNil([userDefault objectForKey:UDStringKey]);
	XCTAssertNil([userDefault objectForKey:UDArrayKey]);
	XCTAssertNil([userDefault objectForKey:UDDictionaryKey]);
	
	//--clean up
	[NSUserDefaults dl_wipe];
	
	//--make sure we didn't wipe system keys
	XCTAssertEqual([[[userDefault dictionaryRepresentation] allKeys] count], systemKeyCount);
}

@end
