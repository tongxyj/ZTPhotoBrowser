//
//  ZTPhotoCategoryViewController.h
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/2/9.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTPhotoBrowserGlobal.h"
@protocol ZTPhotoCategoryViewControllerDelegate<NSObject>
@optional
- (void)didSelectPhotoItem;
@end
@interface ZTPhotoCategoryViewController : UICollectionViewController
@property (nonatomic, weak) id<ZTPhotoCategoryViewControllerDelegate> delegate;
@end
