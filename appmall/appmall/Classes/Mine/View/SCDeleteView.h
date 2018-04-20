//
//  SCDeleteView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDeleteView;
@protocol SCDeleteViewDelegate<NSObject>

-(void)deleteBtnView:(SCDeleteView*)deleteBtnView deleteBtnClick:(id)parameter;

@end


@interface SCDeleteView : UIView

@property (nonatomic, weak) id<SCDeleteViewDelegate> delegate;

@end

