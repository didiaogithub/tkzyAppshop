//
//  WuliuDetailViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WuliuDetailViewCell.h"

@implementation WuliuDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labMid.layer.borderColor = RGBCOLOR(180, 180, 180).CGColor;
    self.labMid.layer.borderWidth = 2;
    self.labMid.layer.cornerRadius = self.labMid.mj_h / 2;
    self.labMid.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)loadData:(NSString *)model atIndex:(NSInteger)index andInfoCount:(NSInteger)count{
    if (count == index + 1) {
        self.labBottom.hidden = YES;
        self.labTop.hidden = NO;
        self.labContent.textColor = [UIColor lightGrayColor];
        self.labMid.layer.borderColor = RGBCOLOR(180, 180, 180).CGColor;
        
    }else if (index == 0) {
        self.labContent.textColor = [UIColor redColor];
        self.labMid.layer.borderColor = [UIColor redColor].CGColor;
        self.labTop.hidden = YES;
        self.labBottom.hidden = NO;
        
    }else{
        self.labTop.hidden = NO;
        self.labBottom.hidden = NO;
        self.labContent.textColor = [UIColor lightGrayColor];
    }
    model = [model stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    self.labContent.text = model;
}

@end
