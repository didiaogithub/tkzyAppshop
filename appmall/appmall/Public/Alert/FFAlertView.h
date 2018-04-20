//
//  FFAlertView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAlertView : UIView

+(instancetype)shareInstance;

-(void)showAlert:(NSString *)title;

-(void)showAlert:(NSString *)title content:(NSString*)content;

@end
