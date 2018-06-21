//
//  YSCollectionCell.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/5/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "YSCollectionCell.h"

@interface YSCollectionCell ()

@property (nonatomic, strong) UIImageView *imageViwe;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UILabel *specLabel;
@property (nonatomic, strong) UILabel *noLabel;
@end

@implementation YSCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _imageViwe = [UIImageView new];
    [bgView addSubview: _imageViwe];
    
    _title = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    _title.text = @"商品名称";
    _title.numberOfLines = 2;
    [bgView addSubview:_title];
    
    self.noLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    self.noLabel.text = @"产品编号：";
    [_title addSubview:self.noLabel];
    self.specLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    self.specLabel.text = @"产品规格：";
    [_title addSubview:self.specLabel];
    
    _price = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    _price.text = @"¥0.00";
    [_title addSubview:_price];
    
    _comment = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:13]];
    _comment.text = @"好评100%";
//    [bgView addSubview:_comment];
    
    [self makeConstraints];
    
    UILabel *line = [UILabel creatLineLable];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)makeConstraints {
    
    [_imageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.height.mas_equalTo(100);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@90);
    }];
    
    [_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.price.mas_top).offset(-5);
        make.height.mas_equalTo(20);
        //        make.bottom.equalTo(self.price.mas_top);
        //        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.specLabel.mas_top).offset(-5);
        make.height.mas_equalTo(20);
        //        make.bottom.equalTo(self.price.mas_top);
        //        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
  
    
//    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//        make.width.equalTo(@90);
//    }];

}

-(void)refreshCellWithCollectionModel:(SCMyCollectionModel*)collectionM {
    [_imageViwe sd_setImageWithURL:[NSURL URLWithString:collectionM.pic] placeholderImage:[UIImage imageNamed:@"我的订单页面产品图"]];
    
    NSString *name = [NSString stringWithFormat:@"%@",collectionM.name];
//    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor tt_bodyTitleColor]}];
//    
//    NSRange range = [name rangeOfString:@"】"];
//    
//    [aStr setAttributes:@{NSForegroundColorAttributeName:[UIColor tt_redMoneyColor]} range:NSMakeRange(0, range.location+1)];
    
    _title.text = name;
    
    
    NSString *spec = [NSString stringWithFormat:@"%@", collectionM.itemSpec];
    if (!IsNilOrNull(spec)) {
        spec = [NSString stringWithFormat:@"产品规格:%@", collectionM.itemSpec];
    }else{
        spec = @"";
    }
    _specLabel.text = spec;
    NSString *itemNo = [NSString stringWithFormat:@"%@", collectionM.itemNo];
    if (!IsNilOrNull(itemNo)) {
        itemNo = [NSString stringWithFormat:@"产品编号:%@", collectionM.itemNo];
    }else{
        itemNo = @"";
    }
    _noLabel.text = itemNo;
    
    NSString *saleprice = [NSString stringWithFormat:@"%@", collectionM.price];
    if (!IsNilOrNull(saleprice)) {
        saleprice = [NSString stringWithFormat:@"¥%@", collectionM.price];
    }else{
        saleprice = @"";
    }
    _price.text = saleprice;
    
//    NSString *fine = [NSString stringWithFormat:@"%@", collectionM.fine];
//    if (!IsNilOrNull(fine)) {
//        fine = [NSString stringWithFormat:@"好评%@", collectionM.fine];
//    }else{
//        fine = @"";
//    }
//    _comment.text = fine;

}

@end
