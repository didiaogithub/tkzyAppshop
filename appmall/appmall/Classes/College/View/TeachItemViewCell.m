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
    self.viewContent.layer.borderColor = [UIColor colorWithHexString:@"#d9d9d9"] .CGColor;
    self.viewContent.layer.borderWidth = 1;
    self.viewContent.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.viewContent.layer.shadowColor = [UIColor colorWithHexString:@"#d9d9d9"] .CGColor;
    self.viewContent.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewContent.layer.shadowOpacity = 0.9f;
    self.viewContent.layer.cornerRadius = 8;
}

-(void)loadData:(TeacherListModel *)model{
    [self.teacherIcon sd_setImageWithURL:[NSURL URLWithString:model.avater]];
    self.teacherName.text = model.name;
    self.teacherPostion.text = model.level;
}

@end
