//
//  CommunityViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommunityViewCell.h"
#import "CommPingLunListViewController.h"
#import "CKShareManager.h"
@interface CommunityViewCell (){
CommListModelItem * selfModel ;
}

@end

@implementation CommunityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgCommIcon.layer .cornerRadius = self.imgCommIcon.mj_h / 2;
    self.imgCommIcon.layer.masksToBounds = YES;
}

-(void)refreshData:(CommListModelItem *)model{
    selfModel = model;
    [self.btnDianzan setTitle:[NSString stringWithFormat:@"%@",model.praisenum] forState:0];
    [self.btnComm setTitle:[NSString stringWithFormat:@"%@",model.commentnum] forState:0];
    [self.btnShare setTitle:[NSString stringWithFormat:@"%@",model.forwardnum] forState:0];
    self.btnDianzan.selected = [model.ispraise boolValue];
    [self.imgCommIcon sd_setImageWithURL:[NSURL URLWithString:model.head]];
    self.labCommName.text = model.name;
    self.labCommTime.text = [model.time substringWithRange:NSMakeRange(5, 11)];
    self.labCommContent.text = model.content;
    [self setImage:self.img1 imgName:model.path1];
    [self setImage:self.img2 imgName:model.path2];
    [self setImage:self.img3 imgName:model.path3];
    [self setImage:self.img4 imgName:model.path4];
    [self.btnComm setTitle:model.commentnum forState:0];
    [self.btnShare setTitle:model.forwardnum forState:0];
    [self.btnDianzan setTitle:model.praisenum forState:0];
}

-(void)setImage:(UIButton *)imgV imgName:(NSString *)name{
    if (!IsNilOrNull(name)) {
        imgV.hidden = NO;
        [imgV sd_setImageWithURL:[NSURL URLWithString:name] forState:0];
    }else{
        imgV.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actionGood:(id)sender {
    [self .delegate communityViewCellGood:selfModel andIndex:self.index];
}
- (IBAction)actionShare:(id)sender {

    [self .delegate comunityShare:selfModel andIndex:self.index];
}



- (IBAction)actionComm:(id)sender {
    CommPingLunListViewController *listVC = [[CommPingLunListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    listVC. notiID =selfModel._id;
    [[self getCurrentVC].navigationController pushViewController:listVC animated:YES];
}

- (IBAction)showBigImage:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showBigImageWithModel: andBtn:)]) {
        [self.delegate showBigImageWithModel:selfModel andBtn:sender];
    }
}
@end
