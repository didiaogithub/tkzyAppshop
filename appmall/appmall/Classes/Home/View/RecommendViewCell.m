//
//  RecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RecommendViewCell.h"
#import "RecommendCollectionViewCell.h"
#define  KRecommendCollectionViewCell @"RecommendCollectionViewCell"

@interface RecommendViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

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
            return 220 * 2 + 53;
            break;
        case 1:
            return 220 * 4 + 53 ;
            
            break;
        case 2:
            
            return 220 + 53 ;
            
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)setCollection:(NSInteger )index{
    self.selectIndex = index;
    switch (index) {
        case 0:
             [_collectionViewItem setCollectionViewLayout:[self getLayoutRecommend]];
            break;
        case 1:
             [_collectionViewItem setCollectionViewLayout:[self getLayoutMidea]];
            
            break;
        case 2:
             [_collectionViewItem setCollectionViewLayout:[self getLayoutHonour]];
            break;
            
        default:
            break;
    }
    _collectionViewItem.backgroundColor = [UIColor whiteColor];
    _collectionViewItem.dataSource = self;
    _collectionViewItem.delegate = self;

    [_collectionViewItem registerNib:[UINib nibWithNibName:KRecommendCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KRecommendCollectionViewCell];
    [_collectionViewItem reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendCollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:KRecommendCollectionViewCell forIndexPath:indexPath];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionMore:(id)sender {
    [self.delegate recommendViewCellDelegateMore:self.selectIndex];
}

@end
