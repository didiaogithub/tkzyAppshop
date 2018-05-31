
//
//  MessageDetailViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MessageDetailViewCell.h"

@implementation MessageDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadData:(MessagDetailModel *)model{
    self.labTime.text = model.time;
    self.labTitle.text = model.title;
    self.labContent.text = model.content;
}

@end
