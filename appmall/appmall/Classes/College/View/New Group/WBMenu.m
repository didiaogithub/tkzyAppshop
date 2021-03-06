//
//  WBMenu.m
//  WBMenuView
//
//  Created by 王博 on 16/1/7.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "WBMenu.h"
#import "WBContentView.h"
#import "WBMenuScrollView.h"
#import "WBMenuAllItem.h"

@interface WBMenu ()<WBMenuAllItemDelegate>
{
    WBMenuAllItem *allItemView;
}
@property(nonatomic,assign)CGSize itemSize;

@end

@implementation WBMenu



-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.VClist = [[NSMutableArray alloc]init];
    }
    return self;
}

/**创建上面菜单view*/
-(void)createMenuView:(NSArray*)titles size:(CGSize)size{
    
    self.itemSize = size;
    WBMenuScrollView*menuView = [[WBMenuScrollView alloc]init];
    [menuView addMenuItems:titles andSize:size];
    menuView.VCList = self.VClist;
    self.titles = titles;
    
    menuView.showsHorizontalScrollIndicator = NO;
    
    self.menuView = menuView;
    menuView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width - 65, 30);
    [self addSubview:menuView];
    UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAll addTarget:self action:@selector(showAllItem) forControlEvents:UIControlEventTouchUpInside];
    [btnAll setTitle:@"全部" forState:0];
    btnAll .frame  =CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 20, 65, 30);
    [btnAll.titleLabel setFont: [UIFont systemFontOfSize:14]];
    [btnAll setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [self addSubview:btnAll];
    
    [self createContentView:titles];
}



-(void)showAllItem{
    if (allItemView== nil) {
       
        allItemView = [[WBMenuAllItem alloc]initWithFrame: CGRectMake(0, 20, KscreenWidth, 400)];
         allItemView.delegate = self;
        allItemView.backgroundColor = [UIColor whiteColor];
        [allItemView refreshSelectItem:self.titles];
        [self addSubview:allItemView];
    }else{
        allItemView .hidden = NO;
        allItemView.mj_h = 400;
          [allItemView refreshSelectItem:self.titles];
    }
}
/**创建内容view*/
-(void)createContentView:(NSArray*)titles{
    
    WBContentView *contentView = [[WBContentView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50)];
    contentView.delegate = self;
    self.menuView.contentScrollView = contentView;
    [contentView addTopMenuView:titles];
    [self addSubview:contentView];
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)scrollView.contentOffset.x / self.frame.size.width;
    NSLog(@"%ld",(long)index);
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.tag = index;
    but.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
    [self.menuView clickAction:but];
}

-(void)addViewController:(UIViewController*)vc atIndex:(NSInteger)index{

    [self.VClist addObject:vc];
    vc.view.frame = CGRectMake(index*[UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width ,vc.view.frame.size.height - 80);
    [self.menuView.contentScrollView addSubview:vc.view];

}

-(void)addView:(UIView*)view andViewController :(UIViewController*)vc atIndex:(NSInteger )index{

    [self.VClist addObject:vc];
    view.frame = CGRectMake(index*[UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width ,view.frame.size.height - 50);
    [self.menuView.contentScrollView addSubview:view];

}

-(void)wbMenuAllItemSelect:(NSInteger)index{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.tag = index;
    [self.menuView clickAction:but];
}



@end
