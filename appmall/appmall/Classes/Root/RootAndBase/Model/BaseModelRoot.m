//
//  BaseModel.m
//  happyLottery
//
//  Created by 壮壮 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModelRoot.h"

@implementation BaseModelRoot

-(id)initWith:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
   
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }
    if ([key isEqualToString:@"description"]) {
        key = @"_description";
    }
    [super setValue:strValue forKey:key];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"@property(nonatomic,copy)NSString * %@;",key);
}

@end
