//
//  SCCategoryTableCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryGoodsModel.h"

@protocol CatogoryAddToShoppingCarDelete <NSObject>

@optional
-(void)catogoryAddGoodsToShoppingCar:(NSString*)goodsId;

-(void)addGoodsToShoppingCar:(SCCategoryGoodsModel*)cateM;

@end

@interface SCCategoryTableCell : UITableViewCell

@property (nonatomic, weak) id<CatogoryAddToShoppingCarDelete> delegate;

@property (nonatomic, strong) SCCategoryGoodsModel *goodsModel;

-(void)refreshCellWithModel:(SCCategoryGoodsModel *)goodsModel;

@end
