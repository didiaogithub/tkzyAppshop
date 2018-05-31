//
//  WuliuHeaderViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WuliuHeaderViewCell.h"

@implementation WuliuHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

        // Configure the view for the selected state
}
-(void)loadData:(WuliuModel *)model{
    [self.imgIcon sd_setImageWithURL: [NSURL URLWithString:model.img]];
    self.labGoodNum.text = [NSString stringWithFormat:@"%@件商品",model.goodNum];
    self.labComPname.text = [NSString stringWithFormat:@"快递公司  %@",model.companyName];
    self.labOrderNum.text = [NSString stringWithFormat:@"快递单号  %@",model.number];
}

@end
