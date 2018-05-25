//
//  TeacherItemViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeacherItemViewCell.h"
@interface TeacherItemViewCell()
{
    __weak IBOutlet UIImageView *imgTeacherIcon;
    __weak IBOutlet UILabel *labTeacherName;
    
    __weak IBOutlet UILabel *labTeacherInfo;
    __weak IBOutlet UILabel *labTeacherPostion;
}
@end

@implementation TeacherItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)refreshDataWithModel:(TeacherListItemModel *)model{
    [imgTeacherIcon sd_setImageWithURL:[NSURL URLWithString:model.avater]];
    imgTeacherIcon.layer.cornerRadius = imgTeacherIcon.mj_h / 2;
    imgTeacherIcon.layer.masksToBounds = YES;
    labTeacherName.text = model.name;
    labTeacherPostion.text = model.level;
    labTeacherInfo.text = [NSString stringWithFormat:@"主要成就：%@",model.introduction];
}

@end
