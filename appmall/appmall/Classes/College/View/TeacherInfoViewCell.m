//
//  TeacherInfoViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeacherInfoViewCell.h"

@interface TeacherInfoViewCell()
{
    __weak IBOutlet UIImageView *imgTopView;
    __weak IBOutlet UIImageView *imgNumberIcon;
    __weak IBOutlet UILabel *labTeacherName;
    
    __weak IBOutlet UILabel *labTeacherInfo;
    __weak IBOutlet UILabel *labTeacherPostion;
}
@end

@implementation TeacherInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    imgNumberIcon.layer.cornerRadius = imgNumberIcon.mj_h/ 2;
    imgNumberIcon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshData:(TeacherListItemModel *)model{
    [imgNumberIcon sd_setImageWithURL:[NSURL URLWithString:model .avater]];
    labTeacherInfo .text = model.introduction;
    labTeacherPostion.text = model.level;
    labTeacherName.text = model.name;
}

@end
