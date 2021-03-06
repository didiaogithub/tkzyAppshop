//
//  RecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RecommendViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "MenuCollectionViewCell.h"
#define  KRecommendCollectionViewCell @"RecommendCollectionViewCell"
#define KMenuCollectionViewCell @"MenuCollectionViewCell"

@interface RecommendViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginViewHeight;
@property(strong,nonatomic)TKHomeDataModel  * model;

@end
@implementation RecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UICollectionViewFlowLayout *)getLayoutRecommend{
     UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake((KscreenWidth ) / 2, 220) ;
    return customLayout;
}

-(UICollectionViewFlowLayout *)getLayoutHonour{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake(220 , 220) ;
    return customLayout;
}

-(UICollectionViewFlowLayout *)getLayoutMenu{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake(KscreenWidth /4 , 96) ;
    return customLayout;
}

-(UICollectionViewFlowLayout *)getLayoutMidea{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake((KscreenWidth ) , 221) ;
    return customLayout;
}

-(CGFloat)getCollectionHeight:(NSInteger)index{
    switch (index) {
        case 0:
            return 187;
            break;
        case 1:
            return 96;
            break;
        case 2:
            return 220 * 2 + 53;
            break;
        case 3:
            return 220 + 53 ;
            
            break;
        case 4:
            
            return 220 + 53 ;
            
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)isShowTopView:(BOOL)isShow{
    if(isShow){
     
        self.topView.hidden = NO;
        self.collectionTopViewHeight.constant = 44;
        self.topMarginViewHeight.constant = 10;
    }else{
        
        self.topView.hidden = YES;
        self.collectionTopViewHeight.constant = 0;
        self.topMarginViewHeight.constant = 0;
    }
}

-(void)setCollection:(NSInteger )index andData:(TKHomeDataModel *)model{
    self.model = model;
    self.selectIndex = index;
    _collectionViewItem.backgroundColor = [UIColor whiteColor];
    _collectionViewItem.dataSource = self;
    _collectionViewItem.delegate = self;
    [_collectionViewItem registerNib:[UINib nibWithNibName:KRecommendCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KRecommendCollectionViewCell];
    [_collectionViewItem registerNib:[UINib nibWithNibName:KMenuCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KMenuCollectionViewCell];
    if(index== 1){
        UICollectionViewLayout *itemLayout =[self getLayoutMenu];
        [_collectionViewItem setCollectionViewLayout:itemLayout];
        [self isShowTopView:NO];
    }else if(index == 2){
        self.labTitle.text = @"为你推荐";
        [_collectionViewItem setCollectionViewLayout:[self getLayoutRecommend]];
        [self isShowTopView:YES];
    }else if(index == 3){
        self.labTitle.text = @"媒体报道";
        [_collectionViewItem setCollectionViewLayout:[self getLayoutMidea]];
        [self isShowTopView:YES];
    }else if(index == 4){
        self.labTitle.text = @"企业荣誉";
        [_collectionViewItem setCollectionViewLayout:[self getLayoutHonour]];
        [self isShowTopView:YES];
    }
    [_collectionViewItem reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//
    if (self.selectIndex == 1) {
        return [self getArrayCount:self.model.sortList];
        
    }else    if (self.selectIndex ==2) {
        return [self getArrayCount:self.model.topicList];
    }else if (self.selectIndex ==  3){
        return [self getArrayCount:self.model.mediaList];
        
    }else if (self.selectIndex == 4){
        return [self getArrayCount:self.model.honorList];
        
    }
    return 1;
}

-(NSInteger )getArrayCount:(NSArray *)itemArray{
    if(itemArray  == nil || itemArray.count == 0){
        return 1;
    }else{
        return itemArray.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == 1) {
         MenuCollectionViewCell* cell= [collectionView dequeueReusableCellWithReuseIdentifier:KMenuCollectionViewCell forIndexPath:indexPath];
        [cell setItemIcom:self.model.sortList[indexPath.row]];
        return cell;
    }else{
        RecommendCollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:KRecommendCollectionViewCell forIndexPath:indexPath];
        [cell loadDataModel:self.model andIndex:indexPath andSuperSection:self.selectIndex];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate recommendViewCellClick:indexPath andTabIndex:self.selectIndex];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionMore:(id)sender {
    [self.delegate recommendViewCellDelegateMore:self.selectIndex];
}

@end
