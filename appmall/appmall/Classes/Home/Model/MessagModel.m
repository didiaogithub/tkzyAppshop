//
//  MessagModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MessagModel.h"

@implementation MessagModel

@end
@implementation MessagDetailModel

@end
@implementation MessagDetailOffModel
-(CGFloat)getCellHeight{
    CGFloat imgHeight = 136;
    CGFloat labHeight = [self.content boundingRectWithSize:CGSizeMake(KscreenWidth - 130,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    if (labHeight > 55) {
        return  imgHeight + labHeight;
    }else{
          return  imgHeight + 55;
    }
}
@end
