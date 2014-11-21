//
//  ULViewDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

#import <objc/runtime.h>

static void *kULViewDataSourceUpdatingContext = &kULViewDataSourceUpdatingContext;

@interface ULViewDataSource ()

@property (nonatomic, strong) NSMutableArray *ignoreUpdateProperties;
@property (nonatomic, assign) BOOL isBatchUpdate;

@end

@implementation ULViewDataSource

- (id)init
{
	if (self = [super init]) {
		[self ignoreUpdateProperty:@selector(delegate)];
		[self ignoreUpdateProperty:@selector(ignoreUpdateProperties)];
		[self ignoreUpdateProperty:@selector(isBatchUpdate)];
		[self ignoreUpdateProperty:@selector(shouldUpdateLayout)];
		
		_shouldUpdateLayout = NO;
		
		[self registerAllPropertiesForKVO];
	}
	
	return self;
}

- (void)dealloc
{
	[self deRegisterAllPropertiesForKVO];
}

#pragma mark - KVO

- (void)deRegisterAllPropertiesForKVO
{
	unsigned int count;
	
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    for (int i = 0; i < count; ++i) {
        const char *propertyName = property_getName(properties[i]);
        NSString *observedName = [NSString stringWithUTF8String:propertyName];
		
		@try {
			[self removeObserver:self
					  forKeyPath:observedName
						 context:kULViewDataSourceUpdatingContext];
		} @catch (NSException *exception) {
			//--do nothing since observer is not added
		}
    }
	
    free(properties);
}

- (void)registerAllPropertiesForKVO
{
	unsigned int count;
	
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    for (int i = 0; i < count; ++i) {
        const char *propertyName = property_getName(properties[i]);
        NSString *observedName = [NSString stringWithUTF8String:propertyName];
		
		[self addObserver:self
			   forKeyPath:observedName
				  options:NSKeyValueObservingOptionNew
				  context:kULViewDataSourceUpdatingContext];
    }
	
    free(properties);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	BOOL shouldUpdate = (context == kULViewDataSourceUpdatingContext);
	shouldUpdate = shouldUpdate && ![self.ignoreUpdateProperties containsObject:keyPath];
	shouldUpdate = shouldUpdate && !self.isBatchUpdate;
	
	if (shouldUpdate) {
		[self updateBindingKey:keyPath];
		
		[[self additionalKeyUpdates] enumerateKeysAndObjectsUsingBlock:^(NSString *bindingKey, NSString *propertyKey, BOOL *stop) {
			if ([propertyKey isEqualToString:keyPath]) {
				[self updateBindingKey:bindingKey];
			}
		}];
	}
}

#pragma mark - Batch Update

- (void)beginBatchUpdate
{
	self.isBatchUpdate = YES;
}

- (void)endBatchUpdate
{
	if (self.isBatchUpdate) {
		self.isBatchUpdate = NO;
		[self updateAllBindingKey];
	}
}

#pragma mark - Locking Update

- (NSMutableArray *)ignoreUpdateProperties
{
	if (!_ignoreUpdateProperties) {
		_ignoreUpdateProperties = [[NSMutableArray alloc] init];
	}
	
	return _ignoreUpdateProperties;
}

- (void)ignoreUpdateProperty:(SEL)propertySelector
{
	NSString *ignoreKeyPath = NSStringFromSelector(propertySelector);
	[self.ignoreUpdateProperties addObject:ignoreKeyPath];
}

#pragma mark - Additional Mapping

- (NSDictionary *)additionalKeyUpdates
{
	return nil;
}

- (void)updateAllBindingKey
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceUpdateAllBindingKey:)]) {
		[self.bindingDelegate viewDataSourceUpdateAllBindingKey:self];
	}
}

- (void)updateBindingKey:(NSString *)bindingKey
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSource:updateBindingKey:)]) {
		[self.bindingDelegate viewDataSource:self updateBindingKey:bindingKey];
	}
}

#pragma mark - Subclass Hook

- (void)loadData
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceShouldPreLoadData:)]) {
		[self.bindingDelegate viewDataSourceShouldPreLoadData:self];
	}
	
	/* Subclass inherit to provide implementation for this */
}

@end