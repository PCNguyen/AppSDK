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
 *  a hook to signal ui that data source don't have initial data
 *	this will trigger ul_preLoadViewData on any UI implemented
 *
 *  @param dataSource the viewDataSource
 */
- (void)viewDataSourceShouldPreLoadData:(ULViewDataSource *)dataSource;

/**
 *  a hook to notify ui before data source update
 *	this will trigger ul_dataWillUpdate on any UI implemented
 *
 *  @param dataSource the data source
 */
- (void)viewDataSourceWillUpdateData:(ULViewDataSource *)dataSource;

/**
 *  a hook to execute update synchronously rather than notification based
 *	this will trigger ul_handleUpdatedProperty:userInfo: on any UI implemented
 *
 *  @param dataSource the datasource
 *  @param property   the updated property
 *  @param userInfo   the additional info about the changes
 */
- (void)viewDataSource:(ULViewDataSource *)dataSource updateProperty:(id)property userInfo:(NSDictionary *)userInfo;

/**
 *  a hook to signify data update complete in case of batch update
 *	this will trigger ul_dataDidUpdate on any UI implemented
 *
 *  @param dataSource the data source
 */
- (void)viewDataSourceDidUpdateData:(ULViewDataSource *)dataSource;

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

/**
 *  A hook entry for UI when data source don't have initial data
 *	Data Source call the viewDataSourceShouldPreLoadData: to trigger this
 */
- (void)ul_preLoadViewData;

/**
 *  a hook before data update source update
 *	Data Source call the viewDataSourceWillUpdateData: to trigger this
 */
- (void)ul_dataWillUpdate;

/**
 *  A hook to updated change from data source synchornously instead of notification based
 *	Data Source call the viewDataSource:updateProperty:userInfo: to trigger this
 *
 *  @param property the updated property
 *  @param userInfo the additional info about the changes
 */
- (void)ul_handleUpdatedProperty:(id)property userInfo:(NSDictionary *)userInfo;

/**
 *  A hook to handle batch updated data
 *	Data Source call the viewDataSourceDidUpdateData: to trigger this
 */
- (void)ul_dataDidUpdate;

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
