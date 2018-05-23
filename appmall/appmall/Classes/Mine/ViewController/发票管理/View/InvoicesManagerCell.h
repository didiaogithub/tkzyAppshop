//
//  InvoicesManagerCell.h
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InvoicesManagerCellDelegate<NSObject>
- (void)showDetail;
@end
@interface InvoicesManagerCell : UITableViewCell
- (IBAction)showDetailAction:(UIButton *)sender;
/**  delegate*/
@property (nonatomic, weak) id<InvoicesManagerCellDelegate> delegete;
@end
