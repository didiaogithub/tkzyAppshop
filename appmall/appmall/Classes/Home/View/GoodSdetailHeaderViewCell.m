//
//  GoodSdetailHeaderViewCell.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodSdetailHeaderViewCell.h"
#import "ImageCollViewCell.h"
#import "RootNavigationController.h"
#define  KImageCollViewCell @"ImageCollViewCell"

@interface GoodSdetailHeaderViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    GoodDetailModel *selfmodel;
}
@end

@implementation GoodSdetailHeaderViewCell

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

-(void)loadDataWithModel:(GoodDetailModel *)model{
    selfmodel = model;
    self.labBannerNum.text = [NSString stringWithFormat:@"1/%ld",model.banner.count];
    [self.bannerCollectionView reloadData];
    if (IsNilOrNull(model.spec)) {
        model.spec = @"";
    }
    self.labTime.text = [NSString stringWithFormat:@"规格：%@kg",model.spec];
    self.labGoodName.text = model.goodname;
    if (IsNilOrNull(model.price)) {
        model.price = @"";
    }
    self.labPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.labCollect.selected = [model.iscollect boolValue];
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
    return  selfmodel.banner.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KImageCollViewCell forIndexPath:indexPath];
    NSDictionary *imgDic = selfmodel.banner[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgDic[@"picpath"]]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger num = scrollView.contentOffset.x / KscreenWidth + 1;
    self.labBannerNum.text = [NSString stringWithFormat:@"%ld/3",num];
}
-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
   [ [self getCurrentVC] presentViewController:welcomeNav animated:YES completion:nil];
    
}


- (IBAction)actionCollect:(id)sender {
    if ([[KUserdefaults objectForKey:KloginStatus] boolValue] == NO) {
        [self goWelcom];
        return;
    }
        NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
        
        [pramaDic setObject:selfmodel.itemid forKey:@"itemid"];
        
        //请求数据
    NSString *subApi;
    if ([selfmodel.iscollect boolValue] == YES) {
        subApi = Center_cancelCollection;
    }else{
        subApi = Goods_addCollection;
    }
        NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,subApi];

        [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
            NSDictionary *dic = json;
            BaseViewController *baseVC =(BaseViewController *)[self getCurrentVC];
            if ([dic[@"code"] integerValue] != 200) {
                
                [baseVC showNoticeView:@"收藏失败"];
            }else{
                if ([selfmodel.iscollect boolValue] == YES) {
                    [baseVC showNoticeView:@"取消收藏"];
                }else{
                    [baseVC showNoticeView:@"收藏成功"];
                }
                
                selfmodel.iscollect =[NSString stringWithFormat:@"%d", ![selfmodel.iscollect boolValue]];
                self.labCollect.selected = [selfmodel.iscollect boolValue];
                
            }

        } failure:^(NSError *error) {
            BaseViewController *baseVC =(BaseViewController *)[self getCurrentVC];
            if (error.code == -1009) {
                [baseVC.loadingView showNoticeView:NetWorkNotReachable];
            }else{
                [baseVC.loadingView showNoticeView:NetWorkTimeout];
            }
            
        }];
}

@end
