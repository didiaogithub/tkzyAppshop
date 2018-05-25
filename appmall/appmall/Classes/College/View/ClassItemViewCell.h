//
//  ClassItemViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListModel.h"

@interface ClassItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UILabel *classDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

-(void)refreshDataWIthModel:(ClassListModel *)model;
@end
