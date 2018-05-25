//
//  CommPingLunViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommPingLunViewCell.h"

@implementation CommPingLunViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionComDetail:(id)sender {
}

-(void)refreshData:(CommPingLunModel *)model{
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.head]];
    self.labName.text = model.name;
    self.labContent.text = model.content;
    self.labTime.text = [model.time substringWithRange:NSMakeRange(4, 11)];
    if (model.comment.count == 0) {
        self.heightBottom.constant  =0;
        
    }else{
        self.heightBottom.constant = 32;
    }
}

@end
