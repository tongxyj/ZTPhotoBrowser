//
//  PhotoBrowserView.h
//  CarBaDa
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2017年 zhaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlkSaveImage)(UIImage *saveImage);

@interface PhotoBrowserView : UIView
- (instancetype)initWitFrame:(CGRect)frame imgArray:(NSArray *)imgArr labelArray:(NSArray *)labelArr  imageIndex:(NSInteger)currentImgIndex;
- (instancetype)initWithFrame:(CGRect)frame resourceImgArr:(NSArray *)arrResourceImg imageIndex:(NSInteger)currentImgIndex saveImage:(BlkSaveImage)blkSaveImage;
@end
