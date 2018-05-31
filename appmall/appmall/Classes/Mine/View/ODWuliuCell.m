

//
//  ODWuliuCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ODWuliuCell.h"

@implementation ODWuliuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadLogData:(OrderDetailModel *)model{
    [self.imgIcon setImage:[UIImage imageNamed: @"待收货.png"]];
    self.imgLine.hidden = YES;
    self.labBottomLine.hidden = YES;
    self.labTopTitle.textColor = [UIColor redColor];
    if (model.logistics == nil) {
        self.labBottomTitle.text = @"";
        self.labTopTitle.text = @"";
        self.imgIcon.hidden = YES;
    }else{
        self.labTopTitle.text = model.logistics.info;
        self.labBottomTitle.text = model.logistics.time;
        self.imgIcon.hidden = NO;
    }
}
-(void)loadAddData:(OrderDetailModel *)model{
    [self.imgIcon setImage:[UIImage imageNamed: @"定位.png"]];
    self.imgLine.hidden = NO;
    self.labBottomLine.hidden = NO;
    self.labTopTitle.textColor = [UIColor blackColor];
    self.labTopTitle.text = [NSString stringWithFormat:@"收货人：%@",model.phone];
    self.labBottomTitle.text =[NSString stringWithFormat:@"收货地址：%@", model.address];
}


@end
