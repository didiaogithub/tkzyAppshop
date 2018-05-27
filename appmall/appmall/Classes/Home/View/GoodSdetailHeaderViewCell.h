//
//  GoodSdetailHeaderViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseGoodSDetailViewCell.h"
#import "GoodDetailModel.h"
@interface GoodSdetailHeaderViewCell : BaseGoodSDetailViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *labBannerNum;
@property (weak, nonatomic) IBOutlet UILabel *labGoodName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIButton *labCollect;

@end
