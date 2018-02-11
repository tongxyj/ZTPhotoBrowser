//
//  ScrollMenuButton.m
//  CarBaDa
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2017年 zhaitong. All rights reserved.
//

#import "ScrollMenuButton.h"
#import "ZTPhotoBrowserGlobal.h"

@implementation ScrollMenuButton

- (instancetype)initWithFrame:(CGRect)frame titile:(NSString *)title number:(NSString *)number {
    self = [super initWithFrame:frame];
    if (self) {
        NSString  *string = [NSString stringWithFormat:@"%@\n%@",title,number];
        
        self.titleLabel.lineBreakMode = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSFontAttributeName value:font_TopCategoryTitle range:NSMakeRange(0, title.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategoryNormal range:NSMakeRange(0, title.length)];
        [attributedString addAttribute:NSFontAttributeName value:font_Hint range:NSMakeRange(title.length+1,number.length)];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategoryNormal range:NSMakeRange(title.length+1,number.length)];
        [self setAttributedTitle:attributedString forState:UIControlStateNormal];
        NSMutableAttributedString *selectedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [selectedString addAttribute:NSFontAttributeName value:font_TopCategoryTitle range:NSMakeRange(0, title.length)];
        [selectedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategorySelected range:NSMakeRange(0, title.length)];
        [selectedString addAttribute:NSFontAttributeName value:font_Hint range:NSMakeRange(title.length+1,number.length)];
        
        [selectedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategorySelected range:NSMakeRange(title.length+1,number.length)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setAttributedTitle:selectedString forState:UIControlStateSelected];
        
    }
    return self;
}
- (void)setNumber:(NSInteger)iNumber {
    NSString *sNumber = [NSString stringWithFormat:@"%zd",iNumber];
    NSMutableAttributedString *currentAttributedString = [self.currentAttributedTitle mutableCopy];
    [currentAttributedString replaceCharactersInRange:NSMakeRange(currentAttributedString.length - 1, 1) withString:sNumber];
    [self setAttributedTitle:currentAttributedString forState:UIControlStateNormal];
    [currentAttributedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategoryNormal range:NSMakeRange(0,currentAttributedString.length)];
    NSMutableAttributedString *selectedAttributedString = [currentAttributedString mutableCopy];
    [selectedAttributedString addAttribute:NSForegroundColorAttributeName value:def_text_TopCategorySelected range:NSMakeRange(0,currentAttributedString.length)];

    
    [self setAttributedTitle:selectedAttributedString forState:UIControlStateSelected];
}
@end

@implementation ScrollMenuLineView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


+ (instancetype)initScrollMenuLineView {
    ScrollMenuLineView *view = [[ScrollMenuLineView alloc] init];
    return view;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    CGRect lineRect = self.frame;
    lineRect.size.width = _lineWidth;
    self.frame = lineRect;
    
}

@end
