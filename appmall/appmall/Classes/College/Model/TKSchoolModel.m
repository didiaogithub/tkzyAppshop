//
//  TKSchoolModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TKSchoolModel.h"
@implementation CourseListModel
+ (NSString *)primaryKey{
    return @"courseId";
}
@end
@implementation BannerListModel
+ (NSString *)primaryKey{
    return @"detailUrl";
}
@end
@implementation TeacherListModel
+ (NSString *)primaryKey{
    return @"teacherId";
}
@end
@implementation LookListModel
+ (NSString *)primaryKey{
    return @"courseId";
}
@end

@implementation TKSchoolModel
+ (NSString *)primaryKey{
    return @"modelId";
}

-(void)setValue:(id)value forKey:(NSString *)key{
    key  = [key stringByReplacingOccurrencesOfString:@" " withString:@""];;
    if ([key isEqualToString:@"courseList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            CourseListModel *model = [[CourseListModel alloc]initWith:itemDic];
            [self.courseList addObject:model];
        }
        return;
    }
    
    if ([key isEqualToString:@"bannerList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            BannerListModel *model = [[BannerListModel alloc]initWith:itemDic];
            [self.bannerList addObject:model];
        }
        return;
    }
    
    if ([key isEqualToString:@"teacherList"]) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            TeacherListModel *model = [[TeacherListModel alloc]initWith:itemDic];
            [self.teacherList addObject:model];
        }
        return;
    }
    
    
    if ([key isEqualToString:@"lookList"] ) {
        NSArray *bannerList = value;
        for (NSDictionary * itemDic in bannerList) {
            LookListModel *model = [[LookListModel alloc]initWith:itemDic];
            [self.lookList addObject:model];
        }
        return;
    }
    [super setValue:value forKey:key];
}

@end
