//
//  LeftLabelRightLabelView.m
//  Employee
//
//  Created by ForgetFairy on 2018/4/23.
//  Copyright © 2018年 忘仙. All rights reserved.
//

#import "LeftLabelRightLabelView.h"

@implementation LeftLabelRightLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    _leftLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [self addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_offset(100);
    }];
    
    
    _rightLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:13]];
    [self addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-10);
        make.left.equalTo(_leftLabel.mas_right);
    }];
    
}

@end
