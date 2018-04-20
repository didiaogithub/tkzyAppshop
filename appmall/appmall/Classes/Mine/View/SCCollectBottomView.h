//
//  SCCollectBottomView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCollectBottomViewDelegate <NSObject>

-(void)cancelCollection:(UIButton *)button;

@end

@interface SCCollectBottomView : UIView

@property(nonatomic,weak)id<SCCollectBottomViewDelegate>delegate;

@property(nonatomic,strong)UIButton *allSelectedButton;

@property(nonatomic,strong)UIButton *nowGoToBuyButton;

@end
