//
//  UserAgreeViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "UserAgreeViewController.h"
#import "Header.h"
@interface UserAgreeViewController ()

@end

@implementation UserAgreeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(25, 182, 133, 1)];
    mainController *main = (mainController *)self.tabBarController;
    if (self.navigationController.viewControllers.count==2) {
        [main showOrHiddenTabBarView:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self subViews];
}
-(void)initNavigation
{
    self.navigationItem.title = @"妙生活城平台用户协议";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)subViews
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,kDeviceWidth , 40)];
    label.text = @"妙生活城平台用户协议";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.view addSubview:label];
    
    UILabel *contLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, kDeviceWidth, 280)];
    contLabel.text = @"      1、 本券结账前请出示。\n      2、 本券不兑换现金、不找零。\n      3、 使用本券消费时，不含酒水。\n      4、 使用本券消费时不另开发票。\n      5、 本券只限在注明日期内有效。\n      6、 本券盖章签字后方可使用。\n      7、 以上条款，本酒店有最终解释权。\n\n\n\n\n\n                  有效期   年   月   日至   年  月  日";
    contLabel.textColor = textBlackColor;
    contLabel.backgroundColor = [UIColor clearColor];
    contLabel.textAlignment = NSTextAlignmentLeft;
    contLabel.numberOfLines = 0;
    contLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self.view addSubview:contLabel];
    
}
-(void)btnAction:(UIButton *)btn
{
    if (self.navigationController.viewControllers.count==2) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
