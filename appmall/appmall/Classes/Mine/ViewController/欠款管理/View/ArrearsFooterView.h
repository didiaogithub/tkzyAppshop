//
//  ArrearsFooterView.h
//  appmall
//
//  Created by majun on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ArrearsFooterViewDelegate<NSObject>
- (void)leftBtnAction:(UIButton *)sender;
- (void)rightBtnAction:(UIButton *)sender;
@end
@interface ArrearsFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftAction;
@property (weak, nonatomic) IBOutlet UIButton *rightAction;
/**  delegate*/
@property (nonatomic, strong) id<ArrearsFooterViewDelegate> delegate;
- (IBAction)actionleft:(UIButton *)sender;
- (IBAction)actionright:(UIButton *)sender;

@end
