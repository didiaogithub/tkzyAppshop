//
//  ClassListModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface ClassListModel : BaseModel
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * picUrl;
@property(nonatomic,copy)NSString * courseId;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * duration;
@end
