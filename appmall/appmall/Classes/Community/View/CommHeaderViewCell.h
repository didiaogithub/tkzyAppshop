//
//  GoodSdetailHeaderViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommDetail.h"
@interface CommHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *labBannerNum;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labComm;
@property (weak, nonatomic) IBOutlet UILabel *labGood;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImg;

@property (weak, nonatomic) IBOutlet UILabel *labShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UITextView *labContent;
-(void)loadDataWithModel:(CommDetail * )model;
@end
