//
//  CheckUserModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/11.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel:BaseModel


@property(nonatomic,strong)NSString *customerid;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *head;
@property(nonatomic,strong)NSString *gradeid;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *realname;


@end

@interface UserModel :BaseModel
@property(nonatomic,strong)NSString  *userId;
@property (nonatomic,strong)UserInfoModel *userinfo;
@property (nonatomic,strong)NSString  *token;
@property (nonatomic,assign)BOOL  isLogin;

-(void)saveUserInfo;
-(void)Login;
-(void)LoginOut;
+ (UserModel *)getCurUserModel;
+(void)deleteCurUserModel;
+(NSString *)getCurUserToken;

@end


