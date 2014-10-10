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
	
}

- (void)testRemoveValue
{

}

- (void)testWipe
{

}

- (void)testWipeExcluded
{

}

@end
