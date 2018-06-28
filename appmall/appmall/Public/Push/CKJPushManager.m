//
//  CKJPushManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKJPushManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MessageAlert.h"
#import "MessageViewController.h"
#import "MessageDetailViewController.h"
#import "WebDetailViewController.h"
static NSString *appKey = @"7c0f313789218c8884f00832";
static NSString *channel = @"App Store";
static BOOL isProduction = YES;

@implementation CKJPushManager

+(instancetype)manager {
    static CKJPushManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKJPushManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        _gfMessageCount = 0;
        _wlMessageConut = 0;
        _ddMessageCount = 0;
        _fqMessageCount = 0;
        _fpMessageCount = 0;
        
    }
    return self;
}

-(void)registerJPushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"方法名称:%s", __func__);
    //初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //初始化JPush
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    
    //打开极光推送日志
    [JPUSHService setDebugMode];
    //开启Crash日志收集
    [JPUSHService crashLogON];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 后台获取消息 跳转不同界面
    //  如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // 程序未启动 是通过点击 通知apn消息打开app  此方法 被didReceiveRemoteNotification 替代 都会走
    }else{
       
    }
    // 清空icon 设置JPush服务器中存储的badge值 value 取值范围：[0,99999]
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark 注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"\n[获取Token]---[%@]",deviceToken);
    //注册 DeviceToken
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        [JPUSHService registerDeviceToken:deviceToken];
        
       });
    NSString *customerId = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KcustomerId]];
    if (!IsNilOrNull(customerId)) {
        NSString *uid = [NSString stringWithFormat:@"C_%@",customerId];
        [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"注册成功：%@", iAlias);
        } seq:0];
        //查看registId
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        }];
    }
}

-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, notification);
    
    NSDictionary *userInfo = notification.userInfo;
    //应用外点击icon有extras，点击通知是aps
    NSDictionary *extras = [userInfo objectForKey:@"extras"];
    NSString *content = [userInfo objectForKey:@"content"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *type = [extras objectForKey:@"type"];//内容
    if (IsNilOrNull(title)) {
        title = @"";
    }

    return;
    

    
}

/**
 说明用户点击通知, 进入了程序(程序还在运行中, 程序并没有被关掉) 本地消息
 */
-(void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, notification);
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    
    NSString *type = [userInfo objectForKey:@"type"];

}

#pragma mark - 注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"方法名称:%s", __func__);
    [application registerForRemoteNotifications];
}

#pragma mark - 收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    AudioServicesPlaySystemSound(1007);
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, userInfo);
    
    NSLog(@"app状态%zd",application.applicationState);
    
    // iOS 10 以下 Required
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // IOS 7 Support Required
    if (application.applicationState == UIApplicationStateActive){//在应用内时收到推送
        [self appForgrounMessage:userInfo];
        NSLog(@"app进入前台UIApplicationStateActive");
        
    }else if(application.applicationState == UIApplicationStateInactive){//从应用外 滑动推送信息
        NSLog(@"app由后台进入前台UIApplicationStateInactive");
        [self jpshApnsMessage:userInfo];
    }else if(application.applicationState == UIApplicationStateBackground){
        //处理点击图标
        NSLog(@"Background后台收到推送消息");
        [self appForgrounMessage:userInfo];
    }
    
    
    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate
// iOS 10 Support 添加处理APNs通知回调方法 这个方法 是App在应用内收到的推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, notification);
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self appForgrounMessage:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    //Alert会有通知栏通知
    completionHandler(UNNotificationPresentationOptionSound);
    
}
// iOS 10 Support 这个是应用外，活跃状态
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, userInfo);
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self jpshApnsMessage:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - 应用内收到的极光推送消息
-(void)appForgrounMessage:(NSDictionary *)userInfo{
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, userInfo);
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    NSString *type = [userInfo objectForKey:@"type"];
    if (IsNilOrNull(type)) {
        type = @"";
    }
    NSString *viewId = [userInfo objectForKey:@"viewid"];
    [CKCNotificationCenter postNotificationName:@"showWhiteLab" object:nil];
    [CKCNotificationCenter postNotificationName:@"refreshMessageCount" object:nil];
     // 1官方提醒 2物流提醒 3订单提醒 4付款提醒 5发票提醒

//    如果是系统消息 就有 type参数，代表的是系统消息分类，如果是官方通知就有viewid  代表的是官方通知的文章编号
    
    UIViewController *currentVC = [self currentVC];
    
    if (!IsNilOrNull(viewId)) {
        _gfMessageCount ++;
        if (![currentVC isKindOfClass:[WebDetailViewController class]]){
            MessageAlert *messageByPushAler = [[MessageAlert alloc] init];
            messageByPushAler.isDealInBlock = YES;
            UIApplication *application = [UIApplication sharedApplication];
            WebDetailViewController *detail = [[WebDetailViewController alloc]init];
            [messageByPushAler hiddenCancelBtn:NO];
            [messageByPushAler showAlert:title content:content btnClick:^{
                detail.detailUrl =  [NSString stringWithFormat:@"%@h5/html/officialnotice.html?id=%@",WebServiceAPI,viewId];
                _gfMessageCount -- ;
                [self totalcount];
                [currentVC.navigationController pushViewController:detail animated:YES];
            }];
        }
    }else{
        if ([type isEqualToString:@"1"]) {
            _wlMessageConut++;
        }
        if ([type isEqualToString:@"2"]) {
            _ddMessageCount++;
        }
        if ([type isEqualToString:@"3"]) {
            _fqMessageCount++;
        }
        if ([type isEqualToString:@"4"]) {
            _fpMessageCount++;
        }
    }
    
    if (![currentVC isKindOfClass:[MessageDetailViewController class]]) {
        
        MessageAlert *messageByPushAler = [[MessageAlert alloc] init];
        messageByPushAler.isDealInBlock = YES;
        UIApplication *application = [UIApplication sharedApplication];
        MessageDetailViewController *detail = [[MessageDetailViewController alloc]init];
        if (application.applicationState == UIApplicationStateActive){//在应用内时收到推送
            if ([type isEqualToString:@"1"]){
                [messageByPushAler hiddenCancelBtn:NO];
                [messageByPushAler showAlert:title content:content btnClick:^{
        
                    detail.messageType = @"1";
                    detail.titleStr = title;
                    _wlMessageConut = 0;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
                }];
            }else if([type isEqualToString:@"2"] ){
           
                [messageByPushAler hiddenCancelBtn:NO];
                [messageByPushAler showAlert:title content:content btnClick:^{
                 
                    _ddMessageCount = 0;
                     detail.messageType = @"2";
                    detail.titleStr = title;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
                }];
            }else if ([type isEqualToString:@"3"]){
            
                [messageByPushAler hiddenCancelBtn:NO];
                [messageByPushAler showAlert:title content:content btnClick:^{
                    detail.messageType = @"3";
                    _fqMessageCount = 0;
                    detail.titleStr = title;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
                }];
            }else if ([type isEqualToString:@"4"]){
                [messageByPushAler hiddenCancelBtn:NO];
                [messageByPushAler showAlert:title content:content btnClick:^{
                    detail.messageType = @"4";
                    detail.titleStr = title;
                    _fpMessageCount = 0;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
                }];
            }

        }
    }
   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification" object:@{@"type":type}];
}

- (void)totalcount{
    
    int gfcount = [CKJPushManager manager].gfMessageCount;
    int wlcount = [CKJPushManager manager].wlMessageConut;
    int ddcount = [CKJPushManager manager].ddMessageCount;
    int fqcount = [CKJPushManager manager].fqMessageCount;
    int fpcount = [CKJPushManager manager].fpMessageCount;
    int totalcount = gfcount + wlcount + ddcount + fqcount + fpcount;
    if (totalcount == 0) {
        [CKCNotificationCenter postNotificationName:@"hiddenWhiteLab" object:nil];
    }
}
#pragma mark-处理应用外极光收到推送消息
- (void)jpshApnsMessage:(NSDictionary *)userInfo {
    
    NSLog(@"方法名称:%s\n收到消息:%@", __func__, userInfo);
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    NSString *type = [userInfo objectForKey:@"type"];
    if (IsNilOrNull(type)) {
        type = @"";
    }
    NSString *viewId = [userInfo objectForKey:@"viewid"];
    

    [CKCNotificationCenter postNotificationName:@"showWhiteLab" object:nil];
    [CKCNotificationCenter postNotificationName:@"refreshMessageCount" object:nil];
    // 1官方提醒 2物流提醒 3订单提醒 4付款提醒 5发票提醒
    //    如果是系统消息 就有 type参数，代表的是系统消息分类，如果是官方通知就有viewid  代表的是官方通知的文章编号
    UIViewController *currentVC = [self currentVC];
    if (!IsNilOrNull(viewId)) {
        _gfMessageCount ++;
        if (![currentVC isKindOfClass:[WebDetailViewController class]]){

            WebDetailViewController *detail = [[WebDetailViewController alloc]init];
                detail.detailUrl =  [NSString stringWithFormat:@"%@/h5/html/officialnotice.html?id=%@",WebServiceAPI,viewId];
                _gfMessageCount -- ;
                [self totalcount];
            [currentVC.navigationController pushViewController:detail animated:YES];
        }
    }else{
        if ([type isEqualToString:@"1"]) {
            _wlMessageConut++;
        }
        if ([type isEqualToString:@"2"]) {
            _ddMessageCount++;
        }
        if ([type isEqualToString:@"3"]) {
            _fqMessageCount++;
        }
        if ([type isEqualToString:@"4"]) {
            _fpMessageCount++;
        }
    }
    
    
    
    if (![currentVC isKindOfClass:[MessageDetailViewController class]]) {
        //7：订单支付通知（代理）9：订单支付通知（公司） 11：提交订单通知（代理）10：提交订单通知（公司）
        
        MessageDetailViewController *detail = [[MessageDetailViewController alloc]init];
            if ([type isEqualToString:@"1"]){
                    detail.messageType = @"1";
                    detail.titleStr = title;
                    _wlMessageConut = 0;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
            }else if([type isEqualToString:@"2"] ){
                
                    _ddMessageCount = 0;
                    detail.messageType = @"2";
                    detail.titleStr = title;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
            }else if ([type isEqualToString:@"3"]){
                
                    detail.messageType = @"3";
                    _fqMessageCount = 0;
                    detail.titleStr = title;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
            }else if ([type isEqualToString:@"4"]){
                    detail.messageType = @"4";
                    detail.titleStr = title;
                    _fpMessageCount = 0;
                    [self totalcount];
                    [currentVC.navigationController pushViewController:detail animated:YES];
            }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification" object:@{@"type":type}];
}


- (UIViewController *)currentVC {
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        } else {
            currVC = Rootvc;
            Rootvc = nil;
        }
    } while (Rootvc!=nil);
    return currVC;
}

#pragma mark 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 推送发生错误
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo objectForKey:@"error"];
    NSLog(@"%@", error);
}

#pragma mark 用户是否关闭了推送
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    CGFloat iOS = [[UIDevice currentDevice].systemVersion doubleValue];

    if(iOS>=8) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    return NO;
}

//进入后台清零是因为如果在前台收到了消息，进入后台再推送消息不从零开始增加
-(void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService resetBadge];
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
    
}

@end

