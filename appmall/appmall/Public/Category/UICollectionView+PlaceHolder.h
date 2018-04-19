//
//  UICollectionView+PlaceHolder.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (PlaceHolder)

-(void)collectionViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;

@end
