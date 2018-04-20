//
//  CKRealnameIdentifyView.h
//  CKYSPlatform
//
//  Created by 二壮 on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKRealnameIdentifyView : UIView


@property (nonatomic, copy) void(^textFieldTextBlock)(NSString *name, NSString *idNo);

@property (nonatomic, copy) NSString *operationName;

+(instancetype)shareInstance;

/**
 实名认证
 
 @param title 姓名
 @param content 身份证号码
 */
- (void)showAlert:(NSString *)name idNo:(NSString*)idNo textFieldText:(void(^)(NSString *name, NSString *idNo))textFieldText;

@end
