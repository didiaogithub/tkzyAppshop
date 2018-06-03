//
//  MyInvoicesCell.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInvoicesModel.h"

@protocol MyInvoicesCellDelegate<NSObject>
- (void)tableCellButtonDidSelected:(MyInvoicesModel *)model;
@end
@interface MyInvoicesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *fpttLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *shLab;
/**  delegate*/
@property (nonatomic, weak) id<MyInvoicesCellDelegate> delegate;

- (void)refreshData:(MyInvoicesModel *)model;
@end
