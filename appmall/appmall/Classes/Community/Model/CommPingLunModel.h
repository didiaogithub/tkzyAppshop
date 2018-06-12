//
//  CommPingLunModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"



@interface CommcommentList :BaseModel

@property (nonatomic,strong)NSString * _id;
@property (nonatomic,strong)NSString * customerid;
@property (nonatomic,strong)NSString * time;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * head;
@property (nonatomic,strong)NSString * praise;
@property(nonatomic,copy)NSString * ispraise;
-(CGFloat)getCellHeight;
@end

@interface CommPingLunModel : BaseModel

@property (nonatomic,strong)NSString * _id;
@property (nonatomic,strong)NSString * customerid;
@property (nonatomic,strong)NSString * time;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * head;
@property (nonatomic,strong)NSString * praise;
@property(nonatomic,copy)NSString * ispraise;
@property(nonatomic,strong)NSMutableArray<CommcommentList *> * comments;
-(CGFloat)getCellHeight;
-(CGFloat)getCellHeightNoComment;
@end
