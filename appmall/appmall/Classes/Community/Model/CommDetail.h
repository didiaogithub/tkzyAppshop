//
//  CommDetail.h
//  appmall
//
//  Created by 阿兹尔 on 2018/6/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"
#import "CommPingLunModel.h"
@interface CommDetail : BaseModel
@property(nonatomic,copy)NSString * _id;
@property(nonatomic,copy)NSString * praisenum;
@property(nonatomic,copy)NSString * path1;
@property(nonatomic,strong)NSMutableArray<CommcommentList *> * comments;
@property(nonatomic,copy)NSString * head;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * forwardnum;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * path2;
@property(nonatomic,copy)NSString * path3;
@property(nonatomic,copy)NSString * path4;
@property(nonatomic,copy)NSString * commentnum;
@property(nonatomic,copy)NSString * ispraise;
@property(nonatomic,copy)NSString * customerid;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * content;
-(CGFloat)getCellHeight;
-(NSMutableArray *)getImgArray;
@end
