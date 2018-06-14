//
//  AppDelegate.m
//  appmall
//
//  Created by 二壮 on 2018/4/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

//hehe
#import "DefaultValue.h"
#import "RootNavigationController.h"
#import "BKGuidePageAppearToll.h"
#import "BKGuidePageController.h"
#import "SCAdGoodsViewController.h"
#import "SCProgressTimerView.h"
#import "SCEverydayGuideVC.h"//每天第一次启动显示的引导页
#import "CKVersionCheckManager.h"
#import "CKShareManager.h"


@interface AppDelegate ()<ADTimerDelegate,UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIViewController *tempRootVC;
@property (nonatomic, copy)   NSString *statusStr;
@property (nonatomic, strong) SCProgressTimerView *waitTimer;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property(nonatomic,assign)NSInteger lastSelectedIndex;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 极光推送
    
    [[CKJPushManager manager] registerJPushWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    if ([[CKVersionCheckManager shareInstance] isFirstLoadCurrentVersion]) {
        [[DefaultValue shareInstance] cleanLoginStatusCacheData];
    }
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
    [[DefaultValue shareInstance] defaultValue];
    
    [RequestManager manager];
    
    //分享
    [CKShareManager manager];
    
    [self initKeyWindow];
   
    [CKCNotificationCenter addObserver:self selector:@selector(checkAppDoesOnCheck) name:RequestManagerReachabilityDidChangeNotification object:nil];
     [WXApi registerApp:kWXAPP_ID];
    [self configKeyboard];
    [self getSettings];
    return YES;
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)initKeyWindow {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _tempRootVC = [[UIViewController alloc] init];
    _tempRootVC.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_tempRootVC.view addSubview:iv];
    
    //启动时请求相关数据，下面为临时页面
    if (SCREEN_HEIGHT < 568) {
        iv.image = [UIImage imageNamed:@"iphone4.png"];
    }else if(SCREEN_HEIGHT == 568){
        iv.image = [UIImage imageNamed:@"iphone5.png"];
    }else if(SCREEN_HEIGHT == 667){
        iv.image = [UIImage imageNamed:@"iphone6.png"];
    }else if(SCREEN_HEIGHT == 736){
        iv.image = [UIImage imageNamed:@"iphone7p.png"];
    }else if(SCREEN_HEIGHT == 812){
        iv.image = [UIImage imageNamed:@"iphoneX.png"];
    }
    
    self.window.rootViewController = _tempRootVC;
    [self.window makeKeyAndVisible];
    
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = (UIEdgeInsets)
    {
        .top = 0.0f,
        .bottom = 60.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
}

-(void)checkAppDoesOnCheck {
    
    UIViewController *vc = [UIViewController currentVC];
    if (![vc isEqual:_tempRootVC]) {
        return;
    }
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    if ([_statusStr integerValue] == status) {
        return;
    }else{
        _statusStr = [NSString stringWithFormat:@"%ld", status];
    }
    
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            
            _isFirst = YES;
            //如果请求审核接口成功并且返回code200，那么之后不再请求，除非卸载应用
                BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
                if (appear == YES) {
                    BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
                    self.window.rootViewController = guideVc;
                    [self.window makeKeyAndVisible];
                }else{
                    [self normalLaunchApp];
                }
        }
            break;
        default: {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前无网络，请连接网络后再试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertVC addAction:action];
            [alertVC addAction:actionCancel];
            UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
            [vc presentViewController:alertVC animated:YES completion:nil];
        }
            break;
    }
}

//-(void)appLaunchType {
//
//    NSString *appCheckUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, IsIosCheck_Url];
//    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSDictionary *params = @{@"ver": currentVersion};
//
//    [HttpTool getWithUrl:appCheckUrl params:params success:^(id json) {
//        NSDictionary *dict = json;
//        if ([dict[@"code"] integerValue] == 200) {//审核通过：200
//            [KUserdefaults setObject:@"200" forKey:@"IOS_CheckCode"];
//            BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
//            if (appear == YES) {
//                BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
//                self.window.rootViewController = guideVc;
//                [self.window makeKeyAndVisible];
//            }else{
//                [self normalLaunchApp];
//            }
//        }else{//审核中：非200
//            BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
//            if (appear == YES) {
//                BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
//                self.window.rootViewController = guideVc;
//                [self.window makeKeyAndVisible];
//            }else{
//                [self goWelcom];
//            }
//        }
//    } failure:^(NSError *error) {
//
//        if (_isFirst == YES) {
//            _isFirst = NO;
//            [self appLaunchType];
//        }else{
//
//            NSString *loginWithCheckPhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"loginWithCheckPhone"]];
//            if (IsNilOrNull(loginWithCheckPhone)) {
//
//                if ([USER_OPENID isEqualToString:OpenidForLogin] || [USER_OPENID isEqualToString:OpenidForRegist]) {
//                    [self goWelcom];
//                }else{
//                    [KUserdefaults setObject:@"200" forKey:@"IOS_CheckCode"];
//                    BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
//                    if (appear == YES) {
//                        BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
//                        self.window.rootViewController = guideVc;
//                        [self.window makeKeyAndVisible];
//                    }else{
//                        [self normalLaunchApp];
//                    }
//                }
//            }else{
//                [self enterFirstPage];
//            }
//        }
//    }];
//}

-(void)loadAD {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [documentsDirectoryPath stringByAppendingString:@"/MyImage.jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    UIImage *img = [UIImage imageWithData:data];
    if (img != nil) {//有图片显示广告页面
        SCAdGoodsViewController *adVc = [[SCAdGoodsViewController alloc] init];
        self.window.rootViewController = adVc;
        [self.window makeKeyAndVisible];
    }else{//没有则进入欢迎页面
         [self enterFirstPage];
//        BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
//        if (str == NO) {
//            [self goWelcom];
//        }else{
//            [self enterFirstPage];
//        }
    }
}

-(void)normalLaunchApp {
    
    NSDate *firstLaunchDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *launchDateStr = [dateformatter stringFromDate:firstLaunchDate];
    NSString *cacheLaunchDataStr = [KUserdefaults objectForKey:@"FirstLaunchAppEveryday"];
    
    if (![launchDateStr isEqualToString:cacheLaunchDataStr]) {
        
        //不显示欢迎页，显示新的轮播页面可控的
        NSLog(@"第一次启动");
        //活动页@"typeCode":@"AD" 首页@"typeCode":@"AL" 引导页：GD
        NSDictionary *paramters = @{@"typeCode":@"GD"};
        NSString *adUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AdUrl];
        [HttpTool getWithUrl:adUrl params:paramters success:^(id json) {
            
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] == 200) {
                NSArray *arr = dict[@"list"];
                if (arr.count > 0) {
                    NSMutableArray *temp = [NSMutableArray array];
                    for (NSDictionary *dict in arr) {
                        NSString *path = [NSString stringWithFormat:@"%@", dict[@"path"]];
                        [temp addObject:path];
                    }
                    SCEverydayGuideVC *gd = [[SCEverydayGuideVC alloc] init];
                    gd.imageArray = temp;
                    self.window.rootViewController = gd;
                    [self.window makeKeyAndVisible];
                }else{
                    
                     [self enterFirstPage];
                    

                }
            }else{
                 [self enterFirstPage];

            }
        } failure:^(NSError *error) {
             [self enterFirstPage];

        }];
    }else{
        NSLog(@"不是第一次启动");
        if (IsNilOrNull(USER_OPENID)) {//没有openid不请求启动页广告
             [self enterFirstPage];
//            BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
//            if (str == NO) {
//                [self goWelcom];
//            }else{
//                [self enterFirstPage];
//            }
        }else{
            _waitTimer = [[SCProgressTimerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 40, 40)];
            _waitTimer.count = 0;
            _waitTimer.delegate = self;
            [_waitTimer time];
            NSLog(@"启动定时器:%@", [NSDate date]);
            //活动页@"typeCode":@"AD" 首页@"typeCode":@"AL"
            NSDictionary *paramters = @{@"openid":USER_OPENID, @"typeCode":@"AD"};
            NSString *adUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AdUrl];
            [HttpTool getWithUrl:adUrl params:paramters success:^(id json) {
                
                NSDictionary *dict = json;
                if ([dict[@"code"] integerValue] == 200) {
                    NSArray *arr = dict[@"list"];
                    //处理启动页广告返回数据
                    [self processADData:arr];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                [_waitTimer.delegate adTimerStop];
            }];
        }
    }
    
    [KUserdefaults setValue:launchDateStr forKey:@"FirstLaunchAppEveryday"];
    [KUserdefaults synchronize];
    
}

-(void)processADData:(NSArray*)arr {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [documentsDirectoryPath stringByAppendingString:@"/MyImage.jpg"];
    if (!IsNilOrNull(imgPath)) {
        [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
    }
    
    NSDictionary *goodsDic = arr.firstObject;
    
    NSString *activityid = [NSString stringWithFormat:@"%@", goodsDic[@"activityid"]];
    NSString *itemid = [NSString stringWithFormat:@"%@", goodsDic[@"itemid"]];
    NSString *link = [NSString stringWithFormat:@"%@", goodsDic[@"link"]];
    NSString *path = [NSString stringWithFormat:@"%@", goodsDic[@"path"]];
    NSString *adId = [NSString stringWithFormat:@"%@", goodsDic[@"id"]];
    NSString *limitnum = [NSString stringWithFormat:@"%@", goodsDic[@"limitnum"]];
    
    if (!IsNilOrNull(activityid)) {
        [KUserdefaults setObject:activityid forKey:@"YDSC_AD_activityid"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_activityid"];
    }
    if (!IsNilOrNull(itemid)) {
        [KUserdefaults setObject:itemid forKey:@"YDSC_AD_itemid"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_itemid"];
    }
    if (!IsNilOrNull(link)) {
        [KUserdefaults setObject:link forKey:@"YDSC_AD_link"];
    }else{
        [KUserdefaults setObject:@"" forKey:@"YDSC_AD_link"];
    }
    if (!IsNilOrNull(path)) {
        [KUserdefaults setObject:path forKey:@"YDSC_AD_path"];
    }
    if (!IsNilOrNull(adId)) {
        [KUserdefaults setObject:adId forKey:@"YDSC_AD_adId"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_adId"];
    }
    if (!IsNilOrNull(limitnum)) {
        [KUserdefaults setObject:limitnum forKey:@"YDSC_AD_limitnum"];
    }
    
    NSLog(@"启动页广告保存路径:%@", documentsDirectoryPath);
    [self saveImage:[self getImageFromURL:path] withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
}
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
    
    //如果不到3s那么图片下载完成就销毁，进入广告页面或者首页
    [_waitTimer.delegate adTimerStop];
    
}

#pragma mark - PRIVATE METHODS
-(UIImage *)getImageFromURL:(NSString *)fileURL {
    NSLog(@"开始下载图片");
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    NSLog(@"图片下载完成");
    return result;
}

-(void)adTimerStop {
    
    NSLog(@"销毁定时器:%@", [NSDate date]);
    [_waitTimer stop];
    
    NSString *path = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_path"]];
    if (!IsNilOrNull(path)) {
        [self loadAD];
    }else{
         [self enterFirstPage];
//        BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
//        if (str == NO) {
//            [self goWelcom];
//        }else{
//            [self enterFirstPage];
//        }
    }
}

-(void)configKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarByTag; // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
    rootVC.delegate = self;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    
    [self.window.rootViewController presentViewController:welcomeNav animated:YES completion:nil];
//    [self.window makeKeyAndVisible];
}

//-(void)showNewFeature{
//    NewFeatureViewController * newFeatureVC = [[NewFeatureViewController alloc]init];
//    newFeatureVC.delegate = self;
//    _window.rootViewController = newFeatureVC;
//
//}
//-(void)setNewFeature{
//
//    lastVersion = [defaults objectForKey:KEYAPPVERSION];
//    curVersion = [NSBundle mainBundle].infoDictionary[KEYCURAPPVERSION];
//    if ([curVersion isEqualToString:lastVersion]) { //
//
//        _window.rootViewController = tabBarControllerMain;
//    }else{
//        [defaults setObject:curVersion forKey:KEYAPPVERSION];
//        [defaults synchronize];
//        [self showNewFeature];
//    }
//}
//
//-(void)setKeyWindow{
//    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [_window makeKeyAndVisible];
//    _window.backgroundColor = [UIColor whiteColor];
//
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}








- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)newFeatureSetRootVC{
//    _window.rootViewController = tabBarControllerMain;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RequestManagerReachabilityDidChangeNotification object:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}


//授权后回调 WXApiDelegate
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp *)resp {
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //微信授权回调处理
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            [CKCNotificationCenter postNotificationName:@"cancel" object:@(aresp.errCode)];
            [self getWeiCodefinishedWhth:resp];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    //微信支付回调 处理
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        [CKCNotificationCenter postNotificationName:WeiXinPay_CallBack object:@(response.errCode)];
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        [CKCNotificationCenter postNotificationName:WeiXinShare_CallBack object:@(response.errCode)];
    }
}

#pragma mark-通过第一步code获取Accesontoken
-(void)getWeiCodefinishedWhth:(BaseResp *)req
{
    if (req.errCode==0) {
        NSLog(@"用户同意");
        //到绑定手机号
        SendAuthResp *aresp=(SendAuthResp *)req;
        NSLog(@"state=====%@",aresp.state);
        [self getAccessTokenWithCode:aresp.code andStateStr:aresp.state];
    }else if (req.errCode==-4){
        NSLog(@"用户拒绝");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }else if (req.errCode==-2){
        NSLog(@"用户取消");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

-(void)getAccessTokenWithCode:(NSString *)code andStateStr:(NSString *)stateStr {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信的返回%@",dict);
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                }else{
                    NSLog(@"%@",dict);
                    NSLog(@"unionid===%@",dict[@"unionid"]);
                    NSLog(@"openid=====%@",dict[@"openid"]);
                    NSLog(@" RefreshToken===%@",dict[@"refresh_token"]);
                    
                    //openid
                    NSString *openid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"openid"]];
                    if (IsNilOrNull(openid)){
                        openid = @"";
                    }
                    [KUserdefaults setObject:openid forKey:KopenID];
                    
                    NSString *unionid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unionid"]];
                    if (IsNilOrNull(unionid)){
                        unionid = @"";
                    }
                    [KUserdefaults setObject:unionid forKey:Kunionid];
                    
                    //刷新的token
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",dict[@"refresh_token"]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    
                    //请求的token
                    NSString *access_token = [NSString stringWithFormat:@"%@",dict[@"access_token"]];
                    if (IsNilOrNull(access_token)){
                        access_token = @"";
                    }
                    
                    //token过期时间
                    NSString *expires_in = [NSString stringWithFormat:@"%@",dict[@"expires_in"]];
                    if (IsNilOrNull(expires_in)){
                        expires_in = @"";
                    }
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    NSDate *oldDate = [NSDate date];    //获取AccessToken RefreshToken的一致时间
                    NSLog(@" oldDate =======%@ ",oldDate);
                    [KUserdefaults setObject:oldDate forKey:KolderData];
                    [KUserdefaults setObject:refresh_token forKey:kWeiXinRefreshToken];
                    
                    [KUserdefaults setObject:access_token forKey:KAccsess_token];
                    
                    [KUserdefaults setObject:expires_in forKey:KExpires_in];
                    
                    [KUserdefaults synchronize];
                    [self getUserInfoWithAccessToken:access_token andOpenId:openid andStateStr:stateStr];
                }
            }
        });
    });
}



#pragma mark 获取用户的信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId andStateStr:(NSString *)stateStr
{
    NSLog(@"openId%@",openId);
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 ), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kWeiXinRefreshToken]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:refresh_token];
                }else{
                    //获取需要的数据
                    NSLog(@"获取的用户信息%@",dict);
                    
                    [KUserdefaults setObject:dict[@"nickname"] forKey:KnickName];
                    
                    [KUserdefaults setObject:dict[@"headimgurl"] forKey:kheamImageurl];
                    [KUserdefaults synchronize];
                    //授权后跳转
                    NSString *authTypeWX = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_WxLogin_Click"]];
                    if ([authTypeWX isEqualToString:@"clickWechatBtn"]) {
                        [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
                        [KUserdefaults setObject:@"" forKey:@"YDSC_PhoneLogin_Click"];
                        
                        [CKCNotificationCenter postNotificationName:@"YDSC_WxLogin_Click" object:nil];
                    }
                    
                    NSString *authTypePhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_PhoneLogin_Click"]];
                    if([authTypePhone isEqualToString:@"clickPhoneBtn"]){
                        [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
                        [KUserdefaults setObject:@"" forKey:@"YDSC_PhoneLogin_Click"];
                        [CKCNotificationCenter postNotificationName:WeiXinAuthSuccess object:nil];
                    }
                }
            }
        });
    });
}


//重新获取AccessToken
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWXAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else
                {
                    //重新使用AccessToken获取信息
                    NSLog(@"重新使用AccessToken获取信息%@",dict);
                }
            }
        });
    });
}

- (void)showNoticeView:(NSString*)title{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 3 || tabBarController.selectedIndex == 4 || tabBarController.selectedIndex == 2){
        //未登录
        if ([[KUserdefaults objectForKey:KloginStatus] boolValue] == NO) {
            if (self.lastSelectedIndex == 4 || self.lastSelectedIndex == 3||self.lastSelectedIndex == 2) {
                tabBarController.selectedIndex = 0;
            }else{
                tabBarController.selectedIndex = self.lastSelectedIndex;
            }
            
            [self goWelcom];
            return;
        }
    }
    self.lastSelectedIndex = tabBarController.selectedIndex;
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[CKJPushManager manager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[CKJPushManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[CKJPushManager manager] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[CKJPushManager manager] application:application didRegisterUserNotificationSettings:notificationSettings];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[CKJPushManager manager] applicationWillEnterForeground:application];
    //    //是否强制更新
    //    [[CKVersionCheckManager shareInstance] showForceUpdate];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[CKJPushManager manager] applicationDidEnterBackground:application];
}

// 获取全局配置
- (void)getSettings{
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getSettingsApi];
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            return;
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end
