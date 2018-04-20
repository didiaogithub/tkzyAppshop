//
//  RootTabBarController.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "SCCommon.h"

#define RootTabBarItemBadgeRadius 7.5f

@interface RootTabBarItem : UITabBarItem

@end

@implementation RootTabBarItem {
@private
    NSString *_rootTabBarBadgeValue;
    UILabel *_rootTabBarBadgeLabel;
}

-(NSString *)badgeValue {
    return _rootTabBarBadgeValue;
}

-(void)setBadgeValue:(NSString *)badgeValue {
    _rootTabBarBadgeValue = badgeValue;
    [self updateBadgeViewLayout];
}

-(void)updateBadgeViewLayout {
    
    NSString *viewKey = @"view";
    
    if(![SCCommon isVariableWithClass:[UITabBarItem class] varName:viewKey]) {
        return;
    }
    
    UIView *view = [self valueForKey:viewKey];
    if(!view) {
        return;
    }
    
    if(!_rootTabBarBadgeLabel) {
        _rootTabBarBadgeLabel = [[UILabel alloc] init];
        _rootTabBarBadgeLabel.backgroundColor = [UIColor redColor];
        _rootTabBarBadgeLabel.textColor = [UIColor whiteColor];
        _rootTabBarBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _rootTabBarBadgeLabel.font = [UIFont systemFontOfSize:9];
        _rootTabBarBadgeLabel.layer.masksToBounds = YES;
        _rootTabBarBadgeLabel.layer.cornerRadius = RootTabBarItemBadgeRadius;
        if(view.superview) {
            [view.superview addSubview:_rootTabBarBadgeLabel];
        }
    }
    
    BOOL isHiden = _rootTabBarBadgeValue ? NO : YES;
    _rootTabBarBadgeLabel.hidden = isHiden;
    
    if(!isHiden) {
        _rootTabBarBadgeLabel.text = _rootTabBarBadgeValue;
        CGFloat minX = CGRectGetMinX(view.frame) + CGRectGetWidth(view.frame) / 2 + self.imageInsets.left + RootTabBarItemBadgeRadius;
        CGRect frame = CGRectMake(minX, 4, RootTabBarItemBadgeRadius * 2, RootTabBarItemBadgeRadius * 2);
        _rootTabBarBadgeLabel.frame = frame;
    }
}

@end

@interface RootTabBarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabBarController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponent];
}
- (void) initializeComponent {
    
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 5];
    tabAttrs[@"tabTitle"] = @"首页";
    tabAttrs[@"title"] = @"首页";
    tabAttrs[@"itemNormal"] = @"首页-未选中";
    tabAttrs[@"itemSelected"] = @"首页";
    tabAttrs[@"rootVC"] = @"HomeViewController";
    UINavigationController *homeNavVC = [self tabNavVCWithAttr: tabAttrs];
    tabAttrs[@"title"] = @"天康学院";
    tabAttrs[@"tabTitle"] = @"天康学院";
    tabAttrs[@"itemNormal"] = @"天康学院-未选中";
    tabAttrs[@"itemSelected"] = @"天康学院";
    tabAttrs[@"rootVC"] = @"CollegeViewController";
    UINavigationController *collegeNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"社区";
    tabAttrs[@"title"] = @"社区";
    tabAttrs[@"itemNormal"] = @"社区-未选中";
    tabAttrs[@"itemSelected"] = @"社区";
    tabAttrs[@"rootVC"] = @"CommunityViewController";
    UINavigationController *communityNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    
    tabAttrs[@"tabTitle"] = @"购物车";
    tabAttrs[@"title"] = @"购物车";
    tabAttrs[@"itemNormal"] = @"购物车-未选中";
    tabAttrs[@"itemSelected"] = @"购物车";
    tabAttrs[@"rootVC"] = @"SCShoppingCarViewController";
    UINavigationController *shoppingNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"我的";
    tabAttrs[@"title"] = @"我的";
    tabAttrs[@"itemNormal"] = @"我-未选中";
    tabAttrs[@"itemSelected"] = @"我";
    tabAttrs[@"rootVC"] = @"RootBaseViewController";
    UINavigationController *mineNavVC = [self tabNavVCWithAttr: tabAttrs];
        self.viewControllers = @[homeNavVC,collegeNavVC,communityNavVC, shoppingNavVC,mineNavVC];
        self.tabBar.backgroundColor =   RGBCOLOR(245, 245, 245);;
        self.tabBar.barTintColor =   RGBCOLOR(245, 245, 245);
}


- (UINavigationController *) tabNavVCWithAttr: (NSDictionary*) attrs {
    UIImage *normalImage = [[UIImage imageNamed: attrs[@"itemNormal"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed: attrs[@"itemSelected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle: attrs[@"tabTitle"] image: normalImage selectedImage: selectedImage];
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor grayColor]};
    [tabBarItem setTitleTextAttributes: normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor redColor]};
    [tabBarItem setTitleTextAttributes: selectedAttributes forState:UIControlStateSelected];
    NSString *rootVCClassName = attrs[@"rootVC"];
    
    UIViewController *rootVC = [[NSClassFromString(rootVCClassName) alloc] init];
    
    rootVC.title = attrs[@"title"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: rootVC];
    navVC.navigationBar.barTintColor = RGBCOLOR(245, 245, 245);
    
    navVC.tabBarItem = tabBarItem;
    
    
    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    return navVC;
}

-(UIImage*)imageOriginal:(NSString*)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma -mark Autorotate

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;
}

#pragma -mark dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
