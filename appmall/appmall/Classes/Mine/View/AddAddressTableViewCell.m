//
//  AddAddressTableViewCell.m
//  CKYSPlatform
//
//  Created by 二壮 on 17/2/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AddAddressTableViewCell.h"

@implementation AddAddressTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{

    //没有默认地址的时候 点击添加地址
    _selectedAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedAddressButton];
    _selectedAddressButton.backgroundColor = [UIColor whiteColor];
    
    [_selectedAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(66*SCREEN_HEIGHT_SCALE);
    }];
    _selectedAddressButton.tag = 13;
    [_selectedAddressButton setTitle:@"点击添加收货地址" forState:UIControlStateNormal];
    [_selectedAddressButton setTitleColor:TitleColor  forState:UIControlStateNormal];
    
    
    _rightImageView = [[UIImageView alloc] init];
    [_selectedAddressButton addSubview:_rightImageView];
    [_rightImageView setImage:[UIImage imageNamed:@"确认订单箭头"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(13, 15));
    }];
    
    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_selectedAddressButton addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"orderdetailline.png"]];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(3);
    }];

    
    
    
    [_selectedAddressButton addTarget:self action:@selector(clickGetMyDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickGetMyDefaultAddress:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToAddressVC)]){
        [self.delegate clickToAddressVC];
    }
}



@end
