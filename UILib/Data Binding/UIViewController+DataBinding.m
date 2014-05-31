//
//  UIViewController+DataBinding.m
//  UISDK
//
//  Created by PC Nguyen on 5/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIViewController+DataBinding.h"

#import "ALPropertiesTransformer.h"
#import "ALSetterTransformer.h"

#import "NSObject+AL.h"

@implementation UIViewController (DataBinding)

+ (void)load
{
	static dispatch_once_t token;
	[self al_swizzleSelector:@selector(viewWillLayoutSubviews)
				  bySelector:@selector(__swizzlingViewWillLayoutSubViews)
			   dispatchToken:token];
}

#pragma mark - SWIZZLING - DANGEROUS STUFF

- (void)__swizzlingViewWillLayoutSubViews
{
	if ([[self __binderSource] shouldReloadWithLayoutUpdate]) {
		[self __handleBindinUpdate];
	}
	
	[self __swizzlingViewWillLayoutSubViews];
}

#pragma mark - Auto Binding

- (void)__handleBindingUpdateValue:(id)key withBindedValue:(id)bindingKey
{
	//--getter
	NSArray *getterProperties = [[ALPropertiesTransformer transformer] transformedValue:bindingKey];
	id getterOwner = [self __binderSource];
	
	for (NSString *childProperties in getterProperties) {
		getterOwner = [self __objectFromString:childProperties owner:getterOwner];
	}
	
	NSString *getterSelectorString = [[ALSetterTransformer transformer] reverseTransformedValue:bindingKey];
	id getterValue = [self __objectFromString:getterSelectorString owner:getterOwner];
	
	//--setter
	NSArray *setterProperties = [[ALPropertiesTransformer transformer] transformedValue:key];
	id setterOwner = self;
	
	for (NSString *childProperties in setterProperties) {
		setterOwner = [self __objectFromString:childProperties owner:setterOwner];
	}
	
	NSString *setterSelectorString = [[ALSetterTransformer transformer] transformedValue:key];
	SEL setterSelector = NSSelectorFromString(setterSelectorString);
	
	//--bind value
	[setterOwner al_performSelector:setterSelector withObject:getterValue];
}

- (void)__handleBindinUpdate
{
	NSDictionary *binding = [self ul_bindingInfo];
	
	[binding enumerateKeysAndObjectsUsingBlock:^(id uiValue, id sourceValue, BOOL *stop) {
		[self __handleBindingUpdateValue:uiValue withBindedValue:sourceValue];
	}];
}

- (ULViewDataSource *)__binderSource
{
	ULViewDataSource *dataBinder = [self al_associateObjectForSelector:@selector(__binderSourceAssociate)];
	
	if (!dataBinder) {
		dataBinder = [self al_setAssociateObjectWithSelector:@selector(__binderSourceAssociate)];
	}
	
	return dataBinder;
}

- (ULViewDataSource *)__binderSourceAssociate
{
	ULViewDataSource *dataBinder = nil;
	Class binderClass = [self ul_binderClass];
	
	if ([binderClass isSubclassOfClass:[ULViewDataSource class]]) {
		dataBinder = [[binderClass alloc] init];
		dataBinder.bindingDelegate = self;
	}
	
	return dataBinder;
}

#pragma mark - ULViewDataBinding Protocol Mock

- (Class)ul_binderClass
{
	return [ULViewDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return [NSDictionary dictionary];
}

#pragma mark - Public Method

- (ULViewDataSource *)ul_currentBinderSource
{
	ULViewDataSource *dataBinder = nil;
	
	if ([self __isBindingMode]) {
		dataBinder = [self al_associateObjectForSelector:@selector(__binderSourceAssociate)];
	}
	
	return dataBinder;
}

#pragma mark - RPViewDataSourceDelegate

- (void)viewDataSource:(ULViewDataSource *)dataSource updateBindingKey:(NSString *)bindKey
{
	if (dataSource.shouldUpdateLayout) {
		[self viewWillLayoutSubviews];
	} else {
		if ([self __isBindingMode]) {
			[[self ul_bindingInfo] enumerateKeysAndObjectsUsingBlock:^(id uiValue, id sourceValue, BOOL *stop){
				if ([sourceValue isEqualToString:bindKey]) {
					[self __handleBindingUpdateValue:uiValue withBindedValue:sourceValue];
				}
			}];
		}
	}
}

- (void)viewDataSourceUpdateAllBindingKey:(ULViewDataSource *)dataSource
{
	if (dataSource.shouldUpdateLayout) {
		[self viewWillLayoutSubviews];
	} else {
		if ([self __isBindingMode]) {
			[self __handleBindinUpdate];
		}
	}
}

#pragma mark - Private

- (BOOL)__isBindingMode
{
	BOOL isBinding =  [[self class] conformsToProtocol:@protocol(ULViewDataBinding)];
	return isBinding;
}

- (id)__objectFromString:(NSString *)selectorString owner:(id)owner;
{
	id returnedObject = [owner al_objectFromSelector:NSSelectorFromString(selectorString)];
	
	return returnedObject;
}

@end
