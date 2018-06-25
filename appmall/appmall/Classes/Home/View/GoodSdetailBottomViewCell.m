

//
//  GoodSdetailBottomViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodSdetailBottomViewCell.h"

@implementation GoodSdetailBottomViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.webContent.scrollView.bounces = NO;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)loadDataWithModel:(GoodDetailModel *)model{
    _selfModel = model;
    [self.webContent loadHTMLString:model.goodsdetail baseURL:nil];
}
- (IBAction)actionOrderDetail:(UIButton *)sender {
    [self setBtnState:sender];
    [self.webContent loadHTMLString:_selfModel.goodsdetail baseURL:nil];
}

- (IBAction)actionGoodInfo:( UIButton *)sender {
    [self setBtnState:sender];
    [self.webContent loadHTMLString:_selfModel.property baseURL:nil];
}

-(void)setBtnState:(UIButton *)itemBtn{
    self.btnGoodInfo.selected = NO;
    self.bottomLineDisLeft.constant = itemBtn.mj_x;
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.btnGoodDetail.selected = NO;
    itemBtn.selected = YES;
}
@end
