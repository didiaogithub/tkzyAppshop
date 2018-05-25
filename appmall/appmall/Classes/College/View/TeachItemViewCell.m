//
//  TeachItemViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/13.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeachItemViewCell.h"

@implementation TeachItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.teacherIcon.layer.cornerRadius = self.teacherIcon.mj_h/ 2;
    self.teacherIcon.layer.masksToBounds = YES;
    self.viewContent.layer .cornerRadius = 4;
    self.viewContent.layer.borderColor = RGBCOLOR(200, 200, 200).CGColor;
    self.viewContent.layer.borderWidth = 1;
}

-(void)loadData:(TeacherListModel *)model{
    [self.teacherIcon sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.teacherName.text = model.name;
    self.teacherPostion.text = model.level;
}

@end
