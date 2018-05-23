//
//  InvoicesManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerViewController.h"
#import "InvoicesManagerHeadView.h"
#import "InvoicesManagerCell.h"
#import "InvoicesManagerDetailVC.h"
#define leftTag 2000
#define rightTag 2001
@interface InvoicesManagerViewController ()<UITableViewDelegate,UITableViewDataSource,InvoicesManagerCellDelegate>

/**  headView*/
@property (nonatomic, strong) InvoicesManagerHeadView *headView;
@property (nonatomic,strong) UIView *sliderView;//标题栏上的滑动线
@property (nonatomic,strong) NSMutableArray *segementArr;//导航栏上的按钮数组
@property (nonatomic,strong) NSMutableArray *friendArr;
@property (nonatomic,strong) NSMutableArray *systemArr;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UITableView *mTableView;
@end

@implementation InvoicesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票管理";
    self.headView = [[InvoicesManagerHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT * 0.15)];
    [self.view addSubview:self.headView];
    
     [self setSegamentView];
     [self.mTableView registerNib:[UINib nibWithNibName:@"InvoicesManagerCell" bundle:nil] forCellReuseIdentifier:@"InvoicesManagerCell"];
    
    [self initComponments];
    
}

- (void)initComponments{
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 64 + SCREEN_HEIGHT *0.15 + 45, SCREEN_WIDTH, SCREEN_HEIGHT - (64 + SCREEN_HEIGHT *0.15 + 45)) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
}

- (void)setSegamentView
{
    CGFloat Space = 20;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + SCREEN_HEIGHT *0.15 + 10, SCREEN_WIDTH , 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    CGFloat contentViewW = contentView.frame.size.width;
    CGFloat btnW = (contentViewW -  Space)/2;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , btnW, 35)];
    [button setTitle:@"待开发票" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    button.selected = YES;
    button.tag = leftTag;
    [contentView addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(Space + btnW, 0 , btnW, 35)];
    [button1 setTitle:@"已开发票" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:12];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [contentView addSubview:button1];
    button1.tag = rightTag;
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.segementArr = [NSMutableArray arrayWithObjects:button,button1,nil];
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, btnW, 1)];
    self.sliderView.backgroundColor = [UIColor redColor];
    [contentView addSubview:self.sliderView];
    self.currentIndex = 0;
    [self.view addSubview:contentView];
    
}

//导航栏切换
- (void)buttonClick:(UIButton *)sender
{
    
    if (sender.tag == leftTag) { // 好友消息
  
        
    }
    else if (sender.tag == rightTag) // 业务消息
    {
        
       
    }
    self.sliderView.x = sender.x;
    self.sliderView.width = sender.width;
    
    for (UIButton *btn in self.segementArr) {
        btn.selected = NO;
    }
    UIButton * btn1 = self.segementArr[sender.tag - 2000];
    btn1.selected = YES;
}



#pragma mark ---- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 133;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InvoicesManagerCell";//这个identifier跟xib设置的一样
    InvoicesManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]
                loadNibNamed:@"InvoicesManagerCell" owner:self options:nil]  lastObject];
        cell.delegete = self;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)showDetail{
    InvoicesManagerDetailVC *detail = [[InvoicesManagerDetailVC alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
