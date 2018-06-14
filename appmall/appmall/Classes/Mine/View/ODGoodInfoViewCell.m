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
    self.labJianMianTr.text = [NSString stringWithFormat:@"-￥%.2f",fabs([model.discount  doubleValue])];
    if ([model.serviceMoney  doubleValue] == 0) {
        self.labJianMianHeight.constant = 0;
        self.labJianMianHeightTr.constant = 0;
        self.labYunfei.hidden = YES;
        self.labserviceMoney.hidden = YES;
    }else{
        self.labJianMianHeight.constant = 15;
        self.labJianMianHeightTr.constant = 15;
        self.labYunfei.hidden = NO;
        self.labserviceMoney.hidden = NO;
         self.labserviceMoney.text = [NSString stringWithFormat:@"+￥%.2f",[model.serviceMoney  doubleValue]];
    }
    
    if ([model.status integerValue] == 0 || [model.status integerValue] == 1) {
        self.labFuKuan.text = @"应付款";
    }else{
        self.labFuKuan.text = @"实际付款";
    }
    
}

@end
