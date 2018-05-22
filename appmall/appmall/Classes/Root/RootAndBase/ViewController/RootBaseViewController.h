//
//  RootBaseViewController.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/6/15.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAndMsgTipView.h"

@interface RootBaseViewController : UIViewController
@property(atomic,strong)RLMRealm *realm;
@property (nonatomic, strong) RLMNotificationToken *token;
@property (nonatomic, strong) LoadingAndMsgTipView *loadingView;
@property (nonatomic, strong) UIView *netTip;
- (NSDictionary *)readLocalFileWithName:(NSString *)name ;
@end
