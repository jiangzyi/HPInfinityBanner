//
//  HPInfiniteView.h
//  HPInfinityBanner
//
//  Created by peng8744 on 2018/3/9.
//  Copyright © 2018年 peng8744. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPCollectionInfiniteViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class HPInfiniteBanner;
@protocol HPInfiniteBannerDelegate<NSObject>

- (void)hpInfiniteBanner:(HPInfiniteBanner *)infiniteBanner didSelectIndex:(NSInteger)index;
- (void)hpInfiniteBanner:(HPInfiniteBanner *)infiniteBanner setUpCell:(HPCollectionInfiniteViewCell *)cell index:(NSInteger)index;

@end

@interface HPInfiniteBanner : UIView

@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) CGFloat pageControlHeight;
@property (nonatomic, assign) NSTimeInterval scrollInterval;
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;
@property (nonatomic, weak) id<HPInfiniteBannerDelegate> delegate;

- (instancetype _Nullable )initWithFrame:(CGRect)frame imageCount:(NSInteger)imageCount isInfinite:(BOOL)isInfinite;

@end
NS_ASSUME_NONNULL_END
