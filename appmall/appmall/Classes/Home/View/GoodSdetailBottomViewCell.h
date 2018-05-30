//
//  GoodSdetailBottomViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseGoodSDetailViewCell.h"
#import "GoodDetailModel.h"

@interface GoodSdetailBottomViewCell : BaseGoodSDetailViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnGoodDetail;
@property (weak, nonatomic) IBOutlet UIWebView *webContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineDisLeft;
@property(weak,nonatomic)GoodDetailModel *selfModel;
@property (weak, nonatomic) IBOutlet UIButton *btnGoodInfo;

@end
