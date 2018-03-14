//
//  HPCollectionInfiniteViewCell.m
//  HPInfinityBanner
//
//  Created by peng8744 on 2018/3/9.
//  Copyright © 2018年 peng8744. All rights reserved.
//

#import "HPCollectionInfiniteViewCell.h"

@implementation HPCollectionInfiniteViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.contentView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.indexLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.indexLabel.frame = CGRectMake(0, 0, 200, 50);
}

#pragma mark - setter and getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.backgroundColor = [UIColor redColor];
        _indexLabel.font = [UIFont systemFontOfSize:14];
    }
    return _indexLabel;
}

@end
