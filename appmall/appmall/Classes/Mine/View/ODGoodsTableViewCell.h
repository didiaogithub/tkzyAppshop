//
//  ODGoodsTableViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface ODGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labGoodName;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labGoodInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

-(void)loadData:(GoodSmodel *)model;
@end
