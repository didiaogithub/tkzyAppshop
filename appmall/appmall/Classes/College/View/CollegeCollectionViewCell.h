//
//  RecommendCollectionViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSchoolModel.h"

@interface CollegeCollectionViewCell : UICollectionViewCell
-(void)loadCourseList:(CourseListModel *)model;
-(void)loadTeacherList:(TeacherListModel *)model;
-(void)loadLookList:(LookListModel *)model;
@end
