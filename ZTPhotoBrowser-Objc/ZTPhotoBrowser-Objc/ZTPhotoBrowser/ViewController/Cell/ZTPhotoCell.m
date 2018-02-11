//
//  ZTPhotoCell.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/2/9.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ZTPhotoCell.h"
@interface ZTPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@end
@implementation ZTPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgPhoto.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    // Initialization code
}

@end
