//
//  ODOrderInfoViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface ODOrderInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *labOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *labZhifuNo;
@property (weak, nonatomic) IBOutlet UILabel *labPayTime;
@property (weak, nonatomic) IBOutlet UILabel *labWuliu;

@property (weak, nonatomic) IBOutlet UILabel *labWuliuNo;
-(void)loadData:(OrderDetailModel *)model;
@end
