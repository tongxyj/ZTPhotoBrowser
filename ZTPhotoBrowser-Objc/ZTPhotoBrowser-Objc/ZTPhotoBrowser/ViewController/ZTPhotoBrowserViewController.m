//
//  ZTPhotoBrowserViewController.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ZTPhotoBrowserViewController.h"
#import "ZTPhotoCategoryViewController.h"
#import "UIView+extension.h"
#import "UICollectionView+CustomCell.h"
#import "ScrollMenuButton.h"
#import "ZTPhotoCategoryCell.h"

static NSString *sResuseCollectionId = @"ZTPhotoCategoryCell";

@interface ZTPhotoBrowserViewController ()
<
    ZTPhotoCategoryViewControllerDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>
@property (nonatomic, strong) NSMutableArray *arrMenuBtn;//存放顶部相册类型按钮
@property (nonatomic, weak) UIButton *btnPreMenuType;//前一个选中的类型按钮
@property (nonatomic, weak) UICollectionView *collectionPhotoList;//图片视图列表

@end

@implementation ZTPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI {
    [self setupBaseView];
    [self setupTopView];
    [self setupCollectionView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)setupBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setupTopView {
    switch (self.browserVCType) {
        case ZTPhotoBrowserVCTypeCategory:
            [self setupTopCategoryList];
            break;
        default:
            break;
    }
}
/**
 * 配置collectionView
 */
- (void)setupCollectionView {
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat fCollPhotoListY = [self topLayoutConstraint] + TopCategoryListHeight;
    UICollectionView *collectionPhotoList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, fCollPhotoListY, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionPhotoList = collectionPhotoList;
    collectionPhotoList.dataSource = self;
    collectionPhotoList.delegate = self;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 119);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionPhotoList.collectionViewLayout = flowLayout;
    collectionPhotoList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    collectionPhotoList.pagingEnabled = YES;
    collectionPhotoList.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionPhotoList];
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


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZTPhotoCategoryCell *cell = (ZTPhotoCategoryCell *)[collectionView customdq:sResuseCollectionId indexPath:indexPath];
    cell.photoCategoryVC.delegate = self;
    [cell.photoCategoryVC.collectionView reloadData];
    //view chain
    if (![self.childViewControllers containsObject:cell.photoCategoryVC]) {
        [self addChildViewController:(ZTPhotoCategoryViewController *)cell.photoCategoryVC];
    }
    return cell;
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
- (NSMutableArray *)arrMenuBtn {
    if (_arrMenuBtn == nil) {
        _arrMenuBtn = [NSMutableArray arrayWithCapacity:PhotoTypeCount];
    }
    return _arrMenuBtn;
}
@end
