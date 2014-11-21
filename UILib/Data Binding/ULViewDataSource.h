//
//  ULViewDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULViewDataSource;

@protocol ULViewDataSourceBindingDelegate <NSObject>

@optional
/***
 * called when selectiveUpdate enable
 */
- (void)viewDataSource:(ULViewDataSource *)dataSource updateBindingKey:(NSString *)bindKey;

/***
 * called when selectiveUpdate NOT enable or batch updating complete
 */
- (void)viewDataSourceUpdateAllBindingKey:(ULViewDataSource *)dataSource;

/**
 *  called when dataSource don't have initial data
 *
 *  @param dataSource the viewDataSource
 */
- (void)viewDataSourceShouldPreLoadData:(ULViewDataSource *)dataSource;

@end

@protocol ULViewDataBinding <NSObject>

/***
 * Returned value must be subclass of USViewDataSource.
 * Providing the dataSource for binding values.
 */
- (Class)ul_binderClass;

/***
 * A dictionary of binding values in format
 * {viewProperty : sourceProperty}
 */
- (NSDictionary *)ul_bindingInfo;

@optional

- (void)ul_preLoadViewData;

@end

@interface ULViewDataSource : NSObject

/***
 * naming different so subClass has no issue implement their own delegate
 * this delegate should be reserved for binding process only
 */
@property (nonatomic, weak) id<ULViewDataSourceBindingDelegate>bindingDelegate;

/***
 * Default is NO.
 * If set to YES, when data update, view will also redraw.
 * If value is YES, selective update will be disabled (for now)
 * Useful if view frame is calculated dynamically based on data it contents.
 */
@property (nonatomic, assign) BOOL shouldUpdateLayout;

/***
 * If we don't want UI change until all the updates finished.
 * Wrap this before and after properties update.
 * UI update happen when endBatchUpdate get called.
 */
- (void)beginBatchUpdate;
- (void)endBatchUpdate;

/***
 * In init method, this should be called for any non-binding properties.
 */
- (void)ignoreUpdateProperty:(SEL)propertySelector;

/***
 * A dictionary provide mapping for selective update
 * Providing this will enable selective update for mapped selectors when that property change.
 * e.g
 * {
 *	 countText			: count,
 *   countFormattedText	: count,
 *   negativeCount		: count,
 *   formattedDate      : timeStamp,
 *   formattedHour		: timeStamp
 * }
 *
 * Providing empty dictionary will enable selective update for all properties without mapping
 */
- (NSDictionary *)selectiveUpdateMap;

#pragma mark - Subclass Hook

/**
 *  Subclass provide mechanism to parse data from storage into binding variables
 */
- (void)loadData;

@end
