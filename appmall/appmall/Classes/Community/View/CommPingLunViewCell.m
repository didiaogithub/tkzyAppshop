//
//  CommPingLunViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommPingLunViewCell.h"
#import "CommPLDetailViewController.h"
#import "CommDetailViewController.h"

@interface CommPingLunViewCell (){
    CommPingLunModel *selfModel;
}

@end


@implementation CommPingLunViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewBottom.layer.cornerRadius = 4;
    self.viewBottom.layer.masksToBounds = YES;
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h / 2;
    self.imgIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionComDetail:(id)sender {
    CommPLDetailViewController *plDetailVC = [[CommPLDetailViewController alloc]init];
    plDetailVC .communityid = selfModel._id;
    plDetailVC.notied = self.notId;
    [[self getCurrentVC].navigationController pushViewController:plDetailVC animated:YES];
}

-(void)refreshDataDetail:(CommcommentList *)model{
    
    self.contentDisLeft.constant = 65;
    self.contentDisRight.constant = 15;
    self.labName.font = [UIFont systemFontOfSize:13];
    self.labGood.hidden =YES;
    self.labPinglun.hidden = YES;
    self.viewContent.backgroundColor = self.viewBottom.backgroundColor;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.head]];
    self.labName.text = model.name;
    self.labContent.text = model.content;
    self.labTime.text = [model.time substringWithRange:NSMakeRange(5, 11)];
    self.viewBottom.hidden = YES;
    self.labPersonNum.text = @"";
    [self.btnComDetail setTitle:@"" forState:0];
}

-(void)refreshData:(CommPingLunModel *)model IsneedCommView:(BOOL) isNeed{
    selfModel = model;
    self.contentDisLeft.constant = 0;
    self.contentDisRight.constant = 0;
    self.labName.font = [UIFont systemFontOfSize:15];
    self.labGood.hidden =NO;
    self.labPinglun.hidden = NO;
    self.viewContent.backgroundColor = [UIColor whiteColor];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.head]];
    self.labName.text = model.name;
    self.labContent.text = model.content;
    self.labTime.text = [model.time substringWithRange:NSMakeRange(5, 11)];
    if (model.comments.count == 0 || isNeed == NO) {
        self.viewBottom.hidden = YES;
        self.labPersonNum.text = @"";
        [self.btnComDetail setTitle:@"" forState:0];
    }else{
        self.viewBottom.hidden = NO;
        self.labPersonNum.text = [NSString stringWithFormat:@"%@等人",[model.comments firstObject].name];
        [self.btnComDetail setTitle:[NSString stringWithFormat:@"共%ld回复 >",model.comments.count] forState:0];
    }
}
- (IBAction)actionSubmitComm:(id)sender {
    [self.delegate actionComment:selfModel];
}
- (IBAction)actionGood:(id)sender {
    [self.delegate communityViewCellGood:selfModel];
}

@end
