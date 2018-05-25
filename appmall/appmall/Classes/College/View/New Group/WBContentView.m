//
//  WBContentView.m
//  WBMenuView
//
//  Created by 王博 on 16/1/6.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "WBContentView.h"

#import "WBMenuScrollView.h"

#define MAINBOUND  [UIScreen mainScreen].bounds

@implementation WBContentView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
    }
    return self;

}

-(void)addTopMenuView:(NSArray*)titles{
    
    UIView*contentView;
    
    for (int i = 0; i<titles.count; i++) {
        
        contentView = [[UIView alloc]initWithFrame:CGRectMake(i*MAINBOUND.size.width, 0, MAINBOUND.size.width, MAINBOUND.size.height)];
        [contentView setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
        [self addSubview:contentView];
        
    }
    self.contentSize = CGSizeMake(MAINBOUND.size.width*titles.count, MAINBOUND.size.height-50);
}






@end
