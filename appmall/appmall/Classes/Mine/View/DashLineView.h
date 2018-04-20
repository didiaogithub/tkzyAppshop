//
//  DashLineView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/18.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashLineView : UIView

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end
