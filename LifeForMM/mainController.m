//
//  mainController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "mainController.h"
#import "Header.h"
#import "lifeCityViewController.h"
#import "CarViewController.h"
#import "MeViewController.h"
#import "OrderViewController.h"
#import <CoreLocation/CoreLocation.h>
static mainController *main = nil;
@interface mainController()<CLLocationManagerDelegate>
{
    NSArray *controllers;//控制器数组
    NSArray *controllers2;//控制器数组2
    NSInteger controlSytle;
    NSInteger lastSelectIndex;
    NSUserDefaults *userDefault;
    CLLocationManager *locationManager;
}
//装在子视图控制器
-(void)loadViewControllers;
//自定义tabBar视图
-(void)customTabBarView;
@end

@implementation mainController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    userDefault = [NSUserDefaults standardUserDefaults];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    controlSytle = 0;
    lastSelectIndex = 0;
    _controlShowStyle = 0;
    // 加载子视图控制器
    [self loadViewControllers];
    //自定义tabBar视图
    [self customTabBarView];
}
-(void)loadViewControllers
{
    //购物车
//    CarViewController *car = [[CarViewController alloc]init];
//    UINavigationController *carNav = [[UINavigationController alloc]initWithRootViewController:car];
    //首页
    lifeCityViewController *life = [[lifeCityViewController alloc]init];
    UINavigationController *lifeNav = [[UINavigationController alloc]initWithRootViewController:life];
    //我
    MeViewController *me = [[MeViewController alloc]init];
    UINavigationController *meNav = [[UINavigationController alloc]initWithRootViewController:me];
    
    //订单
    OrderViewController *order = [[OrderViewController alloc]init];
    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:order];

    controllers = [NSArray arrayWithObjects:lifeNav,orderNav,meNav, nil];
    self.selectedIndex = 0;
    [self setViewControllers:controllers animated:YES];
    
}
-(void)customTabBarView
{
    _tabBarBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
//    _tabBarBG.alpha = 0.95;
    _tabBarBG.userInteractionEnabled = YES;
    _tabBarBG.tag = 1000;
//    _tabBarBG.image = [UIImage imageNamed:@"导航条"];
    _tabBarBG.backgroundColor = txtColors(30, 190, 150, 0.8);//txtColors(25, 182, 133, 0.8);
    [self.view addSubview:_tabBarBG];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *itemIndexString = [userDef objectForKey:@"itemIndex"];
    _itemIndexter = [itemIndexString integerValue];
    NSArray *image = @[@"选中生活城",@"订单",@"我"];
    NSArray *titles = @[@"生活城",@"订单",@"我"];
    int x=0;
    for (int index = 0; index<3; index++) {
        
        ItemView *itemView = [[ItemView alloc]initWithFrame:CGRectMake(x, 0, kDeviceWidth/3, 49)];
        itemView.tag = index;
        itemView.delegate = self;
        itemView.item.image = [UIImage imageNamed:image[index]];
        itemView.title.text = titles[index];
        [_tabBarBG addSubview:itemView];
        x+=kDeviceWidth/3;
    }
}
-(void)didItemView:(ItemView *)itemView atIndex:(NSInteger)index
{
    NSArray *image = @[@"选中生活城",@"订单选中",@"选中我"];
    NSArray *image1 = @[@"生活城",@"订单",@"我"];
    if (index == 2) {
        if ([userDefault integerForKey:@"isLogin"]!=1) {
            [userDefault setInteger:2 forKey:@"isLogin"];
            for (int k = 0; k<3; k++) {
                if (k!=0) {
                    ItemView *item = (ItemView *)[_tabBarBG viewWithTag:k];
                    item.item.image = [UIImage imageNamed:image1[k]];
                }
                else{
                    ItemView *item = (ItemView *)[_tabBarBG viewWithTag:0];
                    item.item.image = [UIImage imageNamed:image[0]];
                }
            }
            ItemView *item = (ItemView *)[_tabBarBG viewWithTag:0];
            item.item.image = [UIImage imageNamed:image[0]];
            self.selectedIndex = 0;
            NSNotification *lognNotification = [NSNotification notificationWithName:@"userWillLogin" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:lognNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userWillLogin" object:nil];
        }
        else{
            for (int j = 0; j<3; j++) {
                if (j!=2) {
                    ItemView *item0 = (ItemView *)[_tabBarBG viewWithTag:j];
                    item0.item.image = [UIImage imageNamed:image1[j]];
                }
                else{
                    ItemView *item = (ItemView *)[_tabBarBG viewWithTag:2];
                    item.item.image = [UIImage imageNamed:image[2]];
                }
            }
            self.selectedIndex = 2;
        }
    }
    else{
        for (int k = 0; k<3; k++) {
            if (k!=index) {
                ItemView *item = (ItemView *)[_tabBarBG viewWithTag:k];
                item.item.image = [UIImage imageNamed:image1[k]];
            }
            else{
                ItemView *item = (ItemView *)[_tabBarBG viewWithTag:index];
                item.item.image = [UIImage imageNamed:image[index]];
            }
        }
        self.selectedIndex = index;
    }
    lastSelectIndex = index;
}
+(id)sharUserContext
{
    @synchronized(self)
    {
        if (main==nil) {
            main = [[[self class]alloc] init];
        }
    }
    return main;
}
//控制分栏的显示和隐藏
#pragma mark - Public Method
- (void)showOrHiddenTabBarView:(BOOL)isHidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.23];
    if (isHidden) {
        _tabBarBG.left = -kDeviceWidth;
    }else {
        
        _tabBarBG.left = 0;
    }
    
    [UIView commitAnimations];
    if (_controlShowStyle == 1) {
        [self changeBar];
    }
    else if (_controlShowStyle == 2)
    {
        [self orderChangeBar];
    }
}
-(void)tabarNoEnable:(BOOL)isEnable
{
    if (isEnable) {
        _tabBarBG.userInteractionEnabled = YES;
    }
    else
        _tabBarBG.userInteractionEnabled = NO;
}
-(void)changeBar
{
    NSArray *image = @[@"选中生活城",@"订单",@"我"];
    for (int i =0; i<3; i++) {
        ItemView *item = (ItemView *)[_tabBarBG viewWithTag:i];
        item.item.image = [UIImage imageNamed:image[i]];
    }
    self.selectedIndex = 0;
    _controlShowStyle = 0;
    lastSelectIndex = 0;
}
-(void)orderChangeBar
{
    NSArray *image = @[@"生活城",@"订单选中",@"我"];
    for (int i =0; i<3; i++) {
        ItemView *item = (ItemView *)[_tabBarBG viewWithTag:i];
        item.item.image = [UIImage imageNamed:image[i]];
    }
    self.selectedIndex = 1;
    _controlShowStyle = 0;
    lastSelectIndex = 0;
}
@end
