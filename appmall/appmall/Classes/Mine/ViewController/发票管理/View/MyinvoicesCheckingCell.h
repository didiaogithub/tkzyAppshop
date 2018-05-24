//
//  MyinvoicesCheckingCell.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInvoicesModel.h"
@interface MyinvoicesCheckingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *fpttLab;
@property (weak, nonatomic) IBOutlet UILabel *shLab;
- (void)refreshData:(MyInvoicesModel *)model;
@end
