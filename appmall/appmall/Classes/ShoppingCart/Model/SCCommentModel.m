//
//  SCCommentModel.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCCommentModel.h"

@implementation SCCommentModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"list"]) {
        NSMutableArray *itemArray  = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *itemDic in value) {
            SCCommentImgModel *model = [[SCCommentImgModel alloc]initWith:itemDic];
            [itemArray addObject:model];
        }
        self.list = itemArray;
        return;
    }
 
    [super setValue:value forKey:key];
}


@end

@implementation SCCommentImgModel
-(NSMutableArray *)imgPathArray{
    NSMutableArray *item = [NSMutableArray arrayWithCapacity:0];
    if (self.path1 .length > 10) {
        [item addObject:self.path1];
    }
    if (self.path2 .length > 10) {
        [item addObject:self.path2];
    }
    if (self.path3 .length > 10) {
        [item addObject:self.path3];
    }
    return item;
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"itemscore"]) {
        self.itemscore = value;
        return;
    }
    [super setValue:value forKey:key];
}
@end
