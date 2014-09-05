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

@property (weak, nonatomic) UIView *headerView;

@property (weak, nonatomic) UIView *footerView;

@end

@implementation WaterflowView

#pragma mark - ui
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.headerView == nil) {
        
        UIView *headerView = [[UIView alloc]init];
        
        [headerView setFrame:CGRectMake(0, -60, self.frame.size.width, 60)];
        
        [headerView setBackgroundColor:[UIColor orangeColor]];
        
        self.headerView = headerView;
        
        [self addSubview:headerView];
        
        if ([self.delegate respondsToSelector:@selector(waterflowView:viewForHeader:)]) {
            
            [self.delegate waterflowView:self viewForHeader:self.headerView];
            
        }
        
    }
    
    if (self.footerView == nil) {
        
        UIView *footerView = [[UIView alloc]init];
        
        [footerView setFrame:CGRectZero];
        
        self.footerView = footerView;
        
        [self.footerView setHidden:YES];
        
        [self addSubview:footerView];
        
        if ([self.delegate respondsToSelector:@selector(waterflowView:viewForFooter:)]) {
            
            [self.delegate waterflowView:self viewForFooter:self.footerView];
            
        }
        
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
    
    [self didRefreshingHeader];
    
    [self didRefreshingFooter];
    
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
        if ([view isKindOfClass:[WaterflowCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat columnHeight[self.columns];
    NSInteger column = 0;
    
    for (NSIndexPath *indexPath in self.indexPaths) {
        
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
    
    [self.headerView setFrame:CGRectMake(0, -60, self.frame.size.width, 60)];
    
    [self.footerView setFrame:CGRectMake(0, maxContentHeight, self.frame.size.width, 60)];
        
    [self.footerView setHidden:NO];

}

#pragma mark - @required delegate implementation
- (NSInteger)numberOfCells
{
    return [self.dataSource numberOfCellsInWaterflowView:self];
}

- (NSInteger)numberOfColumns
{
    return [self.dataSource numberOfColumnsInWaterflowView:self];
}

#pragma mark - @optional delegate implementation
- (void)didRefreshingHeader
{
    if ([self.delegate respondsToSelector:@selector(didRefreshingHeader)]) {
        [self.delegate waterflowView:self didRefreshingHeader:self.headerView];
    }
}

- (void)didRefreshingFooter
{
    if ([self.delegate respondsToSelector:@selector(didRefreshingFooter)]) {
        [self.delegate waterflowView:self didRefreshingFooter:self.footerView];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    
    NSArray *indexPaths = [self.screenCells allKeys];
    
    if ([self.delegate respondsToSelector:@selector(waterflowView:didSelectRowAtIndexPath:)]) {
        
        for (NSIndexPath *indexPath in indexPaths) {
            
            WaterflowCell *cell = self.screenCells[indexPath];
            
            if(CGRectContainsPoint(cell.frame, location)){
                
                
                [self.delegate waterflowView:self didSelectRowAtIndexPath:indexPath];
                
                break;
                
            }
            
            
        }
        
    }
    
}


@end
