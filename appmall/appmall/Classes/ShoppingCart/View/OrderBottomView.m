//
//  OrderBottomView.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/8/10.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "OrderBottomView.h"

@interface OrderBottomView()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation OrderBottomView

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type{
    self = [super initWithFrame:frame];
    if(self){
        [self createUIWithType:type];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    float buttonW= 0;
    if (iphone5) {
        buttonW = 100;
    }else{
        buttonW = 120;
    }
    
    UILabel *line = [UILabel creatLineLable];
    [_bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_allSelectedButton];
    _allSelectedButton.tag = 788;
    UIImage *nomalImage = [UIImage imageNamed:@"selectedgray"];
    UIImage * selectedImage = [UIImage imageNamed:@"selectedred"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.bottom.equalTo(_bgView.mas_bottom).offset(-10);

    }];
    
    [_allSelectedButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#999999"] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [_bgView addSubview:self.textLable];
    self.textLable.text = @"全选(0)";
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSelectedButton.mas_top);
        make.left.equalTo(_allSelectedButton.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(45, 30));
    }];
    

    //总计
    
    _LabTotal = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#999999"] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [_bgView addSubview:_LabTotal];
    _LabTotal.text = @"共计:";
    [_LabTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLable.mas_top);
        make.height.mas_offset(30);
        make.left.equalTo(self.textLable.mas_right);
        make.width.mas_offset(40);
    }];
    _realPayMoneyLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#F23030"] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:_realPayMoneyLable];
    _realPayMoneyLable.text = @"¥0.00";
    [_realPayMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_LabTotal.mas_centerY);
        make.height.mas_offset(30);
        make.left.equalTo(_LabTotal.mas_right);
        make.width.mas_offset(SCREEN_WIDTH - 90-buttonW);
    }];

      //立即购买
    _nowGoToBuyButton = [UIButton configureButtonWithTitle:@"" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_nowGoToBuyButton];
    _nowGoToBuyButton.tag = 789;
 
    [_nowGoToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top);
        make.right.equalTo(_bgView.mas_right);
        make.bottom.equalTo(_bgView.mas_bottom);
        make.width.mas_offset(buttonW);
    }];
    
    
    _deleteButton = [UIButton configureButtonWithTitle:@"删除" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_deleteButton];
    _deleteButton.tag = 790;
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_nowGoToBuyButton);
        make.width.mas_offset(140);
    }];
    _deleteButton.hidden = YES;
    
    _collectedButton = [UIButton configureButtonWithTitle:@"移到收藏夹" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor lightGrayColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_collectedButton];
    _collectedButton.tag = 791;
    [_collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_deleteButton);
        make.right.equalTo(_deleteButton.mas_left);
    }];
    _collectedButton.hidden = YES;


    
    if ([type isEqualToString:@"no"]){
        [_nowGoToBuyButton setTitle:@"确认" forState:UIControlStateNormal];
        _realPayMoneyLable.hidden = YES;
        _textLable.hidden = YES;
    }else{
        [_nowGoToBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _realPayMoneyLable.hidden = NO;
        _textLable.hidden = NO;
    }
    

}
-(void)clickBottomButton:(UIButton *)button{
    
//    self.nowGoToBuyButton.enabled =NO;
//    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止重复点击
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(bottomViewButtonClicked:)]) {
        [self.delegate bottomViewButtonClicked:button];
    }
}

-(void)changeButtonStatus {
    self.nowGoToBuyButton.enabled =YES;
}

@end
