//
//  SCLoginViewController.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/10/11.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCLoginViewController.h"

#define KCheckSec 60

@interface SCLoginViewController ()
{
    NSTimer *timer;
    NSInteger checkSec;
}

@property (nonatomic, strong) UIButton *wxLoginBtn;
@property (nonatomic, strong) UIButton *btnSendCheckCode;
@property (nonatomic, strong) UIButton *wxRegister;
@property (nonatomic, strong) UIButton *phoneLoginBtn;
@property (nonatomic, strong) CKC_CustomProgressView *loadingView;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) UIImageView *welcomeImg;
@property (nonatomic, strong) UIImageView *loginIcon;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) UITextField *tfCheckCode;

@end

@implementation SCLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CKCNotificationCenter addObserver:self selector:@selector(loginByWeChat) name:@"YDSC_WxLogin_Click" object:nil];
    checkSec = KCheckSec;
    self.loadingView = [[CKC_CustomProgressView alloc] init];
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);
    
    _welcomeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _welcomeImg.image = [UIImage imageNamed:@"bg"];
    [_welcomeImg setUserInteractionEnabled:YES];
    [self.view addSubview:_welcomeImg];
    
    _loginIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 123, 56  , 56)];
    _loginIcon.center = CGPointMake(SCREEN_WIDTH/ 2, _loginIcon.centerY);
//    _loginIcon.image = [UIImage imageNamed:@"bg"];
    _loginIcon.backgroundColor = [UIColor redColor];
    [_loginIcon setUserInteractionEnabled:YES];
    [self.view addSubview:_loginIcon];
    
    [self creatTwoLoginBtn];
    _wxLoginBtn.hidden = NO;
    _phoneLoginBtn.hidden = NO;


}

-(UITextField *)createTfText:(NSString *)title andFrame:(CGRect) frame{
    UITextField *  textF = [[UITextField   alloc]initWithFrame:frame];
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:title attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [textF setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    textF.attributedPlaceholder = firstPart;
    textF.tintColor = [UIColor whiteColor];
    textF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.layer.cornerRadius = textF.mj_h /  2;
    textF.backgroundColor = RGBCOLOR(194,180,177);
    textF.layer.borderColor   = RGBCOLOR(255, 255, 255).CGColor;
    textF.layer.borderWidth  =1;
    textF.layer.masksToBounds = YES;
    [self.view addSubview:textF];
    return textF;
}

-(void)creatTwoLoginBtn {
    _btnSendCheckCode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnSendCheckCode setTitle:@"获取验证码" forState:0];
    _btnSendCheckCode.backgroundColor = [UIColor clearColor];
    
    _btnSendCheckCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnSendCheckCode addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    _tfPhone =   [self createTfText:@"手机号码" andFrame:CGRectMake(30, 265, SCREEN_WIDTH - 60, 57)];
    _tfCheckCode =  [self createTfText:@"验证码" andFrame:CGRectMake(30, 335, SCREEN_WIDTH - 60, 57)];
    _btnSendCheckCode.frame = CGRectMake(0, 0, 100, 33);

    [_tfCheckCode setRightView:_btnSendCheckCode];
    _tfCheckCode.rightViewMode = UITextFieldViewModeAlways;
    
   
    
    _phoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneLoginBtn.hidden = YES;
    _phoneLoginBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
  
    _phoneLoginBtn.layer.masksToBounds = YES;
    [_phoneLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_phoneLoginBtn setBackgroundColor:[UIColor colorWithHexString:@"ee3837"]];
    [_welcomeImg addSubview:_phoneLoginBtn];
    _phoneLoginBtn.frame =CGRectMake(30, 408, SCREEN_WIDTH - 60, 57);
      _phoneLoginBtn.layer.cornerRadius = _phoneLoginBtn.mj_h / 2;
    [_phoneLoginBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxLoginBtn.backgroundColor = [UIColor clearColor];
    [_wxLoginBtn setTitle:@"微信登录" forState:0];
    [_welcomeImg addSubview:_wxLoginBtn];
    _wxLoginBtn.titleLabel .font = [UIFont systemFontOfSize:14];
    _wxLoginBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 100,470,80, 40);
    [_wxLoginBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 480, 1, 20)];
    lab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: lab];
    
    _wxRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxRegister.backgroundColor = [UIColor clearColor];
    [_wxRegister setTitle:@"现在注册" forState:0];
    _wxRegister.titleLabel .font = [UIFont systemFontOfSize:14];
    [_welcomeImg addSubview:_wxRegister];
    _wxRegister.frame = CGRectMake(SCREEN_WIDTH / 2 + 20,470,80, 40);
    [_wxRegister addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)startTimer{
    [_btnSendCheckCode setEnabled:NO];
    [self getCheckCodeByPhone];
    [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
    
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (checkSec > 0) {
                checkSec --;
                [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
            }else{
                checkSec = KCheckSec;
                [timer invalidate];
                [_btnSendCheckCode setTitle:@"获取验证码" forState:0];
                [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
                [_btnSendCheckCode setEnabled: YES];
            }
        }];
    } else {
        
    }
    
}

-(void)getCheckCodeByPhone{
    NSDictionary *pramaDic= @{@"apptype":Apptype,@"devtype":Devtype,@"telNo":_tfPhone.text};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",CommentResAPI,Get_Validate_Code];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        [self.loadingView showNoticeView:dic[@"message"]];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)phoneLogin {
    
    if(_tfPhone.text .length == 0){
        [self showNoticeView:@"请输入手机号"];
        return;
    }
    if(_tfCheckCode.text.length == 0){
        [self showNoticeView:@"请输入验证码"];
        return;
    }
//    [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
//    [KUserdefaults setObject:@"clickPhoneBtn" forKey:@"YDSC_PhoneLogin_Click"];
    NSDictionary *pramaDic= @{@"mobile":_tfPhone.text,@"validatecode":_tfCheckCode.text};
        //请求数据
        NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Login_By_Phone];
        
        
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
        
        [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
            [self.loadingView stopAnimation];

            NSDictionary *dic = json;
            if ([dic[@"code"] integerValue] != 200) {
                [self.loadingView showNoticeView:dic[@"message"]];
                return;
            }
            
            NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
            if (!IsNilOrNull(meid)) {
                
                NSSet *setTags = [NSSet setWithObject:@"appmall"];
                //            [JPUSHService setTags:setTags alias:[NSString stringWithFormat:@"m%@", meid] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                //                NSLog(@"\n[用户登录成功后设置别名]---[%@]",iAlias);
                //            }];
                
                //查看registId
                //            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                //                NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
                //            }];
            }
            
            if (dic != nil) {  //请求到数据
                UserModel *curModel = [[UserModel alloc]initWith:dic[@"data"]];
                curModel.isLogin = YES;
                curModel.userId = @"1";
                [curModel saveUserInfo];
                [self goFirstPage];
            }else{
                [self.loadingView showNoticeView:@"登录失败"];
            }
        } failure:^(NSError *error) {
            [self.loadingView stopAnimation];
            if (error.code == -1009) {
                [self.loadingView showNoticeView:NetWorkNotReachable];
            }else{
                [self.loadingView showNoticeView:NetWorkTimeout];
            }
            
        }];
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
