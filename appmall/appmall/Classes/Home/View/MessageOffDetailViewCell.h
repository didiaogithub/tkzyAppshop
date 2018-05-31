//
//  MessageDetailViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagModel.h"

@interface MessageOffDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
-(void)loadData:(MessagDetailOffModel *)model;
@end
