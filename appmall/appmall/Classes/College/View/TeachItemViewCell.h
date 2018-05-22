//
//  TeachItemViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/13.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSchoolModel.h"

@interface TeachItemViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *teacherIcon;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *teacherPostion;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

-(void)loadData:(TeacherListModel *)model;

@end
