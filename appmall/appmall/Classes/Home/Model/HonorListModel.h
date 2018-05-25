//
//  HonorListModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/5.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"


@interface HonorListModel:BaseModel

@property NSString *_description;
@property NSString *time;
@property NSString *imgpath;
@property NSString *title;

@end
RLM_ARRAY_TYPE(HonorListModel)

