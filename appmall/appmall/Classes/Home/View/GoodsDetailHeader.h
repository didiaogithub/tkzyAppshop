//
//  GoodsDetailHeader.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"
#import "SCCommentModel.h"
@interface GoodsDetailHeader : UIView
@property (nonatomic,strong)GoodDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIButton *actionHaoping;
@property (weak, nonatomic) IBOutlet UIButton *actionFanKui;
@property (nonatomic,strong)SCCommentModel *commentM;
-(void)loadData;
@end
