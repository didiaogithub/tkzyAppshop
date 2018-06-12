//
//  CommunityViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommListModel.h"

@protocol CommunityViewCellDelegate <NSObject>
-(void)communityViewCellGood:(CommListModelItem *)model andIndex:(NSInteger )index;
-(void)comunityShare:(CommListModelItem *)model;
@end

@interface CommunityViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCommIcon;
@property (weak, nonatomic) IBOutlet UILabel *labCommName;
@property (weak, nonatomic) IBOutlet UILabel *labCommTime;
@property (weak, nonatomic) IBOutlet UILabel *labCommContent;
@property (weak, nonatomic) IBOutlet UIView *viewImgContent;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnComm;
@property (weak, nonatomic) IBOutlet UIButton *btnDianzan;
@property (weak, nonatomic) IBOutlet UIButton *img1;
@property (weak, nonatomic) IBOutlet UIButton *img2;
@property (weak, nonatomic) IBOutlet UIButton *img3;
@property (weak, nonatomic) IBOutlet UIButton *img4;
@property(assign,nonatomic)NSInteger index;
@property(nonatomic,weak)id <CommunityViewCellDelegate >delegate;

-(void)refreshData:(CommListModelItem *)model;
@end
