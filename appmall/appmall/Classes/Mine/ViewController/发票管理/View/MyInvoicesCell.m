//
//  MyInvoicesCell.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MyInvoicesCell.h"

@implementation MyInvoicesCell
{
    MyInvoicesModel *selfModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData:(MyInvoicesModel *)model{
    selfModel = model;
    if ([model.invoiceheadtype isEqualToString:@"1"]) {
        self.typeLab.text = @"个人/非企业单位";
    }else{
        self.typeLab.text = @"企业单位";
    }
    
    self.fpttLab.text = model.issuingoffice;
    self.shLab.text = model.number;
}
- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableCellButtonDidSelected:)]) {
        [self.delegate  tableCellButtonDidSelected:selfModel];
        
    }
}

@end
