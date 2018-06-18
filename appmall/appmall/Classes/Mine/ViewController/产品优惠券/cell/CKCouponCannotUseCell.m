//
//  CKCouponCannotUseCell.m
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKCouponCannotUseCell.h"

@interface CKCouponCannotUseCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *validDate;
@property (nonatomic, strong) UILabel *sendReasonL;
/**  立即使用*/
@property (nonatomic, strong) UIButton *usecouponBtn;
@property (nonatomic, strong) CKCouponModel *couponM;
@end
@implementation CKCouponCannotUseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image = [UIImage imageNamed:@"优惠券bg1"];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    self.moneyLable = [[UILabel alloc]init];
    self.moneyLable.text = @"¥0.00";
    self.moneyLable.backgroundColor = [UIColor clearColor];
    self.moneyLable.textColor = [UIColor blackColor];
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
    self.moneyLable.font = [UIFont systemFontOfSize:28];
    [self.contentView addSubview:self.moneyLable];
    [self.moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(AdaptedWidth(120));
    }];
    
    self.nameLable = [UILabel new];
    self.nameLable.text = @"产品券";
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor tt_monthLittleBlackColor];
    self.nameLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.moneyLable.mas_bottom);
    }];
    
    
//    self.typeLabel = [UILabel new];
//    self.typeLabel.text = @"产品进货抵用券";
//    self.typeLabel.textColor = [UIColor tt_monthLittleBlackColor];
//    self.typeLabel.font = [UIFont systemFontOfSize:15];
//    [self.contentView addSubview:self.typeLabel];
//    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.height.mas_equalTo(30);
//        make.bottom.mas_equalTo(self.moneyLable.mas_bottom);
//    }];
    
    self.validDate = [UILabel new];
    self.validDate.text = @"2017.03.01 00:00-2017.04.25 00:00";
    self.validDate.textColor = [UIColor tt_monthLittleBlackColor];
    self.validDate.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.validDate];
    [self.validDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(30);
        make.height.mas_equalTo(30);
        make.bottom.mas_offset(-10);
    }];
    
    
    self.usecouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.usecouponBtn setTitle:@"立即使用" forState:0];
    [self.usecouponBtn setTitleColor:[UIColor tt_redMoneyColor] forState:0];
    self.usecouponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.usecouponBtn.layer.masksToBounds = YES;
    self.usecouponBtn.layer.cornerRadius = 3;
    self.usecouponBtn.layer.borderColor = [UIColor tt_redMoneyColor].CGColor;
    self.usecouponBtn.layer.borderWidth = 1;
    [self.usecouponBtn addTarget:self action:@selector(actionUsecouponBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.usecouponBtn];
    [self.usecouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLable.mas_top);
        make.right.mas_offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    
    
    
}

- (void)actionUsecouponBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpShoppingList)]) {
        [self.delegate jumpShoppingList];
    }
}

- (void)refreshCouponWithCouponModel:(CKCouponModel *)couponM{
    
    
//    NSString *imgurl = [NSString stringWithFormat:@"%@", couponM.imgurl];
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"couponDefaultBg"]];
    NSString *money = [NSString stringWithFormat:@"%@", couponM.money];
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    if ([money doubleValue] >= 1000.0) {
        self.moneyLable.font = [UIFont systemFontOfSize:20];
    }
    self.moneyLable.text = [NSString stringWithFormat:@"¥%.2f", [money doubleValue]];
    
    NSString *userange = [NSString stringWithFormat:@"%@", couponM.userange];
    if (IsNilOrNull(userange)) {
        userange = @"";
    }
    self.typeLabel.text = userange;
    
    NSString *name = [NSString stringWithFormat:@"%@", couponM.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    self.nameLable.text = name;
    
    NSString *time = [NSString stringWithFormat:@"%@", couponM.time];
    if (IsNilOrNull(time)) {
        time = @"0000.00.00-0000.00.00";
    }
    self.validDate.text = time;
    
    NSString *sendreason = [NSString stringWithFormat:@"%@", couponM.scope];
    if (IsNilOrNull(sendreason)) {
        sendreason = @"";
    }
    self.sendReasonL.text = [NSString stringWithFormat:@"发放原因:%@", sendreason];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
