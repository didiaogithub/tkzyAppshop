//
//  CommListModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"



@interface CommListModelItem : BaseModel


@property NSString *commentnum;
@property NSString *customerid;
@property NSString *del;
@property NSString *forwardnum;
@property NSString *head;
@property NSString *_id;
@property NSString *ispublish;
@property NSString *content;
@property NSString *istop;
@property NSString *itemid;
@property NSString *name;
@property NSString *path1;
@property NSString *path2;
@property NSString *path3;
@property NSString *path4;
@property NSString *praisenum;
@property NSString *time;
-(CGFloat)getCellHeight;
@end
RLM_ARRAY_TYPE(CommListModelItem)

@interface CommListModel : BaseModel
@property RLMArray  <CommListModelItem*><CommListModelItem> *commList;
@property NSString *commId;

@end
