//
//  MessageDetailViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagModel.h"

@interface MessageDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *Cview;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
-(void)loadData:(MessagDetailModel *)model;
@end
