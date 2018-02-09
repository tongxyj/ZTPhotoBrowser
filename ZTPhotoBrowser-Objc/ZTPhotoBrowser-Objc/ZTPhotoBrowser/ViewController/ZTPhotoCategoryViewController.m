//
//  ZTPhotoCategoryViewController.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/2/9.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ZTPhotoCategoryViewController.h"
#import "ZTPhotoCell.h"
#import "UICollectionView+CustomCell.h"
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
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZTPhotoCell *cell = (ZTPhotoCell *)[collectionView customdq:sPhotoCellReuseIdentifier indexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
