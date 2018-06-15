//
//  CommDetail.m
//  appmall
//
//  Created by 阿兹尔 on 2018/6/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommDetail.h"

@implementation CommDetail

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"comments"] ||[key isEqualToString:@"comment"]) {
        NSMutableArray *commentLsit = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in value) {
            CommcommentList *model = [[CommcommentList alloc]initWith:itemDic];
            [commentLsit addObject:model];
        }
        self.comments = commentLsit;
    }else{
        [super setValue:value forKey:key];
    }
}

-(CGFloat)getCellHeight{
    CGFloat height = 0;
    if (IsNilOrNull(self.path1) &&IsNilOrNull(self.path2)&& IsNilOrNull(self.path3)&&IsNilOrNull(self.path4)) {
        
    }else{
        height = 300;
    }
    height += 62;
    height += [self.title boundingRectWithSize:CGSizeMake(KscreenWidth -18,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    height += [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    height += 60;
    return height;
}

-(NSMutableArray *)getImgArray{
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
    if (!IsNilOrNull(self.path1)) {
        [itemArray addObject:self.path1];
    }
    
    if (!IsNilOrNull(self.path2)) {
        [itemArray addObject:self.path2];
    }
    
    if (!IsNilOrNull(self.path3)) {
        [itemArray addObject:self.path3];
    }
    
    if (!IsNilOrNull(self.path4)) {
        [itemArray addObject:self.path4];
    }
    return itemArray;
}

@end
