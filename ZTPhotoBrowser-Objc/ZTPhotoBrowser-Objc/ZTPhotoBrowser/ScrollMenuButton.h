//
//  ScrollMenuButton.h
//  CarBaDa
//
//  Created by zhaitong on 17/4/6.
//  Copyright © 2017年 zhaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollMenuButton : UIButton
-(instancetype)initWithFrame:(CGRect)frame titile:(NSString *)title number:(NSString *)number;
- (void)setNumber:(NSInteger)iNumber;
@end

@interface ScrollMenuLineView : UIView

+ (instancetype)initHotelScrollMenuLineView;
@property (nonatomic, assign) CGFloat lineWidth;

@end
