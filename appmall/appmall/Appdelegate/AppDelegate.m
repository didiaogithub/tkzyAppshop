//
//  AppDelegate.m
//  appmall
//
//  Created by 二壮 on 2018/4/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AppDelegate.h"
//hehe
#import "DefaultValue.h"
#import "RootNavigationController.h"
#import "BKGuidePageAppearToll.h"
#import "BKGuidePageController.h"
#import "SCAdGoodsViewController.h"
#import "SCProgressTimerView.h"
#import "SCEverydayGuideVC.h"//每天第一次启动显示的引导页
#import "CKVersionCheckManager.h"


@interface AppDelegate ()<ADTimerDelegate>

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIViewController *tempRootVC;
@property (nonatomic, copy)   NSString *statusStr;
@property (nonatomic, strong) SCProgressTimerView *waitTimer;
@property (nonatomic, strong) JGProgressHUD *viewNetError;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if ([[CKVersionCheckManager shareInstance] isFirstLoadCurrentVersion]) {
        [[DefaultValue shareInstance] cleanLoginStatusCacheData];
    }
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [[DefaultValue shareInstance] defaultValue];
    
    [RequestManager manager];
    
    [self initKeyWindow];

    [CKCNotificationCenter addObserver:self selector:@selector(checkAppDoesOnCheck) name:RequestManagerReachabilityDidChangeNotification object:nil];
    
    [self configKeyboard];
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
        BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
        if (str == NO) {
            [self goWelcom];
        }else{
            [self enterFirstPage];
        }
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
                    BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
                    if (str == NO) {
                        [self goWelcom];
                    }else{
                        [self enterFirstPage];
                    }
                }
            }else{
                BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
                if (str == NO) {
                    [self goWelcom];
                }else{
                    [self enterFirstPage];
                }
            }
        } failure:^(NSError *error) {
            BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
            if (str == NO) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
        }];
    }else{
        NSLog(@"不是第一次启动");
        if (IsNilOrNull(USER_OPENID)) {//没有openid不请求启动页广告
            BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
            if (str == NO) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
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
        BOOL str = [[KUserdefaults objectForKey:KloginStatus] boolValue];
        if (str == NO) {
            [self goWelcom];
        }else{
            [self enterFirstPage];
        }
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

-(void)showCheckLoginView {
    NSString *loginWithCheckPhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"loginWithCheckPhone"]];
    if (IsNilOrNull(loginWithCheckPhone)) {
        NSLog(@"去注册登录吧");
        CommonLoginViewController *login = [[CommonLoginViewController alloc] init];
        RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = loginNavi;
        [self.window makeKeyAndVisible];
    }else{
        [self enterFirstPage];
    }
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    self.window.rootViewController = welcomeNav;
    [self.window makeKeyAndVisible];
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


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

@end
