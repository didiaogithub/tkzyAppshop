

//
//  MessageViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListViewCell.h"

#define KMessageListViewCell @"MessageListViewCell"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *messageListIView;

@end
@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setTableView];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.messageListIView.delegate = self;
    self.messageListIView.dataSource = self;
    [self.messageListIView registerNib:[UINib nibWithNibName:KMessageListViewCell bundle:nil] forCellReuseIdentifier:KMessageListViewCell];
    [self .messageListIView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
    
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
