//
//  TKHomeDataModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/4/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel:BaseModel

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *link;
@property NSString *activityid ;

@end
RLM_ARRAY_TYPE(BannerModel)


@interface TopicModel:BaseModel

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *itemname;
@property NSString *spec;
@property NSString *link;
@property NSString *price;
@property NSString *activityid ;

@end
RLM_ARRAY_TYPE(TopicModel)


@interface SortModel:BaseModel

@property NSString *sortid;
@property NSString *imgpath;
@property NSString *sortname;
@end

RLM_ARRAY_TYPE(SortModel)

@interface MediaRepMortModel:BaseModel

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *link;
@property NSString *time;
@property NSString *title;

@end
RLM_ARRAY_TYPE(MediaRepMortModel)

@interface HonorModel:BaseModel

@property NSString *imgpath;
@property NSString *title;

@end
RLM_ARRAY_TYPE(HonorModel)

@interface HotNewsModel:BaseModel

@property NSString *link;
@property NSString *title;

@end
RLM_ARRAY_TYPE(HotNewsModel)



@interface TKHomeDataModel : BaseModel
@property NSString *modelId;
@property RLMArray  <BannerModel*><BannerModel> *bannerList;
@property RLMArray    <TopicModel *><TopicModel> *topicList;
@property RLMArray   <SortModel *><SortModel>*sortList;
@property RLMArray   <MediaRepMortModel *><MediaRepMortModel>*mediaList;
@property RLMArray   <HonorModel *><HonorModel>*honorList;
@property RLMArray  <HotNewsModel *><HotNewsModel> *hotNews;

@end


