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
