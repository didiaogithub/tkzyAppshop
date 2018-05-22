//
//  RecommendCollectionViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "CollegeCollectionViewCell.h"

@interface CollegeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UILabel *labWeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTitleDisBottom;

@end

@implementation CollegeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)loadCourseList:(CourseListModel *)model{
    [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.labTitle.text = model.name;
}
-(void)loadTeacherList:(TeacherListModel *)model{
    [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.labTitle.text = model.name;
    self.labPrice.text = model.level;
}
-(void)loadLookList:(LookListModel *)model{
    [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.labTitle.text = model.name;
}
-(void)isShowPrice:(BOOL)show{
    if (!show) {
        self.labTitleDisBottom.constant = -20;
        self.labPrice.hidden = YES;
        self.labWeight.hidden = YES;
    }else{
        self.labTitleDisBottom.constant = 10;
        self.labPrice.hidden = NO;
        self.labWeight.hidden = NO;
    }
}

@end
