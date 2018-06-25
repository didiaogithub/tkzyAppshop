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
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong) UICollectionViewFlowLayout *customLayoutRecom;
@property(nonatomic,strong) UICollectionViewFlowLayout *customLayoutHonnor;
@property(nonatomic,strong) UICollectionViewFlowLayout *customLayoutMedia;
@property(nonatomic,strong) UICollectionViewFlowLayout *customLayoutMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginViewHeight;
@property(strong,nonatomic)TKHomeDataModel  * model;

@end
@implementation RecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void )getLayoutRecommend{
    if (self.customLayoutRecom  != nil) {
        return;
    }
     self.customLayoutRecom = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    self.customLayoutRecom.minimumLineSpacing = 0;
    self.customLayoutRecom.minimumInteritemSpacing = 0;
    self.customLayoutRecom.itemSize = CGSizeMake((KscreenWidth ) / 2, AdaptedHeight(220) ) ;
}

-(void )getLayoutHonour{
    if (self.customLayoutHonnor  != nil) {
        return;
    }
    self.customLayoutHonnor = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    self.customLayoutHonnor.minimumLineSpacing = 0;
    self.customLayoutHonnor.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.customLayoutHonnor.minimumInteritemSpacing = 0;
    self.customLayoutHonnor.itemSize = CGSizeMake(AdaptedHeight(220)  , AdaptedHeight(180) ) ;
}

-(void )  getLayoutMenu{
    if (self.customLayoutMenu  != nil) {
        return;
    }
    self.customLayoutMenu = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    self.customLayoutMenu.minimumLineSpacing = 0;
    self.customLayoutMenu.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.customLayoutMenu.minimumInteritemSpacing = 0;
    self.customLayoutMenu.itemSize = CGSizeMake(KscreenWidth /4 , 96) ;
}

-(void )getLayoutMidea{
    if (self.customLayoutMedia  != nil) {
        return;
    }
    self.customLayoutMedia = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    self.customLayoutMedia.minimumLineSpacing = 0;
    self.customLayoutMedia.minimumInteritemSpacing = 0;
    self.customLayoutMedia.itemSize = CGSizeMake((KscreenWidth - 2 ) , AdaptedHeight(221 - 50) ) ;
}

-(CGFloat)getCollectionHeight:(NSInteger)index{
    switch (index) {
        case 0:
            return 187.0 / 375.0 * KscreenWidth;
            break;
        case 1:
            return 96;
            break;
        case 2:
            return AdaptedHeight(225) * 2 + 53;
            break;
        case 3:
             return AdaptedHeight(235) ;
            
            break;
        case 4:
            
            return AdaptedHeight(224) ;
            
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
    if (model == nil) {
        return;
    }
    self.model = model;
    self.selectIndex = index;
    self.collectionViewItem.backgroundColor = [UIColor whiteColor];
    self.collectionViewItem.dataSource = self;
    self.collectionViewItem.delegate = self;
    [self.collectionViewItem registerNib:[UINib nibWithNibName:KRecommendCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KRecommendCollectionViewCell];
    [self.collectionViewItem registerNib:[UINib nibWithNibName:KMenuCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KMenuCollectionViewCell];
    if(index== 1){
     
        [self getLayoutMenu];
        [self.collectionViewItem setCollectionViewLayout:self.customLayoutMenu];
        [self isShowTopView:NO];
    }else if(index == 2){
    
        [self getLayoutRecommend];
        self.labTitle.text = @"为你推荐";
        [self.collectionViewItem setCollectionViewLayout:self.customLayoutRecom];
        [self isShowTopView:YES];
    }else if(index == 3){
      
        [self getLayoutMidea];
    
        self.labTitle.text = @"媒x体报道";
        @try {
            [self.collectionViewItem setCollectionViewLayout:self.customLayoutMedia];
        } @catch (NSException *e) {
            NSLog(@"++++++++++++++++++++++++++++=haha");
        } @finally {
        }

        [self isShowTopView:YES];
    }else if(index == 4){
        [self getLayoutHonour];
        self.labTitle.text = @"企业荣誉";
        [self.collectionViewItem setCollectionViewLayout:self.customLayoutHonnor];
        [self isShowTopView:YES];
    }
    [self.collectionViewItem reloadData];
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
    return 0;
    
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
        cell.delegate = self.delegate;
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
