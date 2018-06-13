//
//  BaseViewController.m
//  ShoppingCentre
//
//  Created by 二壮 on 16/7/12.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "HyperlinksButton.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (AppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [AppDelegate shareAppDelegate];
    }
    return _appDelegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseUI];
    
}
-(void)createBaseUI{
    
    self.view.backgroundColor = [UIColor tt_grayBgColor];
  
    self.loadingView = [[CKC_CustomProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//添加提示view
- (void)showNoticeView:(NSString*)title
{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.0f];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.childViewControllers.count==1) {
        return NO;
    }
    return YES;
}

-(void)getReaml{
    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingString:@"/tkxyDB.realm"];
    self.realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
}


- (void)setRightButton:(NSString *)btnName
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:btnName forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -17;
   UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,right];
   
}
- (void)setRightButton:(NSString *)btnName titleColor:(UIColor *)titleColor
 isTJXHX:(BOOL)isTJXHX{
    
    HyperlinksButton *button = [HyperlinksButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:btnName forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (isTJXHX == YES) {
          [button setColor:titleColor];
    }else{
       [button setColor:[UIColor clearColor]];
    }
    
    negativeSpacer.width = -17;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,right];
    
}


- (void)setRightImageButton:(NSString *)btnName
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:btnName] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnPressed)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
}
- (void)rightBtnPressed
{
    
}


@end
