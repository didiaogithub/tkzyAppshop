//
//  TKHomeDataModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/4/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModelRoot.h"

@interface BannerModel:BaseModelRoot

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *link;
@property NSString *activityid ;

@end
RLM_ARRAY_TYPE(BannerModel)


@interface TopicModel:BaseModelRoot

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *itemname;
@property NSString *spec;
@property NSString *link;
@property NSString *price;
@property NSString *activityid ;
@property NSString *auth_msg ;
@property NSString *auth ;

@end
RLM_ARRAY_TYPE(TopicModel)


@interface SortModel:BaseModelRoot

@property NSString *sortid;
@property NSString *imgpath;
@property NSString *sortname;
@end

RLM_ARRAY_TYPE(SortModel)

@interface MediaRepMortModel:BaseModelRoot

@property NSString *itemid;
@property NSString *imgpath;
@property NSString *link;
@property NSString *time;
@property NSString *title;

@end
RLM_ARRAY_TYPE(MediaRepMortModel)

@interface HonorModel:BaseModelRoot

@property NSString *imgpath;
@property NSString *title;

@end
RLM_ARRAY_TYPE(HonorModel)

@interface HotNewsModel:BaseModelRoot

@property NSString *link;
@property NSString *title;

@end
RLM_ARRAY_TYPE(HotNewsModel)



@interface TKHomeDataModel : BaseModelRoot
@property NSString *modelId;
@property RLMArray  <BannerModel*><BannerModel> *bannerList;
@property RLMArray    <TopicModel *><TopicModel> *topicList;
@property RLMArray   <SortModel *><SortModel>*sortList;
@property RLMArray   <MediaRepMortModel *><MediaRepMortModel>*mediaList;
@property RLMArray   <HonorModel *><HonorModel>*honorList;
@property RLMArray  <HotNewsModel *><HotNewsModel> *hotNews;

@end


