//
//  RecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "CollegeRootViewCell.h"
#import "CollegeCollectionViewCell.h"
#import "TeachItemViewCell.h"
#import "TeacherDetailVC.h"
#import "WebDetailViewController.h"
#define  KCollegeCollectionViewCell @"CollegeCollectionViewCell"
#define KTeachItemViewCell @"TeachItemViewCell"

@interface CollegeRootViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property TKSchoolModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@end
@implementation CollegeRootViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UICollectionViewFlowLayout *)getLayoutRecommend{
     UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake(198 * KscreenWidth / 375, AdaptedWidth(156)) ;
    return customLayout;
}

-(UICollectionViewFlowLayout *)getLayoutHonour{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake(AdaptedWidth(141) , AdaptedWidth(165)) ;
    return customLayout;
}

-(UICollectionViewFlowLayout *)getLayoutMidea{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake((KscreenWidth ) , 203 * KscreenWidth / 375) ;
    return customLayout;
}

-(CGFloat)getCollectionHeight:(NSInteger)index{
    switch (index) {
        case 0:
            return AdaptedHeight( 196 );
            break;
        case 1:
            return AdaptedHeight(222) ;
            
            break;
        case 2:
            return AdaptedHeight(258);
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)setCollection:(NSInteger )index withModel:(TKSchoolModel *)model{
    self.model = model;
    self.selectIndex = index;
    switch (index) {
        case 1:
            self.labTitle.text = @"精选课程";
             [_collectionViewItem setCollectionViewLayout:[self getLayoutRecommend]];
            break;
        case 2:
            self.labTitle.text = @"名师推荐";
             [_collectionViewItem setCollectionViewLayout:[self getLayoutHonour]];
            break;
        case 3:
            self.labTitle.text = @"每日必看";
             [_collectionViewItem setCollectionViewLayout:[self getLayoutMidea]];
            break;
            
        default:
            break;
    }
    _collectionViewItem.backgroundColor = [UIColor whiteColor];
    _collectionViewItem.dataSource = self;
    _collectionViewItem.delegate = self;
    [_collectionViewItem registerNib:[UINib nibWithNibName:KCollegeCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KCollegeCollectionViewCell];
    [_collectionViewItem registerNib:[UINib nibWithNibName:KTeachItemViewCell bundle:nil] forCellWithReuseIdentifier:KTeachItemViewCell];
    [_collectionViewItem reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectIndex == 1) {
        return _model.courseList.count == 0 ?1:_model.courseList.count;
    }else if (self.selectIndex == 2){
        return _model.teacherList.count== 0 ?1:_model.teacherList.count;
    }else if (self.selectIndex == 3){
        return _model.lookList.count== 0 ?1:_model.lookList.count;;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollegeCollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:KCollegeCollectionViewCell forIndexPath:indexPath];
    if (self.selectIndex == 1) {
        [cell loadCourseList:_model.courseList[indexPath.row]];
    }else if (self.selectIndex == 2){
        TeachItemViewCell * itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:KTeachItemViewCell forIndexPath:indexPath];
        [itemCell loadData:_model.teacherList[indexPath.row]];
        return itemCell;
    }else if ( self.selectIndex == 3){
        [cell loadLookList:_model.lookList[indexPath.row]];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionMore:(id)sender {
    [self.delegate CollegeViewCellDelegateMore:self.selectIndex];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 2) {
        TeacherDetailVC *detailVC = [[TeacherDetailVC alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.teacherId = [self.model.teacherList objectAtIndex:indexPath.row].teacherId;
       [[self getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    }else if(self.selectIndex == 1){
        WebDetailViewController *detailVC = [[WebDetailViewController alloc]init];
        detailVC.detailUrl = [NSString stringWithFormat:@"%@%@",CollectionDetail,_model.courseList [indexPath.row].courseId];
        [[self getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    }else if(self.selectIndex == 3){
        WebDetailViewController *detailVC = [[WebDetailViewController alloc]init];
//        detailVC.detailUrl =  ;
        [[self getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    }
}

@end
