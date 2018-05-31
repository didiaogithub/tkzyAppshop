
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
    self.messTitle.text = model.name;
    self.messInfo.text = model.title;
    self.messTime.text = model.time;
}
@end
