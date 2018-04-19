//
//  AppDelegate.h
//  appmall
//
//  Created by 二壮 on 2018/4/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger paymentType;
@property (assign, nonatomic) CGFloat headButtonSize;

+ (AppDelegate* )shareAppDelegate;


@end

