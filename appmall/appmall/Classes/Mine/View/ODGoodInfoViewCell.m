//
//  ODGoodInfoViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ODGoodInfoViewCell.h"

@implementation ODGoodInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadData:(OrderDetailModel *)model{
    self.labZongeTr.text = [NSString stringWithFormat:@"￥%.2f", [model.totalFee doubleValue]];
    self.labYunfeiTr.text = [NSString stringWithFormat:@"+￥%.2f",[model.freight doubleValue]] ;
    self.labFuKuanTr.text =[NSString stringWithFormat:@"￥%.2f",[model.money doubleValue]] ;
    self.labJianMianTr.text = [NSString stringWithFormat:@"-￥%.2f",[model.discount  doubleValue]];
}

@end