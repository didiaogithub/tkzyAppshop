//
//  AmortizationLoanCell.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AmortizationLoanCell.h"

@implementation AmortizationLoanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)refreshData:(Stag *)model{
//    self.orderNoLab.text = [NSString stringWithFormat:@"%@",model.]
    self.timeLab.text = [NSString stringWithFormat:@"应还款时间:%@",model.paybackTime];
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",model.paymoney];
}



@end
