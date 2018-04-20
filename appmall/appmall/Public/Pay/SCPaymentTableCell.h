//
//  SCPaymentTableCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPaymentTableCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *leftIamgeView;
@property (nonatomic, strong) UIButton *rightButton;

@end
