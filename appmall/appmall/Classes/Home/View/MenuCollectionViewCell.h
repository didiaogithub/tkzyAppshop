//
//  HomeMenuItemView.h
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKHomeDataModel.h"


@protocol HomeMenuItemViewDelegate <NSObject>

-(void)itemClick:(SortModel *)index;

@end
@interface MenuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAndBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomConstraints;
@property(nonatomic,weak)id <HomeMenuItemViewDelegate> delegate;

-(void)setItemIcom:(SortModel *)model;
@end
