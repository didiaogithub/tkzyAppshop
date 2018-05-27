//
//  CheckUserModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/11.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseModelRoot.h"

@interface UserInfoModel:BaseModelRoot


@property NSString *customerid;
@property NSString *nickname;
@property NSString *head;
@property NSString *gradeid;
@property NSString *phone;
@property NSString *realname;

@end

@interface UserModel :BaseModelRoot
@property NSString  *userId;
@property UserInfoModel *userinfo;
@property NSString  *token;
@property BOOL  isLogin;

-(void)saveUserInfo;
-(void)Login;
-(void)LoginOut;
+ (UserModel *)getCurUserModel;
+(void)deleteCurUserModel;
+(NSString *)getCurUserToken;

@end


