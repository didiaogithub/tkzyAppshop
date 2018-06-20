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
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 3;
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
    self.nameLab.text = model.name;
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.labNo.text = [NSString stringWithFormat:@"产品编号：%@",model.itemno];
    self.labGG.text = [NSString stringWithFormat:@"产品规格：%@",model.itemspec];
    self.numLab.text = [NSString stringWithFormat:@"X%@",model.count];
}
@end
