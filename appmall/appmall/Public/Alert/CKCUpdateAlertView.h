//
//  CKCUpdateAlertView.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/12/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKCUpdateAlertView : UIView

+(instancetype)shareInstance;

/**
 更新提示框

 @param content 更新内容
 @param force 否强制更新
 */
-(void)showUpdateAlert:(NSString*)content forceUpdate:(BOOL)force;

@end
