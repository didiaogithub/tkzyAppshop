//
//  BaseViewController.h
//  ShoppingCentre
//
//  Created by 二壮 on 16/7/12.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKC_CustomProgressView.h"
#import "AppDelegate.h"
#import <RLMRealm.h>
@interface BaseViewController : UIViewController
@property(atomic,strong)RLMRealm *realm;
@property (nonatomic, strong) CKC_CustomProgressView *loadingView;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) AppDelegate * appDelegate;

//添加提示view
- (void)showNoticeView:(NSString*)title;

@end
