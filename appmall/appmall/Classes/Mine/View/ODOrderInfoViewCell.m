//
//  ODOrderInfoViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ODOrderInfoViewCell.h"

@implementation ODOrderInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(OrderDetailModel *)model{
    [self labSetTitle:model.orderNo andTitleEx:@"订单号：" andLable:self.labOrderNo];
    [self labSetTitle:model.orderTime andTitleEx:@"下单时间：" andLable:self.labOrderTime];
    [self labSetTitle:model.paytn andTitleEx:@"支付流水号：" andLable:self.labZhifuNo];
    [self labSetTitle:model.payTime andTitleEx:@"支付时间：" andLable:self.labPayTime];
    if (model.logistics != nil) {
        self.labWuliu.text =[NSString stringWithFormat:@"快递公司：%@",model.logistics.companyName];
        self.labWuliuNo.text =[NSString stringWithFormat:@"快递单号：%@",model.logistics.number];
    }else{
        self.labWuliu.text =@"";
        self.labWuliuNo.text =@"";
    }
}

-(void)labSetTitle:(NSString *)title andTitleEx:(NSString *)titEx andLable:(UILabel *)lab {
    if (title == nil) {
        lab.text = [NSString stringWithFormat:@"%@：暂无",titEx];
    }else{
         lab.text = [NSString stringWithFormat:@"%@%@",titEx,title];
    }
}

@end
