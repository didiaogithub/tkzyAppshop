//
//  OrderBottomView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/8/10.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderBottomViewDelegate <NSObject>

-(void)bottomViewButtonClicked:(UIButton *)button;

@end

@interface OrderBottomView : UIView
@property(nonatomic,weak)id<OrderBottomViewDelegate>delegate;
@property(nonatomic,strong)UIButton *allSelectedButton;
/**总计*/
/**  合计*/
@property (nonatomic, strong)UILabel *LabTotal;
@property(nonatomic,strong)UILabel *realPayMoneyLable;
@property(nonatomic,strong)UIButton *nowGoToBuyButton;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UIButton *collectedButton;
@property(nonatomic,strong)UILabel *textLable;
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type;

@end
