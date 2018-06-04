//
//  SCMineTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCMineTableViewCell.h"
#import "SCUserInfoModel.h"
#import "UIButton+XN.h"
@implementation SCMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

@end

@interface SCUserInfoCell()
/**头像背景*/
@property (nonatomic, strong) UIImageView *headBankImageView;
/**头像*/
@property (nonatomic, strong) UIImageView *headImgV;
/**昵称*/
@property (nonatomic, strong) UILabel *nameLable;
/**积分按钮*/
@property (nonatomic, strong) UIButton *integralButton;

/**认证label*/
@property (nonatomic, strong) UILabel *rzLabel;

/**编辑按钮*/
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) SCUserInfoModel *userInfoM;

/**签到按钮*/
@property (nonatomic, strong) UIButton *signUpButton;

/** 客服小姐姐*/
@property (nonatomic, strong) UIButton *kefuButton;

/** 设置*/
@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation SCUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    //背景图片
    _headBankImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headBankImageView];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"#9C1D1F"]];
    
    [_headBankImageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [_headBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    _headImgV = [UIImageView new];
    [self.contentView addSubview:_headImgV];
    _headImgV.layer.cornerRadius = 60/2;
    _headImgV.clipsToBounds = YES;
    _headImgV.userInteractionEnabled = YES;
    _headImgV.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImgV.layer.borderWidth = 1;
//    _headImgV.backgroundColor = [UIColor greenColor];
    NSString *headUrl = [KUserdefaults objectForKey:@"YDSC_USER_HEAD"];
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"名师推荐头像"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadButton)];
    [_headImgV addGestureRecognizer:tap];
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-30);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    //微信名字
    _nameLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.font = [UIFont boldSystemFontOfSize:17];
    _nameLable.text = @" ";
    _nameLable.textAlignment = NSTextAlignmentLeft;
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top).mas_offset(20);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.width.mas_offset(150);
    }];
    
//    _rzLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
//
//    [self.contentView addSubview:_rzLabel];
//    _rzLabel.font = [UIFont boldSystemFontOfSize:12];
//    _rzLabel.text = @"已实名认证";
//    _rzLabel.textAlignment = NSTextAlignmentLeft;
//    [_rzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_nameLable.mas_bottom).offset(5);
//        make.left.equalTo(_nameLable.mas_left);
//        make.width.mas_offset(150);
//    }];
    
    // 编辑
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editButton];
    _editButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _editButton.layer.cornerRadius = 30 * 0.5;
        _editButton.layer.masksToBounds = YES;
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(105);
            make.right.mas_offset(-10);
            make.size.mas_offset(CGSizeMake(70, 30));
        }];
        [_editButton addTarget:self action:@selector(clickEditButton) forControlEvents:UIControlEventTouchUpInside];
    
    // 客服小姐姐
    _kefuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_kefuButton];
    [_kefuButton setImage:[UIImage imageNamed:@"客服小姐姐"] forState:UIControlStateNormal];
    [_kefuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_kefuButton addTarget:self action:@selector(clickkefuButton) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_settingButton];
    [_settingButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.right.equalTo(_kefuButton.mas_left).offset(-10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_settingButton addTarget:self action:@selector(clickSetUpButton) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)fillData:(id)data {
    self.userInfoM = data;
    
    NSString *headPath = [NSString stringWithFormat:@"%@", self.userInfoM.head];
    if ([headPath hasPrefix:@"http"]) {
        [_headImgV sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"name"]];
    }
    
    NSString *smallname = [NSString stringWithFormat:@"%@", self.userInfoM.nickname];
    if (IsNilOrNull(smallname)) {
        smallname = @"";
    }
    _nameLable.text = smallname;

}

-(void)clickHeadButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterToDetailUserInfo)]) {
        [self.delegate enterToDetailUserInfo];
    }
}

-(void)clickEditButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterToDetailUserInfo)]) {
        [self.delegate enterToDetailUserInfo];
    }
}

-(void)clickSetUpButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setup)]) {
        [self.delegate setup];
    }
}

-(void)clickkefuButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(kefuxiaojiejie)]) {
        [self.delegate kefuxiaojiejie];
    }
}
@end


@interface SCMineOrderCell ()
/**我的订单*/
@property (nonatomic, strong) UILabel *orderLable;
/**查看全部订单*/
@property (nonatomic, strong) UILabel *checkAllMyOrderLable;
/**右箭头*/
@property (nonatomic, strong) UIImageView *rightImageView;
/**线*/
@property (nonatomic, strong) UILabel *lineLable;
/**订单相关image*/
@property (nonatomic, strong) UIImageView *statusImageView;
/**订单状态*/
@property (nonatomic, strong) UIButton *statusButton;
/**全部订单按钮*/
@property (nonatomic, strong) UIButton *allOrderButton;

@end

@implementation  SCMineOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
   
    //我的订单  lable
    _orderLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_orderLable];
    _orderLable.text = @"我的订单";
    [_orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(15);
    }];
    //右箭头
    _rightImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView setImage:[UIImage imageNamed:@"rightgray"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderLable.mas_top);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(10, 15));
    }];
    
    //查看全部订单
    _checkAllMyOrderLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_checkAllMyOrderLable];
    _checkAllMyOrderLable.text = @"查看全部>";
    [_checkAllMyOrderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImageView.mas_centerY);
        make.right.equalTo(_rightImageView.mas_left).offset(-3);
    }];
    
    //我的全部订单按钮
    _allOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_allOrderButton];
    _allOrderButton.tag = 24;
    _allOrderButton.backgroundColor = [UIColor clearColor];
    
    [_allOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    [_allOrderButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //线
    _lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:_lineLable];
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(_orderLable.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    
    
    NSArray *imageArr = @[@"待付款", @"待发货", @"待收货", @"使用反馈"];
    NSArray *titleArr = @[@"待付款", @"待发货", @"待收货", @"使用反馈"];
    float spaceW = (SCREEN_WIDTH - 10)/4; //宽
    
    for (int i = 0; i<4; i++) {
        
        UIImage *stutsImage = [UIImage imageNamed:imageArr[i]];
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [self.contentView addSubview:_statusButton];
        
        [_statusButton setImage:stutsImage forState:UIControlStateNormal];
        [_statusButton setTitle:titleArr[i] forState:UIControlStateNormal];
        [_statusButton setTitleColor:TitleColor forState:UIControlStateNormal];
        _statusButton.titleLabel.font = MAIN_TITLE_FONT;
        [_statusButton setBackgroundColor:[UIColor clearColor]];
        [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineLable.mas_bottom);
            make.left.mas_offset(spaceW*i);
            make.height.mas_offset(70);
            make.width.mas_offset(spaceW);
        }];
        [_statusButton layoutButtonWithEdgeInsetsStyle:XNButtonEdgeInsetsStyleTop imageTitleSpace:10];
        _statusButton.tag = 20+i;
        [_statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
#pragma mark-点击订单状态button
-(void)clickStatusButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterOrderListWithType:)]) {
        [self.delegate enterOrderListWithType:button.tag];
    }
}

@end


@interface SCMineFunctionCell()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *minefunctionLable;

@end

@implementation SCMineFunctionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    _leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(25, 20));
    }];
    _minefunctionLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_minefunctionLable];
    
    
    [_minefunctionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(15);
        make.centerY.equalTo(_leftImageView.mas_centerY);
    }];
    UILabel *lineLabale = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabale];
    [lineLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_minefunctionLable.mas_bottom);
        make.left.mas_offset(15);
        make.bottom.mas_offset(0);
    }];
}

-(void)fillData:(id)data {
    NSDictionary *dict = data;
    
    _leftImageView.image = [UIImage imageNamed:dict[@"image"]];
    _minefunctionLable.text = dict[@"title"];
}

@end
