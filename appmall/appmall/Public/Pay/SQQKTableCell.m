//
//  SQQKTableCell.m
//  appmall
//
//  Created by majun on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SQQKTableCell.h"

@implementation SQQKTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickSQQKBtn:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showSQQKView)]) {
        [self.delegate showSQQKView];
    }
}
@end
