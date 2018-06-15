//
//  GoodSdetailHeaderViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommHeaderViewCell.h"
#import "ImageCollViewCell.h"
#import "RootNavigationController.h"
#define  KImageCollViewCell @"ImageCollViewCell"

@interface CommHeaderViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CommDetail *commDetail;
}
@end

@implementation CommHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:KImageCollViewCell bundle:nil] forCellWithReuseIdentifier:KImageCollViewCell];
    self.bannerCollectionView.pagingEnabled = YES;
    self.bannerCollectionView.delegate = self;
    self.bannerCollectionView.dataSource = self;
    [self.bannerCollectionView setCollectionViewLayout:[self getLayoutRecommend]];
    self.labBannerNum.layer.cornerRadius = self.labBannerNum.mj_h / 2;
    self.labBannerNum.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadDataWithModel:(CommDetail * )model{
    commDetail = model;
    if (model.getImgArray.count == 0) {
        _heightImg.constant = 0;
        self.bannerCollectionView.hidden = YES;
    }else{
        _heightImg.constant = 300;
        self.bannerCollectionView.hidden = NO;
    }
    self.bannerCollectionView.delegate = self;
    self.bannerCollectionView.dataSource = self;
     [self.bannerCollectionView reloadData];
        self.labBannerNum.text = [NSString stringWithFormat:@"1/%ld",commDetail.getImgArray.count];
    self.labComm.text = [NSString stringWithFormat:@"评论%@",model.commentnum];
    self.labGood.text = [NSString stringWithFormat:@"点赞%@",model.praisenum];
    self.labShare.text = [NSString stringWithFormat:@"分享%@",model.forwardnum];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.path1]];
    self.labContent.text = model.content;
    self.labTitle.text = model.title;
    self.labTime.text = model.time;
    self.labName.text = model.name;
}

-(UICollectionViewFlowLayout *)getLayoutRecommend{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.itemSize = CGSizeMake(KscreenWidth, self.bannerCollectionView.mj_h) ;
    return customLayout;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  commDetail.getImgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KImageCollViewCell forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:commDetail.getImgArray[indexPath.row]]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger num = scrollView.contentOffset.x / KscreenWidth + 1;
    self.labBannerNum.text = [NSString stringWithFormat:@"%ld/%ld",num,commDetail.getImgArray.count];
}
-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
   [ [self getCurrentVC] presentViewController:welcomeNav animated:YES completion:nil];
    
}


@end
