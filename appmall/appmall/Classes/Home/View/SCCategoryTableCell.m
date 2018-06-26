//
//  SCCategoryTableCell.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCCategoryTableCell.h"

@interface SCCategoryTableCell()

//@property (nonatomic, strong) UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLable;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@property (weak, nonatomic) IBOutlet UIButton *shoppingCar;

@end

@implementation SCCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addToShoppingCar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodsToShoppingCar:)]) {
        [self.delegate addGoodsToShoppingCar:_goodsModel];
    }
}

-(void)refreshCellWithModel:(SCCategoryGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.shoppingCar addTarget:self  action:@selector(addToShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    self.imageV.layer.cornerRadius = 4;
    self.imageV.layer.masksToBounds = YES;
    self.numLable.text = [NSString stringWithFormat:@"编号：%@",goodsModel.itemNo];
    self.weightLabel.text = [NSString stringWithFormat:@"规格：%@kg",goodsModel.itemSpec];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",goodsModel.price];
    self.nameLabel.text = goodsModel.name;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.imgpath] placeholderImage:nil];
}


@end
