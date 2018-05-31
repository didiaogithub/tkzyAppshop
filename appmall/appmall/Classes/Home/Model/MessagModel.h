//
//  MessagModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface MessagModel : BaseModel
@property(nonatomic,strong)NSString *messageType;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *title;
@end

@interface MessagDetailModel : BaseModel
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *title;
@end

@interface MessagDetailOffModel : BaseModel
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *msgId;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *title;
-(CGFloat)getCellHeight;
@end
