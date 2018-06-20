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
@property (nonatomic, strong) JGProgressHUD *shoppingViewNetError;
@property (nonatomic, strong) JGProgressHUD *shoppingViewNetSuccess;
@property (nonatomic, strong) AppDelegate * appDelegate;

//添加提示view
- (void)showNoticeView:(NSString*)title;
- (void)setRightButton:(NSString *)btnName;
- (void)setRightImageButton:(NSString *)btnName;
- (void)setRightButton:(NSString *)btnName titleColor:(UIColor *)titleColor isTJXHX:(BOOL)isTJXHX;
- (void)rightBtnPressed;
- (void)showAddShoppingNoticeViewIsSuccess:(BOOL) success andTitle:(NSString *)title;
@end
