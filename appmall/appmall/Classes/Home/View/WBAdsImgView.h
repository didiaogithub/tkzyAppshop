//
//  WBAdsImgView.h
//  happyLottery
//
//  Created by 壮壮 on 2017/12/6.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TKHomeDataModel.h"
#import "TKSchoolModel.h"
@protocol WBAdsImgViewDelegate

-(void)adsImgViewClick:(BannerModel*)itemIndex;

@end


@interface WBAdsImgView : UIView


@property(nonatomic,weak)id<WBAdsImgViewDelegate>delegate;
-(void)setImageUrlArray:(NSArray<BannerModel *> *)imgUrls;

-(void)setImageUrlArrayTkSchool:(NSArray<BannerListModel *> *)imgUrls;


@end
