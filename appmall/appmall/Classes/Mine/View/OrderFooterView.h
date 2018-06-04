//
//  OrderFooterView.h
//  CKYSPlatform
//
//  Created by 二壮 on 17/3/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderFooterViewDelegate <NSObject>

-(void)left0ButtonClick:(UIButton*)btn;

-(void)leftButtonClick:(UIButton*)btn;

-(void)rightButtonClick:(UIButton*)btn;


@end

@interface OrderFooterView : UIView

@property (nonatomic, weak) id<OrderFooterViewDelegate> delegate;

@property (nonatomic, copy)NSString *statustring;

@property (nonatomic, strong)UILabel *priceLable;

@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, strong)UIButton *leftButton;

@property (nonatomic, strong)UIButton *left0Button;

@property (nonatomic, copy) NSString *iscomment;


-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)statusString andHasTop:(BOOL)hasTop type:(NSString*)fromVC;

-(void)refreshButton:(NSString*)iscomment;

@end
