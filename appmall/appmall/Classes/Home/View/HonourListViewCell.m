
//
//  HonourListViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HonourListViewCell.h"

@interface HonourListViewCell()
{
    __weak IBOutlet UIImageView *imgHonorIcon;
    __weak IBOutlet UILabel *labTime;
    __weak IBOutlet UILabel *labTitle;
    
    __weak IBOutlet UILabel *labDesc;
}

@end
@implementation HonourListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadDataModel:(HonorListModel *)model{
    if(model.time.length > 0){
        labTime.text = [[model.time componentsSeparatedByString:@" "] firstObject];
    }
    
    labDesc.text = model._description;
    labTitle.text = model.title;
    [imgHonorIcon sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
}

@end
