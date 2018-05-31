//
//  RecommendCollectionViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
@interface RecommendCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UILabel *labWeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTitleDisBottom;
@property (weak, nonatomic) IBOutlet UILabel *labToutiao;
@property (weak, nonatomic) IBOutlet UILabel *labermen;
@property (weak, nonatomic) IBOutlet UIView *viewReMen;
@property (weak, nonatomic) IBOutlet UILabel *labErmenDesc;

@property (weak, nonatomic) IBOutlet UILabel *labToutiaoDesc;
@end

@implementation RecommendCollectionViewCell

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
-(void)loadDataModel:(TKHomeDataModel *)model andIndex:(NSIndexPath  *)index andSuperSection:(NSInteger)section{
    
    if (section ==2) {
        self.viewReMen.hidden =YES;
        TopicModel *tModel = [model.topicList objectAtIndex:index.row];
        [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@""]];
        self.labTitle.text = tModel.itemname;
        self.labPrice.text = tModel.price;
        self.labWeight.text = tModel.spec;
        self.labPrice.hidden = NO;
        self.labWeight.hidden = NO;
        self.labTitleDisBottom.constant  = 10;
        
        
    }else if (section ==  3){
        MediaRepMortModel *tModel = [model.mediaList objectAtIndex:index.row];
        self.labTitle.text = tModel.title;
        self.viewReMen.hidden =NO;
         [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@""]];
        self.labPrice.hidden = YES;
        self.labWeight.hidden = YES;
        self.labTitleDisBottom.constant  = -15;
        if (model.hotNews[0].title != nil) {
            self.labToutiaoDesc.text = model.hotNews[0].title;
        }else{
            self.labToutiaoDesc.text= @"暂无";
        }
        if (model.hotNews[1].title != nil) {
            self.labErmenDesc.text = model.hotNews[1].title;
        }else{
            self.labErmenDesc.text= @"暂无";
        }
        
        
    }else if (section == 4){
        HonorModel * tModel = [model.honorList objectAtIndex:index.row];
        self.viewReMen.hidden =YES;
        [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@""]];
        self.labTitle.text = tModel.title;
        self.labPrice.hidden = YES;
        self.labWeight.hidden = YES;
        self.labTitleDisBottom.constant  = -15;
    }

}

@end
