//
//  PhotoBrowserView.m
//  CarBaDa
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2017年 zhaitong. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "UIView+extension.h"
#import "ZTPhotoBrowserGlobal.h"
#import "AppDelegate.h"
@interface MyCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgvPhoto;
@property (nonatomic, copy) NSString *sNormalImgUrl;//普通的图片地址
@end
@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgvPhoto  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
        _imgvPhoto.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgvPhoto];
    }
    
    return self;
}

@end

@interface PhotoBrowserView ()
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, weak) UIButton *coverBtn;
@property (nonatomic, weak) UILabel *lblPage;//页数
@property (nonatomic, weak) UILabel *lblImageTag;//底部图片标签
@property (nonatomic, assign) NSInteger currentPhotoIndex;//当前选中的相册索引
@property (nonatomic, assign) NSInteger iTotalPhotoCount;//图片总数
@property (nonatomic, strong) NSMutableArray *arrNormalImage;//单纯展示图片时候的图片数组
@property (nonatomic, copy) NSArray *arrImageResource;//图片对象数组
@property (nonatomic, copy) NSArray *arrNormalLabel;//单纯展示图片底下的评论
@property (nonatomic, copy) BlkSaveImage blkSaveImage;//保存的图片
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@end

static  NSString *sCollectionCellReuseID = @"reusableCell";

@implementation PhotoBrowserView
- (instancetype)initWitFrame:(CGRect)frame imgArray:(NSArray *)imgArr labelArray:(NSArray *)labelArr  imageIndex:(NSInteger)currentImgIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.iTotalPhotoCount = imgArr.count;
        self.arrNormalImage = [NSMutableArray arrayWithArray:imgArr];
        self.arrNormalLabel = labelArr;
        [self setupUI:frame resourceImgArr:nil normalImgArr:imgArr imageIndex:currentImgIndex];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame resourceImgArr:(NSArray *)arrResourceImg imageIndex:(NSInteger)currentImgIndex saveImage:(BlkSaveImage)blkSaveImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.arrImageResource = arrResourceImg;
        self.iTotalPhotoCount = arrResourceImg.count;
        self.blkSaveImage = blkSaveImage;
        [self setupUI:frame resourceImgArr:arrResourceImg normalImgArr:nil imageIndex:currentImgIndex];
    }
    return self;
}
- (void)setupUI:(CGRect)frame resourceImgArr:(NSArray *)arrResourceImg normalImgArr:(NSArray *)arrNormal imageIndex:(NSInteger)currentImgIndex {
    
    self.alpha = 0;
    [self registerCollectionView];
    [_mainCollectionView setContentOffset:CGPointMake(currentImgIndex * SCREEN_WIDTH, 0)];
    
    // 添加关闭按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 50, 40)];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"arrow_return_title"] forState:UIControlStateNormal];
    [btnClose sizeToFit];
    [btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    //添加页数label
    UILabel *lblPage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.lblPage = lblPage;
    lblPage.textColor = [UIColor whiteColor];
    lblPage.text = [NSString stringWithFormat:@"%zd/%zd",currentImgIndex + 1,self.iTotalPhotoCount];
    [lblPage sizeToFit];
    lblPage.x = SCREEN_WIDTH - lblPage.width - 15;
    lblPage.y = SCREEN_HEIGHT - lblPage.height - 15;
    [self addSubview:lblPage];
    
    if (arrResourceImg.count > 0) {
        // 添加右侧保存图片按钮
        UIButton *btnDownLoad = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 40, 40)];
        [btnDownLoad setBackgroundImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
        [btnDownLoad sizeToFit];
        btnDownLoad.x = SCREEN_WIDTH - btnDownLoad.width - 15;
        [btnDownLoad addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDownLoad];
    }
    // 底部图片标签
    UILabel *lblImageTag = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    self.lblImageTag = lblImageTag;
    lblImageTag.text = @"标签";
    
    [lblImageTag sizeToFit];
    lblImageTag.y = SCREEN_HEIGHT - lblImageTag.height - 15;
    lblImageTag.textColor = [UIColor whiteColor];
    [self addSubview:lblImageTag];
    
    //遮盖
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
    
}
- (void)registerCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 0;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256) collectionViewLayout:layout];
    _mainCollectionView.centerY = self.centerY;
    [self addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    _mainCollectionView.pagingEnabled = YES;
    [_mainCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:sCollectionCellReuseID];
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}
#pragma mark -
#pragma mark --------------------------UICollectionViewDelegate---------------------------
#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrImageResource.count > 0) {//酒店详情相册
        return self.arrImageResource.count;
    } else if (self.arrNormalImage.count > 0) {//普通相册
        return self.arrNormalImage.count;
    } else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:sCollectionCellReuseID forIndexPath:indexPath];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 256);
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
}
#pragma mark -
#pragma mark --------------------------UIScrollViewDelegate---------------------------
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPhotoIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self updatePhotoIndexAndLabel:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self updatePhotoIndexAndLabel:scrollView];
}

- (void)updatePhotoIndexAndLabel:(UIScrollView *)scrollView {
    self.currentPhotoIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _lblPage.text = [NSString stringWithFormat:@"%zd/%zd",self.currentPhotoIndex + 1,self.iTotalPhotoCount];
    [_lblPage sizeToFit];
    _lblPage.x = SCREEN_WIDTH - _lblPage.width - 15;
}

- (void)savePhoto {
    //拼接图片地址
    UIImage *imgPhoto = [[UIImage alloc] init];
    
    if (self.blkSaveImage) {
        self.blkSaveImage(imgPhoto);
    }
}
- (void)hide {
    //任务栏隐藏
    __weak __typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        for (UIView *subView in weakSelf.subviews) {
            [subView removeFromSuperview];
        }
    }];
}



@end
