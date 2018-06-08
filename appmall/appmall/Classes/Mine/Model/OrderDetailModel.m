//
//  OrderDetailModel.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "OrderDetailModel.h"



@implementation GoodSmodel



@end




@implementation LogisticsModel



@end

@implementation OrderDetailModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"goods"]) {
        
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
        if ([value isKindOfClass:[NSString class]]) {
            self.goods = itemArray;
            return;
        }
        for (NSDictionary *itemDic in value) {
            GoodSmodel *model = [[GoodSmodel alloc]initWith:itemDic];
            [itemArray addObject:model];
        }
        self.goods = itemArray;
        return;
    }
    if ([key isEqualToString:@"logistics"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.logistics = nil;
            return;
        }
        self.logistics = [[LogisticsModel alloc]initWith:value];
        return;
    }
    [super setValue:value forKey:key];
}

//订单状态（0：已取消；1：未付款；2：已付款； 3：已收货，4：正在退货， 5：退货成功，6：已完成，7：已发货 99：全部）

-(NSString *)getOrderTitleInfo{
    NSString *title;
    switch ([self.status integerValue]) {
        case 0:
            title = @"订单已取消";
            break;
        case 1:
            title =@"等待买家付款";
            break;
        case 2:
            title = @"等待卖家发货";
            break;
        case 3:
            title = @"已确认收货";
            break;
        case 4:
            title =@"正在退货";
            break;
        case 5:
            title = @"退货成功";
            break;
        case 6:
            title = @"交易完成";
            break;
        case 7:
            title = @"等待买家确认收货";
            break;

    }
     return title;
}

@end
