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
    [self createShoppingBaseUI];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)createBaseUI{
    
    self.view.backgroundColor = [UIColor tt_grayBgColor];
  
    self.loadingView = [[CKC_CustomProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.alpha = 0.4;
    self.viewNetError.indicatorView =  nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);

}

-(void)createShoppingBaseUI{
    
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    self.shoppingViewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.shoppingViewNetError.alpha = 0.4;
    self.shoppingViewNetError.indicatorView =  nil;
    UIImageView * image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"叉号"]];
    image.size = [UIImage imageNamed:@"叉号"].size;
    image.center = CGPointMake(KscreenWidth / 2   , KscreenHeight/ 2  -50 );
    [self.shoppingViewNetError addSubview:image];
    self.shoppingViewNetError.userInteractionEnabled = NO;
    self.shoppingViewNetError.position = JGProgressHUDPositionCenter;
    self.shoppingViewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);
    
    self.shoppingViewNetSuccess = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.shoppingViewNetSuccess.alpha = 0.4;
    self.shoppingViewNetSuccess.indicatorView =  nil;
    UIImageView * imagesu =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对号"]];
    imagesu.size = [UIImage imageNamed:@"对号"].size;
    imagesu.center = CGPointMake(KscreenWidth / 2   , KscreenHeight/ 2  -50 );
    [self.shoppingViewNetSuccess addSubview:imagesu];
    self.shoppingViewNetSuccess.userInteractionEnabled = NO;
    self.shoppingViewNetSuccess.position = JGProgressHUDPositionCenter;
    self.shoppingViewNetSuccess.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);
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

- (void)showAddShoppingNoticeViewIsSuccess:(BOOL) success andTitle:(NSString *)title
{
    if (success == YES) {
        if (self.shoppingViewNetSuccess && !self.shoppingViewNetSuccess.visible) {
            if (title == nil) {
                  self.shoppingViewNetSuccess.textLabel.text = @"\n添加成功，在购物车等亲~";
            }else{
                title = [NSString stringWithFormat:@"\n%@",title];
                self.shoppingViewNetSuccess.textLabel.text = title;
            }
            [self.shoppingViewNetSuccess showInView:[UIApplication sharedApplication].keyWindow];
            [self.shoppingViewNetSuccess dismissAfterDelay:1.0f];
        }
    }else{
        if (self.shoppingViewNetError && !self.shoppingViewNetError.visible) {
            
            if (title == nil) {
               self.shoppingViewNetError.textLabel.text = @"\n添加失败，请稍等下再试~";
            }else{
                title = [NSString stringWithFormat:@"\n%@",title];
                self.shoppingViewNetError.textLabel.text = title;
            }
            [self.shoppingViewNetError showInView:[UIApplication sharedApplication].keyWindow];
            [self.shoppingViewNetError dismissAfterDelay:1.0f];
        }
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
