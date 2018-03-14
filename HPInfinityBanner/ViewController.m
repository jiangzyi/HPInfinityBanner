//
//  ViewController.m
//  HPInfinityBanner
//
//  Created by peng8744 on 2018/3/9.
//  Copyright © 2018年 peng8744. All rights reserved.
//

#import "ViewController.h"
#import "HPInfiniteBanner.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HPInfiniteBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HPInfiniteBanner *infiniteBanner = [[HPInfiniteBanner alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) imageCount:3 isInfinite:YES];
    infiniteBanner.delegate = self;
    infiniteBanner.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [self.view addSubview:infiniteBanner];
}

#pragma mark - HPInfiniteViewDelegate

- (void)hpInfiniteBanner:(HPInfiniteBanner *)infiniteView didSelectIndex:(NSInteger)index {
    NSLog(@"click:%ld",index);
}

- (void)hpInfiniteBanner:(HPInfiniteBanner *)infiniteView setUpCell:(HPCollectionInfiniteViewCell *)cell index:(NSInteger)index {
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",index];
}


@end
