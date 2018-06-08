//
//  ODGoodsTableViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ODGoodsTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "SCCommentOrderViewController.h"
@implementation ODGoodsTableViewCell{
    GoodSmodel *selfmodel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBtn:self.btnRebuy isRed:NO];
    [self setBtn:self.btnBack    isRed:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellBtnState:(NSInteger) state{
    if (state  == 3 || state == 6) {
        self.btnBack.hidden = NO;
        self.btnRebuy.hidden = NO;
        if ([selfmodel.feedback boolValue] == YES) {
            self.btnBack.hidden = YES;
            self.rebuyDisRight.constant = 15;
        }else{
            self.btnBack.hidden = NO;
        }
    }else{
        self.btnBack.hidden = YES;
        self.btnRebuy.hidden = YES;
    }
}

-(void)setBtn:(UIButton *)sender isRed:(BOOL)isRed{
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
    if (!isRed) {
        sender.layer.borderColor = RGBCOLOR(170, 170, 170).CGColor;
        sender.layer.borderWidth = 1;
    }else{
        sender.layer.borderColor = [UIColor redColor].CGColor;
        sender.layer.borderWidth = 1;
    }
}

-(void)loadData:(GoodSmodel *)model{
    selfmodel = model;
    self.labGoodName.text = model.name;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.labGoodInfo.text = [NSString stringWithFormat:@"编号：%@    规格：%@",model.itemno,model.specification];
    self.labPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
    self.labNum.text = [NSString stringWithFormat:@"X%@",model.number];
}
- (IBAction)actionRebuy:(UIButton *)sender {
    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc] init];
    detailVc.goodsId = selfmodel.itemid;
    [[self getCurrentVC].navigationController pushViewController:detailVc animated:YES];
}
- (IBAction)actionBack:(id)sender {
    SCCommentOrderViewController *releaseComment = [[SCCommentOrderViewController alloc] init];
    releaseComment.orderid = self.orderid;
//    SCOrderDetailGoodsModel *commentM = temp.firstObject;
    SCOrderDetailGoodsModel *commentM = [[SCOrderDetailGoodsModel alloc] init];
    commentM.path = [NSString stringWithFormat:@"%@", selfmodel.picture];
    commentM.spec = [NSString stringWithFormat:@"%@", selfmodel.specification];
    commentM.count = [NSString stringWithFormat:@"%@", selfmodel.number];
    commentM.name = [NSString stringWithFormat:@"%@", selfmodel.name];
    commentM.itemid = [NSString stringWithFormat:@"%@", selfmodel.itemid];
    commentM.price = [NSString stringWithFormat:@"%@", selfmodel.price];
    releaseComment.goodsM = commentM;
    [[self getCurrentVC].navigationController pushViewController:releaseComment animated:YES];
}

@end
