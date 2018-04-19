//
//  HonourDetailViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HonourDetailViewController.h"
#import "HonourListViewCell.h"
#define KHonourListViewCell @"HonourListViewCell"

@interface HonourDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *honourDetailList;

@end

@implementation HonourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setTableView{
    self.honourDetailList.delegate = self;
    self.honourDetailList.dataSource = self;
    [self.honourDetailList registerNib:[UINib nibWithNibName:KHonourListViewCell bundle:nil] forCellReuseIdentifier:KHonourListViewCell];
    [self .honourDetailList reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HonourListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHonourListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
