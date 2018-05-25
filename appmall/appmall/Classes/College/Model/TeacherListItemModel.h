//
//  TeacherListItemModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface TeacherListItemModel : BaseModel

@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,copy)NSString * level;
@property(nonatomic,copy)NSString * avater;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * teacherId;

@end
