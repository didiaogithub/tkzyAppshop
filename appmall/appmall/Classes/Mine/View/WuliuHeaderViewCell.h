//
//  WuliuHeaderViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBWuliuInfoVC.h"
@interface WuliuHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labOrderNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labGoodNum;
@property (weak, nonatomic) IBOutlet UILabel *labComPname;
-(void)loadData:(WuliuModel *)model;
@end
