//
//  BaseModel.h
//  happyLottery
//
//  Created by 壮壮 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
@interface BaseModelRoot : RLMObject


-(id)initWith:(NSDictionary*)dic;
@end