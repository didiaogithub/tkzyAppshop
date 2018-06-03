//
//  ArrearsTableCell.m
//  appmall
//
//  Created by majun on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsTableCell.h"
#import "Item.h"
@implementation ArrearsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData:(Item *)model{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.path1] placeholderImage:nil];
    self.nameLab.text = model.name;
    self.NoAndGGLab.text = [NSString stringWithFormat:@"编号：%@；规格：%@",model.itemno,model.spec];
    self.num.text = [NSString stringWithFormat:@"x%@",model.count];
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",model.price];
}

@end
