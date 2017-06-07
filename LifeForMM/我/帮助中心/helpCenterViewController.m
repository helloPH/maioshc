//
//  helpCenterViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "helpCenterViewController.h"
#import "Header.h"
#import "OnlineServiceViewController.h"
#import "feedbackViewController.h"
@interface helpCenterViewController ()

@end

@implementation helpCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initWebView];
    [self bottomView];
}
-(void)initNavigation
{
    self.navigationItem.title = _titStr;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)initWebView
{
    UIWebView *vb = [[UIWebView alloc]initWithFrame:self.view.bounds];
    vb.backgroundColor = [UIColor whiteColor];
    vb.scalesPageToFit = YES;//自动放缩适应屏幕
    vb.opaque = NO;
    [self.view addSubview:vb];
    NSURL *url =[NSURL URLWithString:_pageUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [vb loadRequest:request];
}
-(void)bottomView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    view.backgroundColor = txtColors(4, 196, 153, 1);
    view.alpha = 0.95;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    label.text = @"在线客服";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:MLwordFont_15];
    label.center = CGPointMake(kDeviceWidth/2.0, 23);
    [view addSubview:label];
    [self.view addSubview:view];
}
-(void)btnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}
-(void)tapAction
{
    OnlineServiceViewController *vc = [[OnlineServiceViewController alloc]init];
    vc.isOrder = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
