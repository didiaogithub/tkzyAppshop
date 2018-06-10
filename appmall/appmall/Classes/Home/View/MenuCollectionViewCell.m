//
//  HomeMenuItemView.m
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "MenuCollectionViewCell.h"


@interface MenuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgItemIcon;
@property (weak, nonatomic) IBOutlet UILabel *labItemTitle;
@property(nonatomic,strong) SortModel *model;
@property (weak, nonatomic) IBOutlet UIButton *itemBack;


@end

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setItemIcom:(SortModel *)model{
    self.model = model;
    self.imgItemIcon.layer.cornerRadius = self.imgItemIcon.mj_h/2;
    self.imgItemIcon.layer.masksToBounds = YES;
    self.labItemTitle.text = model.sortname;
    [self.imgItemIcon sd_setImageWithURL:[NSURL URLWithString:model.imgpath] placeholderImage:[UIImage imageNamed:@""]];
}
- (IBAction)itemClick:(UIButton *)sender {
    [self.delegate itemClick:self.model];
    
}

@end
