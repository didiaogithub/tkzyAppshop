//
//  MedieaListViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MedieaListViewController.h"
#import "MedieaListViewCell.h"
#import "MedieaDetailViewController.h"
#define KMedieaListViewCell @"MedieaListViewCell"

@interface MedieaListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *honourDetailList;

@end

@implementation MedieaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTableView{
    self.honourDetailList.delegate = self;
    self.honourDetailList.dataSource = self;
    [self.honourDetailList registerNib:[UINib nibWithNibName:KMedieaListViewCell bundle:nil] forCellReuseIdentifier:KMedieaListViewCell];
    [self .honourDetailList reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MedieaListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMedieaListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MedieaDetailViewController *medieaDetailVC = [[MedieaDetailViewController alloc]init];
    [self.navigationController pushViewController:medieaDetailVC animated:YES];
}
@end
