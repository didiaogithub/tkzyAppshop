//
//  GoodDetailModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodDetailModel.h"

@implementation GoodDetailModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"banner"]) {
        self.banner = value;
        return;
    }
    if ([key isEqualToString:@"commentList"]) {
        NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in value) {
            GoodCommentModel *model = [[GoodCommentModel alloc]initWith:itemDic];
            [itemList addObject:model];
        }
        self.commentList  = itemList;
        return;
    }
    [super setValue:value   forKey:key];
}
@end


@implementation GoodCommentModel

-(CGFloat)getCellHeight{
    CGFloat imgHeight = 49;
 
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return  imgHeight + labHeight;
}

@end
