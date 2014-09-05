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

@protocol WaterflowViewDelegate <NSObject,UIScrollViewDelegate>



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
