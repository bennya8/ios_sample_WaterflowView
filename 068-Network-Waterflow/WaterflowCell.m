//
//  WaterflowCell.m
//  068-Network-Waterflow
//
//  Created by Benny on 9/4/14.
//  Copyright (c) 2014 Benny. All rights reserved.
//

#import "WaterflowCell.h"

@implementation WaterflowCell

@synthesize title = _title;

#pragma mark - constructor
- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - ui
- (void)layoutSubviews
{
    [super layoutSubviews];
  
//    [self setFrame:CGRectOffset(self.frame, 5, 0)];
//    [self setFrame:CGRectInset(self.frame, 5, 5)];
    
//    NSInteger firstColumnRightInset = self.isFirst ? 5 : 0;

//    NSInteger columnLeftHack = self.isFirst ? 0 : 5;
    
//    [self setFrame:UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(0, firstColumnRightInset, 5, 5))];

    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.title setFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
    
//    NSLog(@"%@",self.title.text);
}

#pragma mark - getter (lazyload)
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setBackgroundColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

- (UILabel *)title
{
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        [_title setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [_title setNumberOfLines:0];
        [_title setFont:[UIFont systemFontOfSize:12.0f]];
        [_title setTextColor:[UIColor whiteColor]];
        
        [self insertSubview:_title atIndex:1];
    }
    return  _title;
}


@end
