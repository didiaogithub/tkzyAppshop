//
//  AmortizationLoanCell.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stag.h"
@interface AmortizationLoanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *daiBtn;
- (void)refreshData:(Stag *)model;


@end
