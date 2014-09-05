//
//  WaterflowView.m
//  068-Network-Waterflow
//
//  Created by Benny on 9/4/14.
//  Copyright (c) 2014 Benny. All rights reserved.
//

#import "WaterflowView.h"
#import "WaterflowCell.h"

@interface WaterflowView()

@property (strong, nonatomic) NSMutableArray *indexPaths;

@property (strong, nonatomic) NSMutableArray *positionCells;

@property (strong, nonatomic) NSMutableSet *reusableCells;

@property (strong, nonatomic) NSMutableDictionary *screenCells;

@end

@implementation WaterflowView

#pragma mark - ui
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.cells == 0) {
        [self reloadData];
    }
    
    for (NSIndexPath *indexPath in self.indexPaths) {
        
        WaterflowCell *cell = (WaterflowCell *)self.screenCells[indexPath];
        
        if (cell == nil) {
            
            cell = [self.dataSource waterflowView:self cellForRowAtIndexPath:indexPath];
            
            CGRect frame = [self.positionCells[indexPath.row]CGRectValue];
            
            if ([self isFrameInScreen:frame]) {
                
                [cell setFrame:frame];
                
                [self addSubview:cell];
                
                [self.screenCells setObject:cell forKey:indexPath];
            }

        } else {
            
            if (![self isFrameInScreen:cell.frame]) {
                
                [cell removeFromSuperview];
                
                [self.reusableCells addObject:cell];
                
                [self.screenCells removeObjectForKey:indexPath];
            }
        }
        
    }
    
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    WaterflowCell *cell = [self.reusableCells anyObject];
    
    
    if (cell) {
        [self.reusableCells removeObject:cell];
    }
    
    return cell;
}

- (BOOL)isFrameInScreen:(CGRect)frame
{
    return (frame.origin.y + frame.size.height) > self.contentOffset.y &&
            frame.origin.y < (self.contentOffset.y + self.bounds.size.height);
}

- (void)reloadData
{
    self.cells = [self numberOfCells];
    self.columns = [self numberOfColumns];
    
    if (self.cells == 0) {
        return;
    }
    
    [self resetLayout];
}

- (void)resetLayout
{
    if (self.indexPaths == nil) {
        self.indexPaths = [NSMutableArray arrayWithCapacity:self.cells];
    }else{
        [self.indexPaths removeAllObjects];
    }
    for (NSInteger i = 0; i < self.cells; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.indexPaths addObject:indexPath];
    }
    
    if (self.positionCells == nil) {
        self.positionCells = [NSMutableArray arrayWithCapacity:self.cells];
    }else{
        [self.positionCells removeAllObjects];
    }
    
    if (self.reusableCells == nil) {
        self.reusableCells = [NSMutableSet set];
    }else{
        [self.reusableCells removeAllObjects];
    }
    
    if (self.screenCells == nil) {
        self.screenCells = [NSMutableDictionary dictionary];
    }else{
        [self.screenCells removeAllObjects];
    }
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat columnHeight[self.columns];
    NSInteger column = 0;
    
    for (NSIndexPath *indexPath in self.indexPaths) {
        //        WaterflowCell *cell = [self.dataSource waterflowView:self cellForRowAtIndexPath:indexPath];
        
        CGFloat width = self.frame.size.width / self.columns;
        
        CGFloat height = [self.dataSource waterflowView:self heightForRowAtIndexPath:indexPath];
        CGFloat x = column * width;
        CGFloat y = columnHeight[column];
        columnHeight[column] += height;
        
        CGRect frame = CGRectMake(x, y, width, height);
        NSInteger firstColumnRightInset = (column == 0) ? 5 : 0;
        CGRect insetFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, firstColumnRightInset, 5, 5));
        
        [self.positionCells addObject:[NSValue valueWithCGRect:insetFrame]];
        
        NSInteger nextColumn = (column + 1) % self.columns;
        if (columnHeight[column] > columnHeight[nextColumn]) {
            column = nextColumn;
        }
    }
    
    CGFloat maxContentHeight = 0;
    for (NSInteger i = 0; i < self.columns; i++) {
        if (columnHeight[i] > maxContentHeight) {
            maxContentHeight = columnHeight[i];
        }
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, maxContentHeight)];
}

#pragma mark - delegate implementation
- (NSInteger)numberOfCells
{
    return [self.dataSource numberOfCellsInWaterflowView:self];
}

- (NSInteger)numberOfColumns
{
    return [self.dataSource numberOfColumnsInWaterflowView:self];
}

@end
