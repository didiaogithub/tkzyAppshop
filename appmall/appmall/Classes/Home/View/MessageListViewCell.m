
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
    _LabRed.hidden = YES;
    _LabRed.layer.masksToBounds = YES;
    _LabRed.layer.cornerRadius = 13 * 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)loadData:(MessagModel *)model{
    
    
    int gfcount = [CKJPushManager manager].gfMessageCount;
    int wlcount = [CKJPushManager manager].wlMessageConut;
    int ddcount = [CKJPushManager manager].ddMessageCount;
    int fqcount = [CKJPushManager manager].fqMessageCount;
    int fpcount = [CKJPushManager manager].fpMessageCount;
    switch ([model.messageType integerValue]) {
        case 0:
            [self.imageView setImage:[UIImage imageNamed:@"通知"]];
            if (gfcount > 0) {
                _LabRed.text = [NSString stringWithFormat:@"%d",gfcount];
                _LabRed.hidden = NO;
            }
            break;
        case 1:
            [self.imageView setImage:[UIImage imageNamed:@"物流提醒"]];
            if (wlcount > 0) {
                _LabRed.text = [NSString stringWithFormat:@"%d",wlcount];
                _LabRed.hidden = NO;
            }
            break;
        case 2:
            [self.imageView setImage:[UIImage imageNamed:@"订单提醒"]];
            if (ddcount > 0) {
                _LabRed.text = [NSString stringWithFormat:@"%d",ddcount];
                _LabRed.hidden = NO;
            }
            break;
        case 3:
            [self.imageView setImage:[UIImage imageNamed:@"分期付款"]];
            if (fqcount > 0) {
                _LabRed.text = [NSString stringWithFormat:@"%d",fqcount];
                _LabRed.hidden = NO;
            }
            break;
        case 4:
            [self.imageView setImage:[UIImage imageNamed:@"发票管理"]];
            if (fpcount > 0) {
                _LabRed.text = [NSString stringWithFormat:@"%d",fpcount];
                _LabRed.hidden = NO;
            }
            break;
            
        default:
            break;
    }
    self.messTitle.text = model.name;
    self.messInfo.text = model.title;
    self.messTime.text = model.time;
}


@end
