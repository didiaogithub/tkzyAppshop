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
@end
