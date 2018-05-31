//
//  WBFenqiSelecView.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBFenqiSelecView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tabFenQi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectState;

@end
