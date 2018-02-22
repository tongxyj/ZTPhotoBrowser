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
@property (nonatomic, weak) UIScrollView *scrollTopCategory;//顶部相册类型
@property (nonatomic, weak) ScrollMenuLineView *vMenuLine;//相册类型头部滑动条
@property (nonatomic, assign) NSInteger currentAlbumIndex;//当前选中的相册索引

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
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    CGFloat fCollPhotoListY = [self topLayoutConstraint] + TopCategoryListHeight;
    CGFloat fCollPhotoListHeight = SCREEN_HEIGHT - TopCategoryListHeight - [self topLayoutConstraint];
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, fCollPhotoListHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionPhotoList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, fCollPhotoListY, SCREEN_WIDTH, fCollPhotoListHeight) collectionViewLayout:flowLayout];
    self.collectionPhotoList = collectionPhotoList;
    collectionPhotoList.dataSource = self;
    collectionPhotoList.delegate = self;
    collectionPhotoList.collectionViewLayout = flowLayout;
    collectionPhotoList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    collectionPhotoList.pagingEnabled = YES;
    collectionPhotoList.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionPhotoList];
}

- (void)setupTopCategoryList {
    UIView *topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, [self topLayoutConstraint], SCREEN_WIDTH, TopCategoryListHeight)];
    UIScrollView *categoryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopCategoryListHeight)];
    self.scrollTopCategory = categoryScroll;
    //创建顶部button
    CGFloat buttonWidth = SCREEN_WIDTH / 5;
    ScrollMenuButton *button = nil;
    for (int i = 0; i < PhotoTypeArray.count; ++i) {
        button = [[ScrollMenuButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 3, buttonWidth, TopCategoryListHeight) titile: [PhotoTypeArray objectAtIndex:i] number:@"0"];
        [button addTarget:self action:@selector(didSelectPhotoMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        if (i == 0) {
            button.selected = YES;
            self.btnPreMenuType = button;
        }
        [self.arrMenuBtn addObject:button];
        [categoryScroll addSubview:button];
        //创建顶部滑动条
        ScrollMenuLineView *lineView = [ScrollMenuLineView initScrollMenuLineView];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), buttonWidth, 3);
        self.vMenuLine = lineView;
        
        UIView *subLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineView.width - 20, 3)];
        subLineView.centerX = lineView.centerX;
        subLineView.backgroundColor = def_text_TopCategoryLineBlue;
        [lineView addSubview:subLineView];
        
        [self.scrollTopCategory addSubview:lineView];
    }
    categoryScroll.contentSize = CGSizeMake(buttonWidth * PhotoTypeArray.count , 0);
    [topContainerView addSubview:categoryScroll];
    [self.view addSubview:topContainerView];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return PhotoTypeArray.count;
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
        [self.collectionPhotoList setContentOffset:CGPointMake((sender.tag - 100) *SCREEN_WIDTH, 0) animated:YES];
    if (sender.tag - 100 == (PhotoTypeArray.count / 2 - 1) + 1) {
        [self.scrollTopCategory setContentOffset:CGPointMake(80, 0) animated:YES];
    } else if (sender.tag - 100 == (PhotoTypeArray.count / 2 - 1)) {
        [self.scrollTopCategory setContentOffset:CGPointMake(0, 0) animated:YES];
    }
        self.btnPreMenuType.selected = NO;
        sender.selected = YES;
        self.currentAlbumIndex = sender.tag  - 100;
        self.btnPreMenuType = sender;
}
#pragma mark -
#pragma mark --------------------------UIScrollViewDelegate---------------------------
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat moveX = self.vMenuLine.width * (scrollView.contentOffset.x / SCREEN_WIDTH);
    self.currentAlbumIndex = self.collectionPhotoList.contentOffset.x / self.collectionPhotoList.bounds.size.width;
    if (moveX >= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.vMenuLine.x =  moveX;
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 更新当前选中的索引
    [self updatePhotoTypeIndex:scrollView];
}
/**
 * 更新当前选中的索引
 */
- (void)updatePhotoTypeIndex:(UIScrollView *)scrollView {
    
    self.currentAlbumIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    ScrollMenuButton *currentBtn = nil;
    if (self.currentAlbumIndex < self.arrMenuBtn.count) {
        currentBtn = [self.arrMenuBtn objectAtIndex:self.currentAlbumIndex];
    }
    self.btnPreMenuType.selected = NO;
    currentBtn.selected = YES;
    self.btnPreMenuType = currentBtn;
    if (self.currentAlbumIndex == (PhotoTypeArray.count / 2 - 1) + 1) {
        [self.scrollTopCategory setContentOffset:CGPointMake(80, 0) animated:YES];
    } else if (self.currentAlbumIndex == (PhotoTypeArray.count / 2 - 1)) {
        [self.scrollTopCategory setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
-(CGFloat)topLayoutConstraint {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];//状态栏
    CGRect rectNav = self.navigationController.navigationBar.frame;//导航栏
    return rectStatus.size.height + rectNav.size.height;
}

- (NSMutableArray *)arrMenuBtn {
    if (_arrMenuBtn == nil) {
        _arrMenuBtn = [NSMutableArray arrayWithCapacity:PhotoTypeArray.count];
    }
    return _arrMenuBtn;
}
@end
