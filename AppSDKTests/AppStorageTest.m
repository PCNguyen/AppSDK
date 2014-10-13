//
//  AppStorageTest.m
//  AppSDK
//
//  Created by PC Nguyen on 10/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DLAppStorage.h"

NSString *const ASNumberKey = @"ASNumberKey";
NSString *const ASStringKey = @"ASStringKey";
NSString *const ASArrayKey = @"ASArrayKey";
NSString *const ASDictionaryKey = @"ASDictionaryKey";

@interface AppStorageTest : XCTestCase

@property (nonatomic, strong) DLAppStorage *appStorage;
@property (nonatomic, strong) NSCache *sharedCache;

@property (nonatomic, strong) NSNumber *numberValue;
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSArray *arrayValue;
@property (nonatomic, strong) NSDictionary *dictionaryValue;

@end

@implementation AppStorageTest

- (void)setUp {
    [super setUp];
	self.appStorage = [[DLAppStorage alloc] initWithCache:self.sharedCache];
	
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

#pragma mark - Caching

- (NSCache *)sharedCache
{
	if (!_sharedCache) {
		_sharedCache = [[NSCache alloc] init];
		_sharedCache.totalCostLimit = 0;
		_sharedCache.countLimit = 0;
	}
	
	return _sharedCache;
}

- (void)testSaveValue
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:ASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:ASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:ASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:ASDictionaryKey];
	
	//--test it
	XCTAssertNotNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNotNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNotNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNotNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--wipe it
	[self.appStorage saveValue:nil forKey:ASNumberKey];
	[self.appStorage saveValue:nil forKey:ASStringKey];
	[self.appStorage saveValue:nil forKey:ASArrayKey];
	[self.appStorage saveValue:nil forKey:ASDictionaryKey];
	
	//--test it
	XCTAssertNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
}

- (void)testLoadValue
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	[self.appStorage saveValue:self.dictionaryValue forKey:ASDictionaryKey];
	NSDictionary *dictionary = [self.appStorage loadValueForKey:ASDictionaryKey];
	XCTAssertEqualObjects(dictionary, self.dictionaryValue);
	
	//--clean up
	[self.appStorage saveValue:nil forKey:ASDictionaryKey];
}

- (void)testWipe
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger systemKeyCount = [[[userDefault dictionaryRepresentation] allKeys] count];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:ASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:ASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:ASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:ASDictionaryKey];
	
	//--wipe
	[self.appStorage wipe];
	
	//--test it
	XCTAssertNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--make sure we didn't wipe system keys
	XCTAssertEqual([[[userDefault dictionaryRepresentation] allKeys] count], systemKeyCount);
}

- (void)testWipeExcluded
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger systemKeyCount = [[[userDefault dictionaryRepresentation] allKeys] count];
	
	//--make sure we start with a clean slate
	XCTAssertNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--save something
	[self.appStorage saveValue:self.numberValue forKey:ASNumberKey];
	[self.appStorage saveValue:self.stringValue forKey:ASStringKey];
	[self.appStorage saveValue:self.arrayValue forKey:ASArrayKey];
	[self.appStorage saveValue:self.dictionaryValue forKey:ASDictionaryKey];
	
	//--wipe everthing except String and Numbers
	[self.appStorage wipeExceptKeys:@[ASStringKey, ASNumberKey]];
	
	//--test
	XCTAssertNotNil([userDefault objectForKey:ASNumberKey]);
	XCTAssertNotNil([userDefault objectForKey:ASStringKey]);
	XCTAssertNil([userDefault objectForKey:ASArrayKey]);
	XCTAssertNil([userDefault objectForKey:ASDictionaryKey]);
	
	//--clean up
	[self.appStorage wipe];
	
	//--make sure we didn't wipe system keys
	XCTAssertEqual([[[userDefault dictionaryRepresentation] allKeys] count], systemKeyCount);
}

- (void)testCache
{
	[self.appStorage saveValue:self.stringValue forKey:ASStringKey];
	self.appStorage = nil;
	
	XCTAssertNotNil([self.sharedCache objectForKey:ASStringKey]);
	
	self.appStorage = [[DLAppStorage alloc] initWithCache:self.sharedCache];
	[self.appStorage wipe];
	
	XCTAssertNil([self.sharedCache objectForKey:ASStringKey]);
}

@end
