//
//  UICollectionView+PlaceHolder.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "UICollectionView+PlaceHolder.h"

@implementation UICollectionView (PlaceHolder)

-(void)collectionViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount {
    
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    if (rowCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = YES;
    } else {
        self.scrollEnabled = YES;
        self.backgroundView = nil;
    }
}

@end
