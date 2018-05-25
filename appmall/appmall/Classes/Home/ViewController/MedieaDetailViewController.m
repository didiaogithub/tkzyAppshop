//
//  MedieaDetailViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MedieaDetailViewController.h"

@interface MedieaDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *wbMediaDetail;

@end

@implementation MedieaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报道详情";
    if(self.strUrl.length == 0){
        
        [self.wbMediaDetail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    }else{
        [self.wbMediaDetail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
