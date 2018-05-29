//
//  ODWuliuCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface ODWuliuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTopTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgLine;
@property (weak, nonatomic) IBOutlet UILabel *labBottomTitle;
@property (weak, nonatomic) IBOutlet UILabel *labBottomLine;

-(void)loadLogData:(OrderDetailModel *)model;
-(void)loadAddData:(OrderDetailModel *)model;
@end
