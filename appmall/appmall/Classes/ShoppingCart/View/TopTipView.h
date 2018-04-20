//
//  TopTipView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopTipView;

@protocol TopTipViewDelegate<NSObject>

- (void)topTipView:(TopTipView*)topView closeTip:(UIButton*)btn;

@end

@interface TopTipView : UIView

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, weak) id<TopTipViewDelegate> delegate;

@end
