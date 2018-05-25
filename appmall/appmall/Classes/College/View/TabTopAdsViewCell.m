//
//  TabTopAdsViewCell.m
//  appmall
//
//  Created by 王博 on 2018/4/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TabTopAdsViewCell.h"
#import "WBAdsImgView.h"
#import "WebDetailViewController.h"

@interface TabTopAdsViewCell()<WBAdsImgViewDelegate>{
    WBAdsImgView *adsView;
}
@end

@implementation TabTopAdsViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (adsView == nil) {
            adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenWidth/2)];
            adsView.delegate = self;
            [self addSubview:adsView];
        }
        [adsView setImageUrlArray:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)loadData:(TKSchoolModel *)model{
    [adsView setImageUrlArrayTkSchool:model.bannerList];
}

-(void)adsImgTKViewClick:(BannerListModel*)itemIndex;{
    WebDetailViewController *detailVC = [[WebDetailViewController alloc]init];
    detailVC.detailUrl = itemIndex.detailUrl;
    [[self getCurrentVC ].navigationController pushViewController:detailVC animated:YES];
}

@end
