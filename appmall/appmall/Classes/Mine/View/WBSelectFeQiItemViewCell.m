//
//  WBSelectFeQiItemViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WBSelectFeQiItemViewCell.h"

@implementation WBSelectFeQiItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData:(LoanRuleListModel *)model{
    self.yingfLab.text = [NSString stringWithFormat:@"应付：¥%.2f",[model.paymoney floatValue]];
    self.haikLab.text = [NSString stringWithFormat:@"最晚还款日:%@",model.paytime];
    self.yuefLab.text = [NSString stringWithFormat:@"%@个月",model.time];;
}
- (IBAction)changeChoose:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tableCellButtonDidSelected:)]) {
        [self.delegate tableCellButtonDidSelected:sender];
    }
}

@end
