//
//  ClassItemViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassItemViewCell.h"

@implementation ClassItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshDataWIthModel:(ClassListModel *)model{
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    self.classDesc.text = model.introduction;
    self.classTitle.text = model.title;
}
@end
