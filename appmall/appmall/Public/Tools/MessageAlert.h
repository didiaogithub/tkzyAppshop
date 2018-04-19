//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 二壮. on 15/12/25.
//  Copyright © 2015年 二壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageAlert : UIView

/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;

/**
 * 展示
 */
- (void)showAlert:(NSString *)title;


@end
