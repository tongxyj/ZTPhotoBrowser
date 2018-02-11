//
//  ZTPhotoCategoryCell.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/2/9.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ZTPhotoCategoryCell.h"

@implementation ZTPhotoCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZTPhotoCategoryViewController *photoVc = [[ZTPhotoCategoryViewController alloc] init];
    self.photoCategoryVC = photoVc;
    [self addSubview:photoVc.view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoCategoryVC.view.frame = self.bounds;
}
@end
