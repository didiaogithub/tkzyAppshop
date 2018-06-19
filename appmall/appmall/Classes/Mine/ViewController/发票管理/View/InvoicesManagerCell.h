//
//  InvoicesManagerCell.h
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ordersheet.h"
@protocol InvoicesManagerCellDelegate<NSObject>
- (void)showDetail:(UIButton *)sender;
@end
@interface InvoicesManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *labGG;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *labNo;

/**  delegate*/
@property (nonatomic, weak) id<InvoicesManagerCellDelegate> delegete;

- (void)refreshData:(Ordersheet *)model;

@end
