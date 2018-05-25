//
//  MyInvoicesCheckFailCell.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInvoicesModel.h"
@protocol MyInvoicesCheckFailCellDelegate<NSObject>
- (void)jumpAddInvoicesDataViewController;
@end
@interface MyInvoicesCheckFailCell : UITableViewCell
- (IBAction)jumpAddMyInvoicesDetailAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *fpttLab;
@property (weak, nonatomic) IBOutlet UILabel *shLab;
@property (weak, nonatomic) IBOutlet UILabel *failreasonLab;
/**  delegate*/
@property (nonatomic, weak) id<MyInvoicesCheckFailCellDelegate> delegate;
- (void)refreshData:(MyInvoicesModel *)model;
@end
