//
//  LoadingAndMsgTipView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingAndMsgTipView : UIView

@property (nonatomic, strong) UIButton *blackBt;
/**
 *  开始动画
 */
- (void)startAnimation;
/**
 * 结束动画
 */
- (void)stopAnimation;
/**
 * 提示语
 */
- (void)showNoticeView:(NSString*)title;

@end
