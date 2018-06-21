//
//  GoodSdetailHeaderViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommDetail.h"

@protocol CommHeaderViewCellDelegate
-(void)actionCommDetailShare:(CommDetail * )model;
-(void)actionCommDetailComm:(CommDetail * )model;
-(void)actionCommDetailGood:(CommDetail * )model;
@end

@interface CommHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *labBannerNum;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *labComm;
@property (weak, nonatomic) IBOutlet UIButton *labGood;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImg;

@property (weak, nonatomic) IBOutlet UIButton *labShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UITextView *labContent;
@property(weak,nonatomic)id <CommHeaderViewCellDelegate >delegate;
-(void)loadDataWithModel:(CommDetail * )model;
@end
