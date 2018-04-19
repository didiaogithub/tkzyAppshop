//
//  SCLoginViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/11.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCLoginViewController.h"

@interface SCLoginViewController ()

@property (nonatomic, strong) UIButton *wxLoginBtn;
@property (nonatomic, strong) UIButton *phoneLoginBtn;
@property (nonatomic, strong) CKC_CustomProgressView *loadingView;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) UIImageView *welcomeImg;

@end

@implementation SCLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CKCNotificationCenter addObserver:self selector:@selector(loginByWeChat) name:@"YDSC_WxLogin_Click" object:nil];
    
    self.loadingView = [[CKC_CustomProgressView alloc] init];
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);
    
    _welcomeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _welcomeImg.image = [UIImage imageNamed:@"loginImage"];
    [_welcomeImg setUserInteractionEnabled:YES];
    [self.view addSubview:_welcomeImg];
    
    [self creatTwoLoginBtn];
    
    NSString *requesturl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,GetLoginType];
    [HttpTool getWithUrl:requesturl params:nil success:^(id json) {
        
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([code integerValue] == 200) {
            NSString *appmalllogintype = [NSString stringWithFormat:@"%@", dict[@"appmalllogintype"]];
            if ([appmalllogintype isEqualToString:@"1"]) {//验证码
                _wxLoginBtn.hidden = YES;
                _phoneLoginBtn.hidden = NO;
            }else if ([appmalllogintype isEqualToString:@"2"]) {//微信
                _wxLoginBtn.hidden = NO;
                _phoneLoginBtn.hidden = YES;
            }else {//两种都要
                _wxLoginBtn.hidden = NO;
                _phoneLoginBtn.hidden = NO;
            }
        }else{//两种都要
            _wxLoginBtn.hidden = NO;
            _phoneLoginBtn.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        //两种都要
        _wxLoginBtn.hidden = NO;
        _phoneLoginBtn.hidden = NO;
    }];
}

-(void)creatTwoLoginBtn {
    _wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxLoginBtn.backgroundColor = [UIColor tt_redMoneyColor];
    _wxLoginBtn.hidden = YES;
    _wxLoginBtn.layer.cornerRadius = 3.0f;
    _wxLoginBtn.layer.masksToBounds = YES;
    
    [_wxLoginBtn setImage:[UIImage imageNamed:@"wxLoginBtn"] forState:UIControlStateNormal];
    [_wxLoginBtn setImage:[UIImage imageNamed:@"wxLoginBtn"] forState:UIControlStateSelected];
    [_welcomeImg addSubview:_wxLoginBtn];
    _wxLoginBtn.frame = CGRectMake(20,SCREEN_HEIGHT * 0.5, SCREEN_WIDTH - 40, 44);
    [_wxLoginBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    _phoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneLoginBtn.backgroundColor = [UIColor clearColor];
    _phoneLoginBtn.hidden = YES;
    _phoneLoginBtn.layer.borderWidth = 1.0f;
    _phoneLoginBtn.layer.borderColor = [UIColor colorWithHexString:@"c9c9c9"].CGColor;
    _phoneLoginBtn.layer.cornerRadius = 3.0f;
    _phoneLoginBtn.layer.masksToBounds = YES;
    [_phoneLoginBtn setTitle:@"手机登录" forState:UIControlStateNormal];
    [_phoneLoginBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_welcomeImg addSubview:_phoneLoginBtn];
    _phoneLoginBtn.frame = CGRectMake(20,SCREEN_HEIGHT * 0.5 + 60, SCREEN_WIDTH - 40, 44);
    [_phoneLoginBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)phoneLogin {
    
    [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
    [KUserdefaults setObject:@"clickPhoneBtn" forKey:@"YDSC_PhoneLogin_Click"];
    
}

-(void)weixinLogin {
    [KUserdefaults setObject:@"" forKey:@"YDSC_PhoneLogin_Click"];
    [KUserdefaults setObject:@"clickWechatBtn" forKey:@"YDSC_WxLogin_Click"];
    
    [self toWeiXinAuth];
}

-(void)toWeiXinAuth{

}

-(void)shownotice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)loginByWeChat {
    
}

-(void)goFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    [app.window makeKeyAndVisible];
}

-(void)showNoticeView:(NSString*)title{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
