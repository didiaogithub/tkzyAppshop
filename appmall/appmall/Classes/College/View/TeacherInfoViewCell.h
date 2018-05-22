//
//  TeacherInfoViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherListItemModel.h"

@interface TeacherInfoViewCell : UITableViewCell
-(void)refreshData:(TeacherListItemModel *)model;
@end
