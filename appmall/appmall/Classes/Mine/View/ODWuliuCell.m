

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadLogData:(OrderDetailModel *)model{
    self.imgLine.hidden = YES;
    self.labBottomLine.hidden = YES;
    self.labBottomTitle.textColor = [UIColor redColor];
    if (model.logistics == nil) {
        self.labBottomTitle.text = @"";
        self.labTopTitle.text = @"";
    }else{
        self.labTopTitle.text = model.logistics.info;
        self.labBottomTitle.text = model.logistics.time;
    }
}
-(void)loadAddData:(OrderDetailModel *)model{
    self.imgLine.hidden = NO;
    self.labBottomLine.hidden = NO;
    self.labBottomTitle.textColor = [UIColor blackColor];
    self.labTopTitle.text = [NSString stringWithFormat:@"收货人：%@",model.phone];
    self.labBottomTitle.text = model.address;
}


@end
