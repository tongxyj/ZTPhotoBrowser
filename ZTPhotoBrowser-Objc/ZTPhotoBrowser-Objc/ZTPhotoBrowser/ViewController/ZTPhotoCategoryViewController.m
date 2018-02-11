//
//  ZTPhotoCategoryViewController.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/2/9.
//  Copyright © 2018年 zhaitong. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZTPhotoCategoryViewController.h"
#import "ZTPhotoCell.h"
#import "UICollectionView+CustomCell.h"
#import "PhotoBrowserView.h"
@interface ZTPhotoCategoryViewController ()

@end

@implementation ZTPhotoCategoryViewController

static NSString * const sPhotoCellReuseIdentifier = @"ZTPhotoCell";
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(widthOfItems, heightOfItems);
    layout.sectionInset =UIEdgeInsetsMake(10, 10, 10, 10);
    return [super initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCollectionView];
}
- (void)registerCollectionView {
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZTPhotoCell *cell = (ZTPhotoCell *)[collectionView customdq:sPhotoCellReuseIdentifier indexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //任务栏隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    PhotoBrowserView *photoBrowseView = [[PhotoBrowserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) resourceImgArr:@[] imageIndex:indexPath.item saveImage:^(UIImage *saveImage) {
        //保存相册图片
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        photoBrowseView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:photoBrowseView];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (error) {
        
        if (author == ALAuthorizationStatusAuthorized){
            //有权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存" message:@"请在iPhone的“设置-隐私-照片”选项中，允许APP访问你的照片。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    }else {
        //保存成功弹框提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"保存成功"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
