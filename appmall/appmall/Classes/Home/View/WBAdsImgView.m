//
//  WBAdsImgView.m
//  happyLottery
//
//  Created by 壮壮 on 2017/12/6.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WBAdsImgView.h"


@interface WBAdsImgView()<UIScrollViewDelegate>
{
    
    UIScrollView *scrContentView;
    NSTimer *timer;
   
    NSInteger index;
    UIPageControl *pageCtl;
}
@property(nonatomic,strong)NSArray * imgUrls;

@end

@implementation WBAdsImgView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScrImg) userInfo:nil repeats:YES];
        index = 0;
        
        _imgUrls = nil;
        pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake((KscreenWidth - 80), self.mj_h - 40, 70, 40)];
    }
    return self;
}

-(void)setImageUrlArrayTkSchool:(NSArray<BannerListModel *> *)imgUrls{
    _imgUrls = imgUrls;
    if (scrContentView == nil) {
        
        scrContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,self.mj_h)];
        scrContentView.delegate = self;
        scrContentView.pagingEnabled = YES;
        scrContentView.showsHorizontalScrollIndicator = NO;
        scrContentView.showsVerticalScrollIndicator = NO;
        scrContentView.bounces = NO;
        [self addSubview:scrContentView];
    }else{
        for (UIView *subView in scrContentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    if (imgUrls == nil) {//网络状态不好  或者数据未回来  预先加载本地banner图
        scrContentView.contentSize = CGSizeMake(KscreenWidth * 3, scrContentView.mj_h);
        
        pageCtl.numberOfPages = 3;
        
        for (int i = 0; i < 3; i ++ ) {
            UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
            itemImg.userInteractionEnabled = YES;
            
            itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
            [scrContentView addSubview:itemImg];
            itemImg.adjustsImageWhenHighlighted = NO;
     
            //            [itemImg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_home%d",i + 1]] forState:0];
        }
        [self addSubview:pageCtl];
        
        return;
    }
    
    scrContentView.contentSize = CGSizeMake(KscreenWidth * (imgUrls.count + 1), scrContentView.mj_h);
//    if (imgUrls.count == 1) {
//        pageCtl.hidden = YES;
//    }else{
//        pageCtl.hidden = NO;
//    }
    
    
    for (int i = 0; i < imgUrls.count + 1; i ++ ) {
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];

        [itemImg addTarget:self action:@selector(imgItemTKClick) forControlEvents:UIControlEventTouchUpInside];
        itemImg.adjustsImageWhenHighlighted = NO;
        if (i >= imgUrls.count ) {
               [itemImg sd_setBackgroundImageWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",[imgUrls objectAtIndex:0].picUrl ]] forState:0];
        }else{
               [itemImg sd_setBackgroundImageWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",[imgUrls objectAtIndex:i].picUrl ]] forState:0];
        }
     
    }
    pageCtl.numberOfPages = imgUrls.count;
    pageCtl.hidden = YES;
    
    [self addSubview:pageCtl];
}

-(void)setImageUrlArray:(NSArray<BannerModel *> *)imgUrls{
    
    if (scrContentView == nil) {
        scrContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,self.mj_h)];
        scrContentView.delegate = self;
        scrContentView.pagingEnabled = YES;
        scrContentView.showsHorizontalScrollIndicator = NO;
        scrContentView.showsVerticalScrollIndicator = NO;
        scrContentView.bounces = NO;
        [self addSubview:scrContentView];
    }else{
        for (UIView *subView in scrContentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    if (imgUrls == nil) {//网络状态不好  或者数据未回来  预先加载本地banner图
        scrContentView.contentSize = CGSizeMake(KscreenWidth * 3, scrContentView.mj_h);
        
        pageCtl.numberOfPages = 3;
        
        for (int i = 0; i < 3; i ++ ) {
            UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
            [itemImg setImage:[UIImage imageNamed:@"天康学院banner"] forState:0];
            itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
            [scrContentView addSubview:itemImg];
            itemImg.adjustsImageWhenHighlighted = NO;
//            [itemImg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_home%d",i + 1]] forState:0];
        }
        [self addSubview:pageCtl];
        
        return;
    }
    
    _imgUrls = imgUrls;

    scrContentView.contentSize = CGSizeMake(KscreenWidth * (imgUrls.count + 1), scrContentView.mj_h);
//    if (imgUrls.count == 1) {
//        pageCtl.hidden = YES;
//    }else{
//        pageCtl.hidden = NO;
//    }
   
    
    for (int i = 0; i < imgUrls.count + 1; i ++ ) {
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];

        [itemImg addTarget:self action:@selector(imgItemClick) forControlEvents:UIControlEventTouchUpInside];
        itemImg.adjustsImageWhenHighlighted = NO;
//        [itemImg sd_setBackgroundImageWithURL: [NSURL URLWithString:[imgUrls objectAtIndex:i].imgpath ] forState:0];
        if (i >= imgUrls.count ) {
            [itemImg sd_setBackgroundImageWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",[imgUrls objectAtIndex:0].imgpath ]] forState:0];
        }else{
            [itemImg sd_setBackgroundImageWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",[imgUrls objectAtIndex:i].imgpath ]] forState:0];
        }
    }
    pageCtl.numberOfPages = imgUrls.count;
    
    if (imgUrls .count ==1) {
        pageCtl.hidden = YES;
    }

    [self addSubview:pageCtl];
}

-(void)updataPageCtl{
    pageCtl.currentPage = index;
}

-(void)autoScrImg{
   
    NSInteger count = 0;
    if (_imgUrls == nil) {
        count = 3;
    }else{
        count = _imgUrls.count + 1;
    }
    
    CGFloat aniTime;
    index ++ ;
    if (index == count) {
        scrContentView.contentOffset = CGPointMake(0, scrContentView.contentOffset.y);
        
        aniTime = 0.1;
    }else{
        aniTime = 0.5;

    }

    
    index = index % count;
    
    [UIView animateWithDuration:aniTime animations:^{
        [self updataPageCtl];
        scrContentView.contentOffset = CGPointMake(KscreenWidth * index, scrContentView.contentOffset.y);
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    index =(NSInteger)scrContentView.contentOffset.x / KscreenWidth;
   
    [self updataPageCtl];
}

-(void)imgItemClick{
    if (index >= _imgUrls.count) {
        index = 0;
    }
    [self.delegate adsImgViewClick:_imgUrls[index]];
}

-(void)imgItemTKClick{
    if (index >= _imgUrls.count) {
        index = 0;
    }
    [self .delegate adsImgTKViewClick:_imgUrls[index]];
}


@end
