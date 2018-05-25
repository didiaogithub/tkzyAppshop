//
//  InvoicesManCellFooterView.h
//  appmall
//
//  Created by majun on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InvoicesManCellFooterViewDelegate<NSObject>
- (void)showDetail:(UIButton *)sender;
@end

@interface InvoicesManCellFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/**  delegate*/
@property (nonatomic, weak) id<InvoicesManCellFooterViewDelegate> delegate;
- (IBAction)rightBtnAction:(UIButton *)sender;

@end
