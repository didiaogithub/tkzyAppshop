//
//  AmortizationHeadView.h
//  appmall
//
//  Created by majun on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmortizationHeadViewDelegate<NSObject>
-(void)showAndHiddrenCell:(UIButton *)sender;
@end
@interface AmortizationHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)rightBtnAction:(UIButton *)sender;
/**  delegate*/
@property (nonatomic, weak) id<AmortizationHeadViewDelegate> delegate;


@end
