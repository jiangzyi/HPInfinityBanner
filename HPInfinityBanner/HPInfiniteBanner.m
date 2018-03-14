//
//  HPInfiniteView.m
//  HPInfinityBanner
//
//  Created by peng8744 on 2018/3/9.
//  Copyright © 2018年 peng8744. All rights reserved.
//

#import "HPInfiniteBanner.h"

static NSString *const reuseIdentifier = @"reuseIdentifier";

@interface HPInfiniteBanner()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL isInfinite;

@end

@implementation HPInfiniteBanner

- (instancetype)initWithFrame:(CGRect)frame imageCount:(NSInteger)imageCount isInfinite:(BOOL)isInfinite{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    if (imageCount < 1) {
        return nil;
    }
    self.showPageControl = YES;
    self.pageControlHeight = 50;
    self.scrollInterval = 2;
    self.autoScroll = YES;
    self.isInfinite = isInfinite;
    [self adjustImageCount:imageCount];
    [self setUpMainView];
    return self;
}

- (void)setUpMainView {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - _pageControlHeight, CGRectGetWidth(self.bounds), _pageControlHeight);
    self.flowLayout.itemSize = self.bounds.size;
    NSInteger startIndex = self.isInfinite ? 1 : 0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self startAutomicScroll];
}

#pragma mark - private methods

- (void)startAutomicScroll {
    if (self.isAutoScroll) {
        [self clearTimer];
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSInteger targetIndex = [self currentIndex] + 1;
                if (targetIndex > _totalCount - 1) {
                    targetIndex = self.isInfinite ? 1 : 0;
                }
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            }];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }else {
        [self clearTimer];
    }
}

- (void)adjustImageCount:(NSInteger)imageCount {
    if (imageCount <= 1) {
        _autoScroll = NO;
    }
    self.pageControl.numberOfPages = imageCount;
    if (self.isInfinite) {
        imageCount += 2;
    }
    self.totalCount = imageCount;
}

- (void)clearTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (NSInteger)currentIndex {
    NSInteger index = self.collectionView.contentOffset.x / self.flowLayout.itemSize.width;
    if (_isInfinite) {
        if (index == 0) {
            index = _totalCount - 1;
        }else if (index == _totalCount - 1) {
            index = 1;
        }
    }
    return index;
}

- (NSInteger)transformIndexFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    if (_isInfinite) {
        if (indexPath.item == 0) {
            index = _totalCount ;
        }else if (indexPath.item == _totalCount - 1) {
            index = 1;
        }
        index -= 1;
    }
    return index;
}

#pragma makr - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HPCollectionInfiniteViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger index = [self transformIndexFromIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(hpInfiniteBanner:setUpCell:index:)]) {
        [self.delegate hpInfiniteBanner:self setUpCell:cell index:index];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self transformIndexFromIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(hpInfiniteBanner:didSelectIndex:)]) {
        [self.delegate hpInfiniteBanner:self didSelectIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger count = _totalCount;
    NSInteger cellWidth = self.flowLayout.itemSize.width;
    if (_isInfinite) {
        NSInteger regularContentOffset = cellWidth * (count - 2);
        if (scrollView.contentOffset.x >= cellWidth * (count - 1)) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - regularContentOffset, 0);
        } else if (scrollView.contentOffset.x < cellWidth) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + regularContentOffset, 0);
        }
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = (offsetX + cellWidth/2) / cellWidth;
    if (_isInfinite) {
        if (page == 0) {
            page = _totalCount - 2;
        }else if (page == _totalCount - 1) {
            page = 1;
        }
        self.pageControl.currentPage = page - 1;
    }else {
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self clearTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutomicScroll];
}

#pragma mark - setter and getter

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor blueColor];
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[HPCollectionInfiniteViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight {
    _pageControlHeight = pageControlHeight;
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.size.height = pageControlHeight;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}


@end
