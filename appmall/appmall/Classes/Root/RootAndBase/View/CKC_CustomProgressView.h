
//  CKC_CustomProgressView.h

//  Created by 二壮 on 16/6/30.
//  Copyright © 2016年 link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JGProgressHUD.h>

@interface CKC_CustomProgressView : UIView

@property (nonatomic, strong) UIImageView *progressView;
@property (nonatomic, strong) UIButton * blackBt;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
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
