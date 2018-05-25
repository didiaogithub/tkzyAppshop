//
//  LeftLabelRightTextFieldView.m
//  Employee
//
//  Created by ForgetFairy on 2018/4/22.
//  Copyright © 2018年 忘仙. All rights reserved.
//

#import "LeftLabelRightTextFieldView.h"

@implementation LeftLabelRightTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    
    _leftLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [self addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_offset(120);
    }];
    
    _rightTextField = [[UITextField alloc] init];
    _rightTextField.textAlignment = NSTextAlignmentRight;
    _rightTextField.textColor = TitleColor;
    _rightTextField.font = MAIN_TITLE_FONT;
    [_rightTextField setValue:SubTitleColor forKeyPath:@"_placeholderLabel.textColor"];
    [_rightTextField setValue:MAIN_TITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    
    [self addSubview:_rightTextField];
    [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_leftLabel.mas_right).offset(3);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(0);
    }];
    
    _rightLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:13]];
    [self addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightTextField.mas_top);
        make.left.equalTo(_rightTextField.mas_left);
        make.width.and.height.mas_equalTo(_rightTextField);
    }];
    
}

@end
