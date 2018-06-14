//
//  TKHomeDataModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TKHomeDataModel.h"

@implementation TKHomeDataModel

+(NSString*)primaryKey {
    return @"modelId"; // 首页数据至缓存一份  主键只需要一个
}



-(void)setValue:(id)value forKey:(NSString *)key{
    key  = [key stringByReplacingOccurrencesOfString:@" " withString:@""];;
    if ([key isEqualToString:@"bannerList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            BannerModel *model = [[BannerModel alloc]initWith:itemDic];
            [self.bannerList addObject:model];
        }
        return;
    }
    
    if ([key isEqualToString:@"topicList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            TopicModel *model = [[TopicModel alloc]initWith:itemDic];
            [self.topicList addObject:model];
        }
        return;
    }
    
    if ([key isEqualToString:@"sortList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            SortModel *model = [[SortModel alloc]initWith:itemDic];
            [self.sortList addObject:model];
        }
        return;
    }

    
    if ([key isEqualToString:@"mediaReport"] || [key isEqualToString:@"mediaReport " ]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            MediaRepMortModel *model = [[MediaRepMortModel alloc]initWith:itemDic];
            [self.mediaList addObject:model];
        }
        
        return;
    }
    if ([key isEqualToString:@"honorList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            HonorModel *model = [[HonorModel alloc]initWith:itemDic];
            [self.honorList addObject:model];
        }
        return;
    }
    
    if ([key isEqualToString:@"hotNews"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            HotNewsModel *model = [[HotNewsModel alloc]initWith:itemDic];
            [self.hotNews addObject:model];
        }
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation BannerModel

+ (NSString *)primaryKey{
    return @"itemid";
}

@end

@implementation TopicModel

+ (NSString *)primaryKey{
    return @"itemid";
}

@end

@implementation SortModel

+ (NSString *)primaryKey{
    return @"sortid";
}

@end

@implementation MediaRepMortModel

+ (NSString *)primaryKey{
    return @"itemid";
}

@end

@implementation HonorModel

+ (NSString *)primaryKey{
    return @"imgpath";
}

@end
@implementation HotNewsModel

+ (NSString *)primaryKey{
    return @"title";
}

@end
