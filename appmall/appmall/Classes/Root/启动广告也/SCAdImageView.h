//
//  SCAdImageView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADImageViewDelegate <NSObject>

-(void)removeAdViewFromWindow;

@end

@interface SCAdImageView : UIImageView

@property (nonatomic, weak) id<ADImageViewDelegate> delegate;

+(instancetype)shareInstance;

-(void)startShowingPage;

@end
