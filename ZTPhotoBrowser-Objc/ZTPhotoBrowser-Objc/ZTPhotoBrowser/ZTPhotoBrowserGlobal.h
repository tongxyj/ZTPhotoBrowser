//
//  ZTPhotoBrowserGlobal.h
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#ifndef ZTPhotoBrowserGlobal_h
#define ZTPhotoBrowserGlobal_h

typedef NS_ENUM(NSInteger, ZTPhotoBrowserVCType) {
    ZTPhotoBrowserVCTypePlain = 0,
    ZTPhotoBrowserVCTypeCategory
};

#define RGBA(r,g,b,a)                        [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define widthOfItems (SCREEN_WIDTH - 30) / 2
#define heightOfItems widthOfItems * 3 / 4

#define PhotoTypeArray @[@"One", @"Two", @"Three", @"Four", @"Five",@"Six"]
#define TopCategoryListHeight 50

#define font_TopCategoryTitle                       [UIFont systemFontOfSize:14.f]
#define font_Hint                                            [UIFont systemFontOfSize:12.f]
#define def_text_TopCategoryNormal            RGBA(51,51,51,1)
#define def_text_TopCategorySelected         RGBA(68,138,255,1)
#define def_text_TopCategoryLineBlue         RGBA(68,138,255,1)
#endif /* ZTPhotoBrowserGlobal_h */
