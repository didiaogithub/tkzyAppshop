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

@end

@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
         [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@""]];
        self.labPrice.hidden = YES;
        self.labWeight.hidden = YES;
        self.labTitleDisBottom.constant  = -15;
        
        
    }else if (section == 4){
        HonorModel * tModel = [model.honorList objectAtIndex:index.row];
        
        [self.imgRecommend sd_setImageWithURL:[NSURL URLWithString:tModel.imgpath] placeholderImage:[UIImage imageNamed:@""]];
        self.labTitle.text = tModel.title;
        self.labPrice.hidden = YES;
        self.labWeight.hidden = YES;
        self.labTitleDisBottom.constant  = -15;
    }

}

@end
