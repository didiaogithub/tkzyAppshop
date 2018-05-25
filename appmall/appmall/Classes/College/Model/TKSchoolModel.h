//
//  TKSchoolModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"


@interface CourseListModel :BaseModel

@property NSString *detailUrl;
@property NSString *courseId;
@property NSString *name;
@property NSString *picUrl;

@end
RLM_ARRAY_TYPE(CourseListModel)

@interface BannerListModel :BaseModel
@property NSString * detailUrl;
@property NSString *picUrl;
@end
RLM_ARRAY_TYPE(BannerListModel)

@interface TeacherListModel :BaseModel

@property NSString *picUrl;
@property NSString *avater;
@property NSString *courseId;
@property NSString *detailUrl;
@property NSString *level;
@property NSString *teacherId;
@property NSString *name;

@end
RLM_ARRAY_TYPE(TeacherListModel)

@interface LookListModel :BaseModel

@property NSString *detailUrl;
@property NSString *courseId;
@property NSString *name;
@property NSString *picUrl;

@end
RLM_ARRAY_TYPE(LookListModel)

@interface TKSchoolModel : BaseModel
@property NSString *modelId;
@property RLMArray  <CourseListModel*><CourseListModel> *courseList;
@property RLMArray    <BannerListModel *><BannerListModel> *bannerList;
@property RLMArray   <TeacherListModel *><TeacherListModel>*teacherList;
@property RLMArray   <LookListModel *><LookListModel>*lookList;

@end
