//
//  UICollectionView+CustomCell.m
//  CarBaDa
//
//  Created by zhaitong on 16/9/27.
//  Copyright © 2016年 zhaitong. All rights reserved.
//

#import "UICollectionView+CustomCell.h"

@implementation UICollectionView (CustomCell)
-(UICollectionViewCell *)customdq:(NSString *const)identifier indexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell* cell  = nil;
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
    for (id oneObject in nibs){
        if ([oneObject isKindOfClass:NSClassFromString(identifier)]){
            [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
            cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        }
    }
    
    if(!cell){
        [self registerClass:NSClassFromString(identifier) forCellWithReuseIdentifier:identifier];
        cell   = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }

    return cell;
    
}
@end

