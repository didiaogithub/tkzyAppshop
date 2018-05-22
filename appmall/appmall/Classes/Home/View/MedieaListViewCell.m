//
//  MedieaListViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MedieaListViewCell.h"
@interface MedieaListViewCell()
{
    __weak IBOutlet UILabel *labMediaTitle;
    __weak IBOutlet UILabel *labMediaTime;
    
    __weak IBOutlet UIImageView *imgMedia;
}
@end

@implementation MedieaListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadDataModel:(MediaListModel *)model{
    labMediaTime.text = model.time;
    labMediaTitle.text = model.title;
    [imgMedia sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
}


@end
