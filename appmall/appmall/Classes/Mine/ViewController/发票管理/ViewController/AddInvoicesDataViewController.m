//
//  AddInvoicesDataViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AddInvoicesDataViewController.h"
#import "LeftLabelRightTextFieldView.h"
#import "QRadioButton.h"
@interface AddInvoicesDataViewController ()<QRadioButtonDelegate>
{
    UILabel *line2;
    UILabel *line3;
}
/**  抬头类型*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *ttlxView;
/**  发票抬头*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *fpttView;
/**  税号*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *shView;
/**  发票证明材料*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *fpzmclView;

/**  type*/
@property (nonatomic, strong) NSString *type;
@property (weak, nonatomic) IBOutlet UIView *contView;

/**  拍照*/
@property (nonatomic, strong) UIButton *pzBtn;

@property (weak, nonatomic) IBOutlet UIButton *tjBtn;

- (IBAction)tjBtnAction:(UIButton *)sender;

@end

@implementation AddInvoicesDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加发票信息";
    
    [self initCompontments];
}

- (void)initCompontments{
    self.tjBtn.layer.masksToBounds = YES;
    self.tjBtn.layer.cornerRadius = 5;
    // 抬头类型
    self.ttlxView = [[LeftLabelRightTextFieldView alloc] init];
    self.ttlxView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.ttlxView];
    self.ttlxView.rightLabel.hidden = YES;
    self.ttlxView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*抬头类型"];
    self.ttlxView.rightTextField.hidden = YES;
    
    
    QRadioButton *sex_women = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    [sex_women setTitle:@"个人/非企业单位" forState:UIControlStateNormal];
    [sex_women setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sex_women.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.ttlxView addSubview:sex_women];
    
    [sex_women mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ttlxView.mas_right).offset(-20);
        make.centerY.equalTo(self.ttlxView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(140);
    }];
    QRadioButton *sex_men = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    [sex_men setTitle:@"企业单位" forState:UIControlStateNormal];
    [sex_men setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sex_men.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.ttlxView addSubview:sex_men];
    [sex_men setChecked:YES];
    [sex_men mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sex_women.mas_left).offset(-20);
        make.centerY.equalTo(self.ttlxView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.ttlxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(0);
        make.height.mas_offset(44);
    }];
    UILabel *line = [UILabel creatLineLable];
    [self.contView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.equalTo(self.ttlxView.mas_bottom);
    }];
    
    
    
    // 发票抬头
    self.fpttView = [[LeftLabelRightTextFieldView alloc] init];
    self.fpttView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.fpttView];
    self.fpttView.rightLabel.hidden = YES;
    self.fpttView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*发票抬头"];
    self.fpttView.rightTextField.placeholder = @"请输入发票抬头";
    [self.fpttView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line.mas_bottom);
        make.height.mas_offset(44);
    }];
    UILabel *line1 = [UILabel creatLineLable];
    [self.contView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.fpttView.mas_bottom);
    }];

    // 税号
    self.shView = [[LeftLabelRightTextFieldView alloc] init];
    self.shView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.shView];
    self.shView.rightLabel.hidden = YES;
    self.shView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*税号"];
    self.shView.rightTextField.placeholder = @"请输入税号";
    [self.shView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line1.mas_bottom);
        make.height.mas_offset(44);
    }];
    line2 = [UILabel creatLineLable];
    [self.contView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.shView.mas_bottom);
    }];

    // 发票证明材料
    self.fpzmclView = [[LeftLabelRightTextFieldView alloc] init];
    self.fpzmclView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.fpzmclView];
    self.fpzmclView.rightLabel.hidden = YES;
    self.fpzmclView.leftLabel.attributedText = [NSString attributedStarWthStr:@"  发票证明材料"];
    self.fpzmclView.rightTextField.hidden = YES;
    
    // 拍照按钮
    self.pzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fpzmclView addSubview:self.pzBtn];
    [self.pzBtn addTarget:self action:@selector(pzAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line2.mas_bottom);
         make.height.mas_offset(44);
    }];
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"查看详情"];
    [self.fpzmclView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.top.equalTo(line2.mas_bottom).offset(17.5);
        make.height.mas_offset(10);
        make.width.mas_offset(10);
    }];
    
    [self.fpzmclView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line2.mas_bottom);
        make.height.mas_offset(44);
    }];
    line3 = [UILabel creatLineLable];
    [self.contView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.fpzmclView.mas_bottom);
    }];
    
    
}


- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    
    if ([radio.titleLabel.text isEqualToString:@"个人/非企业单位"]) { // 个人/非企业单位
        self.shView.hidden = YES;
        self.fpzmclView.hidden = YES;
        line2.hidden = YES;
        line3.hidden = YES;
        self.type = @"1";
    }else{// 企业单位
        self.type = @"2";
        self.shView.hidden = NO;
        self.fpzmclView.hidden = NO;
        line2.hidden = NO;
        line3.hidden = NO;
    }
}


- (void)pzAction{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)tjBtnAction:(UIButton *)sender {
    
    
    
    
}
@end
