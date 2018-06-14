//
//  SCPhoneLoginViewController.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPhoneLoginViewController.h"
#import "STCountDownButton.h"
#import "WXApi.h"
#import "SCAdImageView.h"
#import "GoodModel.h"
#import "SCMyOrderModel.h"
#import "SCCategoryGoodsModel.h"
#import "common.h"
#define KCheckSec 60
@interface SCPhoneLoginViewController ()<UITextFieldDelegate>{

    NSTimer *timer;
    NSInteger checkSec;
       
}

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *idcodeTF;
@property (nonatomic, strong) UIButton *countDownCode;
@property(nonatomic,strong)UIImageView *welcomeImg;
@property (nonatomic, strong) UIImageView *loginIcon;
@property (nonatomic, copy) NSString *valitedStr;

@end

@implementation SCPhoneLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        self.navigationItem.title = @"绑定手机号";
    }else{
        self.navigationItem.title = @"登录";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _welcomeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _welcomeImg.image = [UIImage imageNamed:@"bg"];
    [_welcomeImg setUserInteractionEnabled:YES];
    [self.view addSubview:_welcomeImg];
    
    _loginIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 123, 110  , 100)];
    _loginIcon.center = CGPointMake(SCREEN_WIDTH/ 2, _loginIcon.centerY);
    _loginIcon.image = [UIImage imageNamed:@"logo-商城"];
    //    _loginIcon.backgroundColor = [UIColor redColor];
    [_loginIcon setUserInteractionEnabled:YES];
    [self.view addSubview:_loginIcon];
    [self initUI];
}

-(void)initUI {
    
    [CKCNotificationCenter addObserver:self selector:@selector(loginWithPhoneAndOpenid) name:WeiXinAuthSuccess object:nil];
    
    UILabel *title = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        title.text = @"";
    }else{
        title.text = @"验证手机号码登录";
    }
    title.frame = CGRectMake(0, 74+NaviAddHeight, SCREEN_WIDTH, 30);
    [self.view addSubview:title];
    
    _phoneTF =  [self createTfText:@"手机号码" andFrame:CGRectMake(30, 265, SCREEN_WIDTH - 60, 57)];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.delegate = self;
    [self.view addSubview:_phoneTF];
    
    
    _idcodeTF = [self createTfText:@"验证码" andFrame:CGRectMake(30, 335, SCREEN_WIDTH - 60, 57)];
    _idcodeTF.keyboardType = UIKeyboardTypePhonePad;
    _idcodeTF.delegate = self;
    [self.view addSubview:_idcodeTF];
    
    
    _countDownCode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_countDownCode setTitle:@"获取验证码" forState:0];
    _countDownCode.backgroundColor = [UIColor clearColor];
    
    _countDownCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [_countDownCode addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    _countDownCode.frame = CGRectMake(0, 0, 100, 33);
    
    [_idcodeTF setRightView:_countDownCode];
    _idcodeTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"ee3837"]];
    [_welcomeImg addSubview:loginBtn];
    loginBtn.frame =CGRectMake(30, 408, SCREEN_WIDTH - 60, 57);
    loginBtn.layer.cornerRadius = loginBtn.mj_h / 2;
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(30, 480, SCREEN_WIDTH - 60, 30);
    [login setTitle:@"已有账号，去登录" forState:0];
    login.titleLabel .font = [UIFont systemFontOfSize:15];
    [login addTarget:self  action:@selector(loginGo) forControlEvents:UIControlEventTouchUpInside];
    [self.welcomeImg addSubview:login];
    
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        [loginBtn setTitle:@"绑定手机号" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginWithPhoneAndOpenid) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];

}

#pragma mark - 获取验证码
-(void)getVertifyCodeWithButton{
    if (IsNilOrNull(_phoneTF.text)){
        [self showNoticeView:@"请输入手机号码"];
        return;
    }
    
    if ([_phoneTF.text hasPrefix:@"1"]) {
        //1开头的默认为大陆号码，增加验证
        if(![NSString isMobile:_phoneTF.text]){
            [self showNoticeView:@"请输入正确的手机号码"];
            return;
        }
    }
    
    
    NSDictionary *pramaDic= @{@"apptype":Apptype,@"devtype":Devtype,@"telNo":_phoneTF.text};
    //请求数据
        NSString *codeUrl = [NSString stringWithFormat:@"%@%@",CommentResAPI,Get_Validate_Code];
    [HttpTool postWithUrl:codeUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        _valitedStr = [NSString stringWithFormat:@"%@", dict[@"validStr"]];
        
        NSLog(@"验证码%@", _valitedStr);
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

/**点击登录按钮*/
//-(void)phoneLogin{
//
//    if (IsNilOrNull(_phoneTF.text)){
//        [self showNoticeView:@"请输入手机号码"];
//        return;
//    }
//
//    if ([_phoneTF.text hasPrefix:@"1"]) {
//        //1开头的默认为大陆号码，增加验证
//        if(![NSString isMobile:_phoneTF.text]){
//            [self showNoticeView:@"请输入正确的手机号码"];
//            return;
//        }
//    }
//
//
//    if (IsNilOrNull(_idcodeTF.text)){
//        [self showNoticeView:@"请输入验证码"];
//        return;
//    }
//
//    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PhoneLoginUrl];
//    NSDictionary *pramdDic = @{@"mobile":_phoneTF.text, @"code": _idcodeTF.text};
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
//    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
//        [self.loadingView stopAnimation];
//
//        NSDictionary *dict = json;
//
//        if ([dict[@"code"] integerValue] == 200) {
//
//            NSString *uk = [NSString stringWithFormat:@"%@",dict[@"uk"]];
//            if (!IsNilOrNull(uk)) {
//                [KUserdefaults setObject:uk forKey:@"YDSC_uk"];
//            }
//
//            NSString *appopenid = [NSString stringWithFormat:@"%@",dict[@"appopenid"]];
//
//            [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
//
//            [KUserdefaults removeObjectForKey:@"loginWithCheckPhone"];
//
//            //清除优惠券缓存
//            [KUserdefaults removeObjectForKey:@"CouponCacheDate"];
//            [[XNArchiverManager shareInstance] xnDeleteObject:KMyCouponList];
//
//            //删除订单购物车缓存
//            RLMResults *result = [GoodModel allObjects];
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            if (result.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result];
//                [realm commitWriteTransaction];
//            }
//            RLMResults *result1 = [SCMyOrderModel allObjects];
//            if (result1.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result1];
//                [realm commitWriteTransaction];
//            }
//            RLMResults *result2 = [SCMyOrderGoodsModel allObjects];
//            if (result2.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result2];
//                [realm commitWriteTransaction];
//            }
//
//            //            RLMResults *result3 = [SCCategoryGoodsModel allObjects];
//            //            if (result2.count > 0) {
//            //                [realm beginWriteTransaction];
//            //                [realm deleteObjects:result3];
//            //                [realm commitWriteTransaction];
//            //            }
//
//
//            if (!IsNilOrNull(_phoneTF.text)) {
//                [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
//            }
//
//            [KUserdefaults setObject:@"loginWithPhoneAndWxSucc" forKey:KloginStatus];
//            [KUserdefaults synchronize];
//            [self goFirstPage];
//
//        }else if([dict[@"code"] integerValue] == 300) {
//            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
//            if ([type isEqualToString:@"wx"]) {
//
//                if (!IsNilOrNull(_phoneTF.text)) {
//                    [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
//                }
//                //微信授权
//                [self toWeiXinAuth];
//            }
//        }else{
//            [self showNoticeView:dict[@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [self.loadingView stopAnimation];
//        if (error.code == -1009) {
//            [self showNoticeView:NetWorkNotReachable];
//        }else{
//            [self showNoticeView:NetWorkTimeout];
//        }
//    }];
//}

-(void)phoneLogin {
    if (IsNilOrNull(_phoneTF.text)){
        [self showNoticeView:@"请输入手机号码"];
        return;
    }
    
    if ([_phoneTF.text hasPrefix:@"1"]) {
        //1开头的默认为大陆号码，增加验证
        if(![NSString isMobile:_phoneTF.text]){
            [self showNoticeView:@"请输入正确的手机号码"];
            return;
        }
    }
    
    if (IsNilOrNull(_idcodeTF.text)){
        [self showNoticeView:@"请输入验证码"];
        return;
    }
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PhoneLoginUrl];
    NSString *openid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KopenID]];
    NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
    NSString *head = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:kheamImageurl]];
    NSString *smallname = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KnickName]];
    NSDictionary *pramdDic = @{@"unionid":unionid,@"openid":openid,@"nickname":smallname,@"head":head,@"phone":_phoneTF.text,@"validatecode":_idcodeTF.text};
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
            
            NSString *uk = [NSString stringWithFormat:@"%@",dict[@"uk"]];
            if (!IsNilOrNull(uk)) {
                [KUserdefaults setObject:uk forKey:@"YDSC_uk"];
            }
            
            NSString *appopenid = [NSString stringWithFormat:@"%@",dict[@"appopenid"]];
            
            [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
            
            [KUserdefaults setObject:@(YES) forKey:KloginStatus];
            
            UserModel *curModel = [[UserModel alloc]initWith:dict[@"data"]];
            curModel.isLogin = YES;
            curModel.userId = @"1";
            [curModel saveUserInfo];
            //清除优惠券缓存
            [KUserdefaults removeObjectForKey:@"CouponCacheDate"];
            [[XNArchiverManager shareInstance] xnDeleteObject:KMyCouponList];
            
            //删除订单购物车缓存
//            RLMResults *result = [GoodModel allObjects];
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            if (result.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result];
//                [realm commitWriteTransaction];
//            }
//            RLMResults *result1 = [SCMyOrderModel allObjects];
//            if (result1.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result1];
//                [realm commitWriteTransaction];
//            }
            
            //            RLMResults *result3 = [SCCategoryGoodsModel allObjects];
            //            if (result2.count > 0) {
            //                [realm beginWriteTransaction];
            //                [realm deleteObjects:result3];
            //                [realm commitWriteTransaction];
            //            }
            [KUserdefaults synchronize];
            [self goFirstPage];
            
        }else{
            [self showNoticeView:dict[@"message"]];
        }
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

-(void)goFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    app.isNewUser = YES;
    [app.window makeKeyAndVisible];
}

-(void)toWeiXinAuth {
    if(![WXApi isWXAppInstalled]){
        //从欢迎页进入app 未登录 并且没有授权
        [self shownotice];
    }else{
        //点击最后一页直接去授权
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"login123";
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }
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

-(void)loginWithPhoneAndOpenid {
    
    [self phoneLogin];
    return;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PhoneLoginUrl];
    NSString *openid = [KUserdefaults objectForKey:KopenID];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    NSString *head = [KUserdefaults objectForKey:kheamImageurl];
    NSString *smallname = [KUserdefaults objectForKey:KnickName];
    
    NSString *phone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kmobile]];
    if (IsNilOrNull(phone)) {
        phone = _phoneTF.text;
    }
    
    NSDictionary *pramdDic = @{@"mobile":phone, @"code": _idcodeTF.text, @"openid":openid, @"unionid":unionid, @"head":head, @"smallname":smallname};
    
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        
        
        NSDictionary *dict = json;
        
        if ([dict[@"code"] integerValue] == 200) {
            
            NSString *uk = [NSString stringWithFormat:@"%@",dict[@"uk"]];
            if (!IsNilOrNull(uk)) {
                [KUserdefaults setObject:uk forKey:@"YDSC_uk"];
            }
            
            NSString *appopenid = [NSString stringWithFormat:@"%@",dict[@"appopenid"]];
            
            [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
            
            //清除优惠券缓存
            [KUserdefaults removeObjectForKey:@"CouponCacheDate"];
            [[XNArchiverManager shareInstance] xnDeleteObject:KMyCouponList];
            
            //删除订单购物车缓存
//            RLMResults *result = [GoodModel allObjects];
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            if (result.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result];
//                [realm commitWriteTransaction];
//            }
//            RLMResults *result1 = [SCMyOrderModel allObjects];
//            if (result1.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result1];
//                [realm commitWriteTransaction];
//            }
//            RLMResults *result2 = [SCMyOrderGoodsModel allObjects];
//            if (result2.count > 0) {
//                [realm beginWriteTransaction];
//                [realm deleteObjects:result2];
//                [realm commitWriteTransaction];
//            }
            //            RLMResults *result3 = [SCCategoryGoodsModel allObjects];
            //            if (result2.count > 0) {
            //                [realm beginWriteTransaction];
            //                [realm deleteObjects:result3];
            //                [realm commitWriteTransaction];
            //            }
            
            if (!IsNilOrNull(_phoneTF.text)) {
                [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
            }
            
            [KUserdefaults setObject:@(YES) forKey:KloginStatus];
            [KUserdefaults synchronize];
            [self goFirstPage];
        }else if([dict[@"code"] integerValue] == 300) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            if ([type isEqualToString:@"wx"]) {
                
                if (!IsNilOrNull(_phoneTF.text)) {
                    [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
                }
                //微信授权
                [self toWeiXinAuth];
            }
        }else{
            [self showNoticeView:dict[@"message"]];
        }
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark-限制手机号输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.phoneTF.text.length >= 20){
            self.phoneTF.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    if (textField == self.idcodeTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.idcodeTF.text.length >= 6){
            self.idcodeTF.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)startTimer{
    [_countDownCode setEnabled:NO];
    [self getVertifyCodeWithButton];
    [_countDownCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
    
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (checkSec > 0) {
                checkSec --;
                [_countDownCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
            }else{
                checkSec = KCheckSec;
                [timer invalidate];
                [_countDownCode setTitle:@"获取验证码" forState:0];
                [_countDownCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
                [_countDownCode setEnabled: YES];
            }
        }];
    } else {
        
    }
    
}

-(void)loginGo{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
