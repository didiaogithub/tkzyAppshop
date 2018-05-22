//
//  TeacherClassListViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeacherClassListViewCell.h"

@interface TeacherClassListViewCell()
{
    
    __weak IBOutlet UILabel *labClassAnswer;
    __weak IBOutlet UILabel *labClassQuestion;
    __weak IBOutlet UIImageView *imgClassIcon;
}

@end

@implementation TeacherClassListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
