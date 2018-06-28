//
//  RecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RecommendMediaViewCell.h"
#import "WebDetailViewController.h"
#import "MedieaListViewController.h"
@interface RecommendMediaViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labTitleInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginViewHeight;
@property(strong,nonatomic)TKHomeDataModel  * model;

@property (weak, nonatomic) IBOutlet UILabel *labGG;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;

@property (weak, nonatomic) IBOutlet UILabel *labToutiao;
@property (weak, nonatomic) IBOutlet UILabel *labermen;
@property (weak, nonatomic) IBOutlet UIView *viewReMen;
@property (weak, nonatomic) IBOutlet UILabel *labErmenDesc;
@property (weak, nonatomic) IBOutlet UILabel *labNo;

@end
@implementation RecommendMediaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgRecommend.layer.cornerRadius = 4;
    self.imgRecommend.layer.masksToBounds = YES;
    
    self.viewReMen.layer.cornerRadius = 5;
    self.viewReMen.layer.masksToBounds = YES;
    self.labermen.layer.cornerRadius = 5;
    self.labermen.layer.masksToBounds = YES;
    self.labToutiao.layer.cornerRadius = 5;
    self.labToutiao.layer.masksToBounds = YES;
    self.labNo.hidden = YES;
    self.labGG.hidden = YES;
}


-(void)refreshData:(TKHomeDataModel *)model{
    if (model == nil) {
        return;
    }
    self.model = model;
    MediaRepMortModel *tModel = [model.mediaList firstObject];
    self.labTitleInfo.text = tModel.title;
    
    [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@"我的订单页面产品图"]];
    if (model.hotNews[0].title != nil) {
        self.labToutiao.text = model.hotNews[0].title;
    }else{
        self.labToutiao.text= @"暂无";
    }
    if (model.hotNews[1].title != nil) {
        self.labermen.text = model.hotNews[1].title;
    }else{
        self.labermen.text= @"暂无";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)actionMore:(id)sender {
      MedieaListViewController*medieaVC = [[MedieaListViewController alloc]init];
    medieaVC.hidesBottomBarWhenPushed = YES;
    [[self getCurrentVC].navigationController pushViewController:medieaVC animated:YES];
}

- (IBAction)actionErmen:(id)sender {
    if (self.model.hotNews[1] == nil) {
        return;
    }
    WebDetailViewController *webDetail = [[WebDetailViewController alloc]init];
    webDetail .detailUrl = self.model.hotNews[1].link;
    webDetail.hidesBottomBarWhenPushed = YES;
    [[self getCurrentVC].navigationController pushViewController:webDetail animated:YES];
    
}
- (IBAction)actionTouTiao:(id)sender {
    if (self.model.hotNews[0] == nil) {
        return;
    }
    WebDetailViewController *webDetail = [[WebDetailViewController alloc]init];
    webDetail .detailUrl = self.model.hotNews[0].link;
    webDetail.hidesBottomBarWhenPushed = YES;
    [[self getCurrentVC].navigationController pushViewController:webDetail animated:YES];
}

@end
