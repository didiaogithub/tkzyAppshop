//
//  InvoicesManagerCell.m
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerCell.h"

@implementation InvoicesManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showDetailAction:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(showDetail:)]) {
        [self.delegete showDetail:sender];
    }
}

- (void)refreshData:(Ordersheet *)model{
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLab.text = model.itemspec;
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.numAndGgLab.text = [NSString stringWithFormat:@"编号：%@；规格：%@",model.itemno,model.itemspec];
    self.numLab.text = [NSString stringWithFormat:@"X%@",model.count];
}
@end
