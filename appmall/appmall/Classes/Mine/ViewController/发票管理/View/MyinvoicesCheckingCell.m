//
//  MyinvoicesCheckingCell.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MyinvoicesCheckingCell.h"

@implementation MyinvoicesCheckingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)refreshData:(MyInvoicesModel *)model{
    if ([model.invoiceheadtype isEqualToString:@"1"]) {
        self.typeLab.text = @"个人/非企业单位";
    }else{
        self.typeLab.text = @"企业单位";
    }
    
    self.fpttLab.text = model.issuingoffice;
    self.shLab.text = model.number;
}

@end
