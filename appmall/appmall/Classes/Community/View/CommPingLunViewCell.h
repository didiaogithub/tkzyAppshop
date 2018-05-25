//
//  CommPingLunViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommPingLunModel.h"

@interface CommPingLunViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *labPinglun;
@property (weak, nonatomic) IBOutlet UIButton *labGood;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *labPersonNum;
@property (weak, nonatomic) IBOutlet UIButton *btnComDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottom;

-(void)refreshData:(CommPingLunModel *)model;
@end
