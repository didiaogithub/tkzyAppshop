//
//  SQQKTableCell.h
//  appmall
//
//  Created by majun on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SQQKTableCellDelegate <NSObject>
- (void)showSQQKView;
@end
@interface SQQKTableCell : UITableViewCell

/**  delegate*/
@property (nonatomic, weak) id<SQQKTableCellDelegate> delegate;

@end
