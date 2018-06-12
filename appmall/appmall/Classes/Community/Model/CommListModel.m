//
//  CommListModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommListModel.h"


@implementation CommListModel

+ (NSString *)primaryKey{
    return @"commId";
}


@end

@implementation CommListModelItem

+ (NSString *)primaryKey{
    return @"_id";
    
    
}

-(CGFloat)getCellHeight{
    CGFloat imgHeight = (KscreenWidth - 76 - 20) / 3 + 5;
    if (!IsNilOrNull(self.path4)){
        imgHeight = imgHeight * 2 + 5;
    }
    if (IsNilOrNull(self.path1)) {
        imgHeight = 0;
    }
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 76,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return  116 + imgHeight + labHeight;
}

@end
