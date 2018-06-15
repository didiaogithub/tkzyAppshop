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
    CGFloat imgHeight = 74;
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  imgHeight + labHeight;
}

-(CGFloat)getCellHeightCommdetail{
    CGFloat imgHeight = 81;
    if (self.comments.count > 0) {
        imgHeight  += 41;
    }
    
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  imgHeight + labHeight;
}

-(NSString *)praisenum{
    return _praise;
}

@end

@implementation CommPingLunModel

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
    CGFloat imgHeight = 81;
    if (self.comments.count > 0) {
        imgHeight  += 41;
    }
  
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  imgHeight + labHeight;
}

-(CGFloat)getCellHeightNoComment{
    CGFloat imgHeight = 81;

    
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  imgHeight + labHeight;
}


@end
