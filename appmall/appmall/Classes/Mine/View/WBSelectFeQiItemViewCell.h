//
//  WBSelectFeQiItemViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanRuleListModel.h"
@protocol WBSelectFeQiItemViewCellDelegate <NSObject> //当点击Button，实现这个协议的TableView会得到这个Button的引用
//然后将上次引用的Button取消选择   比如_lastSelectedButton.selected = NO;
- (void)tableCellButtonDidSelected:(UIButton *)button;

@end
@interface WBSelectFeQiItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *yuefLab;
@property (weak, nonatomic) IBOutlet UILabel *yingfLab;
@property (weak, nonatomic) IBOutlet UILabel *haikLab;
/**  delagate*/
@property (nonatomic, weak) id<WBSelectFeQiItemViewCellDelegate> delegate;
- (void)refreshData:(LoanRuleListModel *)model;
@end
