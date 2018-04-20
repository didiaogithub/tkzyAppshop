//
//  UITableView+PlaceHolder.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (PlaceHolder)

-(void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;

@end
