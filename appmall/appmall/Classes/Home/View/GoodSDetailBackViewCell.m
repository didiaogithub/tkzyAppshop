//
//  GoodSDetailBackViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodSDetailBackViewCell.h"
#import "GoodDetailModel.h"
@implementation GoodSDetailBackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h / 2;
    self.imgIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataWithModel:(GoodCommentModel *)model{
    self.labTime.text = model.time;
    self.labComm.text = model.content;
    self.labName.text = model.smallname;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.head]];
}

@end
