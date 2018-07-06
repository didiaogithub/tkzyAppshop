//
//  CheckUserModel.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/11.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(NSString*)primaryKey {
    return @"userId"; // 首页数据至缓存一份  主键只需要一个
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"userinfo"]) {
        UserInfoModel *model = [[UserInfoModel alloc]initWith:value];
        self.userinfo = model;
    }else{
        [super setValue:value forKey:key];
    }
}

 +(void)deleteCurUserModel{
     NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
     NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
     RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
     RLMResults *result = [UserModel allObjectsInRealm:realm];
     UserModel *model = [result firstObject];
     if(model == nil){
         return;
     }
     [realm deleteObject:model];
     [realm commitWriteTransaction];
}

-(void)saveUserInfo{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:self];
    [realm commitWriteTransaction];
    
    [KUserdefaults setValue:@(self.isLogin) forKey:KloginStatus];
    
}

-(void)Login{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    RLMResults *result = [UserModel allObjectsInRealm:realm];
    UserModel *model = [result firstObject];
    if(model != nil){
        model.isLogin = YES;
        [self.realm beginWriteTransaction];
        [self.realm addOrUpdateObject:model];
        [self.realm commitWriteTransaction];
        [KUserdefaults setValue:@(model.isLogin) forKey:KloginStatus];
        
    }
    
}

+(NSString *)getCurUserToken{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    RLMResults *result = [UserModel allObjectsInRealm:realm];
    UserModel *model = [result firstObject];
    if(model.token == nil){
        return @"";
    }else{
        if ( [[KUserdefaults objectForKey:KloginStatus] boolValue] == YES) {
            return model.token;
        }else{
            return @"";
        }
    }
}

-(void)LoginOut{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    RLMResults *result = [UserModel allObjectsInRealm:realm];
    UserModel *model = [result firstObject];
    if(model != nil){
        model.isLogin = NO;
        [self.realm beginWriteTransaction];
        [self.realm addOrUpdateObject:model];
        [self.realm commitWriteTransaction];
        [KUserdefaults setValue:@(model.isLogin) forKey:KloginStatus];
        
    }
}

+ (UserModel *)getCurUserModel{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    RLMResults *result = [UserModel allObjectsInRealm:realm];
    UserModel *model = [result firstObject];
    return model;
}

@end

@implementation  UserInfoModel

+(NSString*)primaryKey {
    return @"customerid"; // 首页数据至缓存一份  主键只需要一个
}
@end
