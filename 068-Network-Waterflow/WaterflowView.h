//
//  WaterflowView.h
//  068-Network-Waterflow
//
//  Created by Benny on 9/4/14.
//  Copyright (c) 2014 Benny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterflowView;
@class WaterflowCell;

@protocol WaterflowViewDelegate <NSObject,UIScrollViewDelegate,UITableViewDelegate>

@optional

- (UIView *)waterflowView:(WaterflowView *)waterflowView viewForHeader:(UIView *)view;

- (UIView *)waterflowView:(WaterflowView *)waterflowView viewForFooter:(UIView *)view;

- (void)waterflowView:(WaterflowView *)waterflowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)waterflowView:(WaterflowView *)waterflowView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)waterflowView:(WaterflowView *)waterflowView didRefreshingHeader:(UIView *)view;

- (void)waterflowView:(WaterflowView *)waterflowView didRefreshingFooter:(UIView *)view;

@optional

@end

@protocol WaterflowViewDataSource <NSObject>

- (WaterflowCell *)waterflowView:(WaterflowView *)waterflowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)waterflowView:(WaterflowView *)waterflowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfColumnsInWaterflowView:(WaterflowView *)WaterflowView;

- (NSInteger)numberOfCellsInWaterflowView:(WaterflowView *)waterflowView;

@end

@interface WaterflowView : UIScrollView

@property (assign, nonatomic) NSInteger cells;

@property (assign, nonatomic) NSInteger columns;

@property (weak, nonatomic) id<WaterflowViewDelegate> delegate;

@property (weak, nonatomic) id<WaterflowViewDataSource> dataSource;

- (void)reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
