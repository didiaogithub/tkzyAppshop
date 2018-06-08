//
//  ODGoodsTableViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface ODGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labGoodName;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labGoodInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rebuyDisRight;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnRebuy;

@property(nonatomic,strong)NSString *orderid;
-(void)loadData:(GoodSmodel *)model;
-(void)setCellBtnState:(NSInteger) state;
@end
