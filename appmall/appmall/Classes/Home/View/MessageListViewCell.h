//
//  MessageListViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagModel.h"

@interface MessageListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LabRed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messIcon;
@property (weak, nonatomic) IBOutlet UILabel *messInfo;
@property (weak, nonatomic) IBOutlet UILabel *messTime;
@property (weak, nonatomic) IBOutlet UILabel *messTitle;
-(void)loadData:(MessagModel *)model;
@end
