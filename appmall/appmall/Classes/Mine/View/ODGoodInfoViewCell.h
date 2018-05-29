//
//  ODGoodInfoViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface ODGoodInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labZonge;
@property (weak, nonatomic) IBOutlet UILabel *labJianMian;
@property (weak, nonatomic) IBOutlet UILabel *labYunfei;
@property (weak, nonatomic) IBOutlet UILabel *labFuKuan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labJianMianHeight;
@property (weak, nonatomic) IBOutlet UILabel *labZongeTr;
@property (weak, nonatomic) IBOutlet UILabel *labJianMianTr;
@property (weak, nonatomic) IBOutlet UILabel *labYunfeiTr;
@property (weak, nonatomic) IBOutlet UILabel *labFuKuanTr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labJianMianHeightTr;
-(void)loadData:(OrderDetailModel *)model;
@end
