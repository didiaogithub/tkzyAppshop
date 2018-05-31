
//
//  MessageListViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageListViewCell.h"

@implementation MessageListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)loadData:(MessagModel *)model{
    switch ([model.messageType integerValue]) {
        case 0:
            [self.imageView setImage:[UIImage imageNamed:@"通知"]];
            break;
        case 1:
            [self.imageView setImage:[UIImage imageNamed:@"物流提醒"]];
            break;
        case 2:
            [self.imageView setImage:[UIImage imageNamed:@"通知"]];
            break;
        case 3:
            [self.imageView setImage:[UIImage imageNamed:@"分期付款"]];
            break;
        case 4:
            [self.imageView setImage:[UIImage imageNamed:@"发票管理"]];
            break;
            
        default:
            break;
    }
    self.messTitle.text = model.name;
    self.messInfo.text = model.title;
    self.messTime.text = model.time;
}
@end
