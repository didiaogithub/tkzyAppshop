//
//  SCNoDataView.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/9.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCNoDataView.h"

@implementation SCNoDataView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor tt_grayBgColor];
    [self addSubview:self.imageV];
    [self addSubview:self.nodataLabel];
}

-(UILabel *)nodataLabel{
    if(_nodataLabel == nil) {
        _nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height*0.5, self.frame.size.width, 20)];
        _nodataLabel.text = @"暂无";
        _nodataLabel.textAlignment = NSTextAlignmentCenter;
        _nodataLabel.textColor = SubTitleColor;
        _nodataLabel.font = MAIN_TITLE_FONT;
    }
    return  _nodataLabel;
}

-(UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 -60, self.frame.size.height/2-110,120,100)];
//        _imageV.layer.cornerRadius = 30.0f;
        _imageV.layer.masksToBounds = YES;
        _imageV.image = [UIImage imageNamed:@"defaultnodata"];
    }
    return _imageV;
}

@end
