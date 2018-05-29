//
//  ODGoodsTableViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ODGoodsTableViewCell.h"

@implementation ODGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(GoodSmodel *)model{
    self.labGoodName.text = model.name;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.labGoodInfo.text = [NSString stringWithFormat:@"编号：%@    规格：%@",model.itemid,model.specification];
    self.labNum.text = [NSString stringWithFormat:@"X%@",model.number];
    self.btnBack.hidden =  ![model.feedback boolValue];
}

@end
