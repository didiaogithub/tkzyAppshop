
//
//  MessageDetailViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MessageOffDetailViewCell.h"

@implementation MessageOffDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadData:(MessagDetailOffModel *)model{
    self.labTime.text = model.time;
    self.labTitle.text = model.title;
    self.labContent.text = model.content;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.img]];
}

@end
