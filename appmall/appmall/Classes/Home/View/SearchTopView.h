//
//  SearchTopView.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 17/7/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchTextField : UITextField

@end

@protocol SearchTopViewDelegate <NSObject>
@optional

-(void)keyboardSearchWithString:(NSString *)searchStr;
-(void)clickBtnSearch:(UIButton *)button;

@end

@interface SearchTopView : UIView

@property(nonatomic,weak)id<SearchTopViewDelegate>delegate;
//@property(nonatomic,strong)UITextField *searchTextField;
@property(nonatomic,strong) SearchTextField *searchTextField;

@property(nonatomic,strong)UIButton *searchButton;

-(instancetype)initWithFrame:(CGRect)frame andHeight:(CGFloat)height;

@end
