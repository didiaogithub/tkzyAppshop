//
//  CommPingLunModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommPingLunModel.h"

@implementation CommcommentList

-(void)setValue:(id)value forKey:(NSString *)key{
    
}



@end

@implementation CommPingLunModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"comment"]) {
        NSMutableArray *commentLsit = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in value) {
            CommcommentList *model = [[CommcommentList alloc]initWith:itemDic];
            [commentLsit addObject:model];
        }
        self.comment = commentLsit;
    }else{
        [super setValue:value forKey:key];
    }
}

-(CGFloat)getCellHeight{
    CGFloat imgHeight = 95;
    if (self.comment.count > 10) {
        imgHeight  += 32;
    }
  
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  imgHeight + labHeight;
}



@end
