//
//  ViewController.m
//  068-Network-Waterflow
//
//  Created by Benny on 9/4/14.
//  Copyright (c) 2014 Benny. All rights reserved.
//

#import "ViewController.h"
#import "WaterflowView.h"
#import "WaterflowCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ViewController ()

@property (weak, nonatomic) WaterflowView *waterflowView;

@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (assign, nonatomic) NSInteger column;

@end

@implementation ViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WaterflowView *waterflowView = [[WaterflowView alloc]initWithFrame:CGRectZero];
    [waterflowView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [waterflowView setDelegate:self];
    [waterflowView setDataSource:self];
    [waterflowView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    
    self.waterflowView = waterflowView;
    [self.view addSubview:waterflowView];
    
    self.queue = [[NSOperationQueue alloc]init];
    [self.queue setMaxConcurrentOperationCount:5];
    
    [self initDataList];
}

- (void)initDataList
{
    NSURL *url = [NSURL URLWithString:@"http://testapi.demo.wiicode.net/itunes.php?term=avril+lavigne&limit=100"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *dict = (NSDictionary *)json;
            self.dataList = dict[@"results"];
            [self.waterflowView reloadData];
        }];
    }];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.waterflowView reloadData];
}


- (NSInteger)numberOfCellsInWaterflowView:(WaterflowView *)waterflowView
{
    return self.dataList.count;
}

- (NSInteger)numberOfColumnsInWaterflowView:(WaterflowView *)WaterflowView
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    if (orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight) {
        return 4;
    }else{
        return 3;
    }
}

- (WaterflowCell *)waterflowView:(WaterflowView *)waterflowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"waterflowCellId";
    WaterflowCell *cell = [waterflowView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[WaterflowCell alloc]initWithIdentifier:cellId];
    }
    
    NSDictionary *dict = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:dict[@"artworkUrl100"]];
    [cell.title setText:dict[@"trackName"]];
    
    return cell;
}

- (CGFloat)waterflowView:(WaterflowView *)waterflowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataList[indexPath.row];
    
    CGFloat width = self.view.bounds.size.width / self.waterflowView.columns;
    
    if ([dict[@"kind"] isEqualToString:@"song"]) {
        return width;
    }else if([dict[@"kind"] isEqualToString:@"music-video"]){
        return (width / 16) * 9;
    } else{
        return (arc4random_uniform(5) * 10) + 150;
    }
}

@end
