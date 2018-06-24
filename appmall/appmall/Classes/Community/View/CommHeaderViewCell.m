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
    self.imgIcon.layer.cornerRadius  =self.imgIcon.mj_h / 2;
    self.imgIcon.layer.masksToBounds = YES;
    self.bannerCollectionView.delegate = self;
    self.bannerCollectionView.dataSource = self;
     [self.bannerCollectionView reloadData];
        self.labBannerNum.text = [NSString stringWithFormat:@"1/%ld",commDetail.getImgArray.count];

    [self.labComm setTitle:[NSString stringWithFormat:@"评论  %@",model.commentnum] forState:0];
    self.labGood .selected = [model.ispraise boolValue];
    [self.labGood setTitle:[NSString stringWithFormat:@"点赞  %@",model.praisenum] forState:0];
    [self.labShare setTitle:[NSString stringWithFormat:@"分享  %@",model.forwardnum] forState:0];
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"名师推荐头像"]];
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h / 2;
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h / 2;
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
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:commDetail.getImgArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"产品详情"]];
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

- (IBAction)actionGood:(id)sender {
    [self.delegate actionCommDetailGood:commDetail];
    
}

- (IBAction)actionComm:(id)sender {
    [self.delegate actionCommDetailComm:commDetail];
}

- (IBAction)actionShare:(id)sender {
    [self.delegate actionCommDetailShare:commDetail];
}

@end
