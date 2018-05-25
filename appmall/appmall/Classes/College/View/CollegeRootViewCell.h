//
//  RecommendViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSchoolModel.h"

@protocol CollegeViewCellDelegate<NSObject>
-(void)CollegeViewCellDelegateMore:(NSInteger)index;
@end

@interface CollegeRootViewCell : UITableViewCell

@property(weak,nonatomic)id <CollegeViewCellDelegate>delegate;
-(void)setCollection:(NSInteger )index withModel:(TKSchoolModel *)model;
-(CGFloat)getCollectionHeight:(NSInteger)index;

@end
