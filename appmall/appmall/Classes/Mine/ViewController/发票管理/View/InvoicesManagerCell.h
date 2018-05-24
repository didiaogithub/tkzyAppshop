//
//  InvoicesManagerCell.h
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InvoicesManagerCellDelegate<NSObject>
- (void)showDetail:(UIButton *)sender;
@end
@interface InvoicesManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)showDetailAction:(UIButton *)sender;
/**  delegate*/
@property (nonatomic, weak) id<InvoicesManagerCellDelegate> delegete;
@end
