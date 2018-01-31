//
//  ZTPhotoBrowserViewController.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ZTPhotoBrowserViewController.h"
#import "ZTPhotoBrowserGlobal.h"
#import "UIView+extension.h"
#import "ScrollMenuButton.h"


@interface ZTPhotoBrowserViewController ()
@property (nonatomic, strong) NSMutableArray *arrMenuBtn;//存放顶部相册类型按钮
@property (nonatomic, weak) UIButton *btnPreMenuType;//前一个选中的类型按钮

@end

@implementation ZTPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI {
    [self setupBaseView];
     [self setupTopView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)setupBaseView {
    self.view.backgroundColor = [UIColor whiteColor];

}
- (void)setupTopView {
    switch (self.photoParams.browserVCType) {
        case ZTPhotoBrowserVCTypeCategory:
            [self setupTopCategoryList];
            break;
        default:
            break;
    }
}
- (NSMutableArray *)arrMenuBtn {
    if (_arrMenuBtn == nil) {
        _arrMenuBtn = [NSMutableArray arrayWithCapacity:PhotoTypeCount];
    }
    return _arrMenuBtn;
}
- (void)setupTopCategoryList {
    UIView *topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, [self topLayoutConstraint], SCREEN_WIDTH, TopCategoryListHeight)];
    UIScrollView *categoryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopCategoryListHeight)];
    //创建顶部button
    CGFloat buttonWidth = SCREEN_WIDTH / PhotoTypeCount;
    ScrollMenuButton *button = nil;
    self.arrMenuBtn = [NSMutableArray arrayWithCapacity:PhotoTypeCount];

    for (int i = 0; i < PhotoTypeCount; ++i) {
        button = [[ScrollMenuButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 3, buttonWidth, TopCategoryListHeight) titile: [PhotoTypeArray objectAtIndex:i] number:@"0"];
        [button addTarget:self action:@selector(didSelectPhotoMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        if (i == 0) {
            button.selected = YES;
            self.btnPreMenuType = button;
        }
        [self.arrMenuBtn addObject:button];
        [categoryScroll addSubview:button];
    }
    
    [topContainerView addSubview:categoryScroll];
    [self.view addSubview:topContainerView];
}

/**
 * 点击顶部价格策类型按钮
 */
- (void)didSelectPhotoMenuButton:(UIButton *)sender {
    
//    [self.collectionPhoto setContentOffset:CGPointMake((sender.tag - 100) *SCREEN_WIDTH, 0) animated:YES];
//    self.btnPreMenuType.selected = NO;
//    sender.selected = YES;
//    self.currentAlbumIndex = sender.tag  - 100;
//    self.btnPreMenuType = sender;
}
-(CGFloat)topLayoutConstraint {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];//状态栏
    CGRect rectNav = self.navigationController.navigationBar.frame;//导航栏
    return rectStatus.size.height + rectNav.size.height;
}
@end
