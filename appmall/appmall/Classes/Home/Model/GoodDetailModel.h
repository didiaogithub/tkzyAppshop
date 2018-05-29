//
//  GoodDetailModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface GoodCommentModel :BaseModel
@property(nonatomic,strong)NSString *commentid;
@property(nonatomic,strong)NSString *smallname;
@property(nonatomic,strong)NSString *head;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
-(CGFloat)getCellHeight;
@end

@interface GoodDetailModel : BaseModel
@property(nonatomic,strong)NSString *itemid;
@property(nonatomic,strong)NSArray  *banner;
@property(nonatomic,strong)NSString *goodname;
@property(nonatomic,strong)NSString *iscollect;
@property(nonatomic,strong)NSString *goodsdetail;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *commentnum;
@property(nonatomic,strong)NSString *satisfactionRate;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *no;
@property(nonatomic,strong)NSString *supplierid;
@property(nonatomic,strong)NSArray<GoodCommentModel *> *commentList;
@end
