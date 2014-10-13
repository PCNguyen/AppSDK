//
//  InMemoryAppStorageTest.m
//  AppSDK
//
//  Created by PC Nguyen on 10/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DLInMemoryAppStorage.h"

NSString *const IMASNumberKey = @"IMASNumberKey";
NSString *const IMASStringKey = @"IMASStringKey";
NSString *const IMASArrayKey = @"IMASArrayKey";
NSString *const IMASDictionaryKey = @"IMASDictionaryKey";

@interface InMemoryAppStorageTest : XCTestCase

@property (nonatomic, strong) DLInMemoryAppStorage *appStorage;

@property (nonatomic, strong) NSNumber *numberValue;
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSArray *arrayValue;
@property (nonatomic, strong) NSDictionary *dictionaryValue;

@end

@implementation InMemoryAppStorageTest

- (void)setUp {
	[super setUp];
	self.appStorage = [DLInMemoryAppStorage sharedInstance];
	
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
	
	self.appStorage = nil;
	[super tearDown];
}

- (void)testSaveValue
{
	//--make sure we start with a clean slate
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:IMASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:IMASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:IMASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:IMASDictionaryKey];
	
	//--test it
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	//--wipe it
	[self.appStorage saveValue:nil forKey:IMASNumberKey];
	[self.appStorage saveValue:nil forKey:IMASStringKey];
	[self.appStorage saveValue:nil forKey:IMASArrayKey];
	[self.appStorage saveValue:nil forKey:IMASDictionaryKey];
	
	//--test it
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
}

- (void)testLoadValue
{
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	[self.appStorage saveValue:self.dictionaryValue forKey:IMASDictionaryKey];
	NSDictionary *dictionary = [self.appStorage loadValueForKey:IMASDictionaryKey];
	XCTAssertEqualObjects(dictionary, self.dictionaryValue);
	
	//--clean up
	[self.appStorage saveValue:nil forKey:IMASDictionaryKey];
}

- (void)testWipe
{
	//--make sure we start with a clean slate
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:IMASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:IMASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:IMASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:IMASDictionaryKey];
	
	//--wipe
	[self.appStorage wipe];
	
	//--test it
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
}

- (void)testWipeExcluded
{
	//--make sure we start with a clean slate
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:IMASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:IMASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:IMASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:IMASDictionaryKey];
	
	//--wipe everthing except String and Numbers
	[self.appStorage wipeExceptKeys:@[IMASStringKey, IMASNumberKey]];
	
	//--test
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASNumberKey]);
	XCTAssertNotNil([[self.appStorage dataStore] valueForKey:IMASStringKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASArrayKey]);
	XCTAssertNil([[self.appStorage dataStore] valueForKey:IMASDictionaryKey]);
	
	//--clean up
	[self.appStorage wipe];
}

@end
