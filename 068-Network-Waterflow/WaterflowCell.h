//
//  WaterflowCell.h
//  068-Network-Waterflow
//
//  Created by Benny on 9/4/14.
//  Copyright (c) 2014 Benny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterflowCell : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) NSString *identifier;

@property (assign, nonatomic) BOOL isFirst;

- (id)initWithIdentifier:(NSString *)identifier;

@end
