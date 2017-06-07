//
//  UseDirectionViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "UseDirectionViewController.h"
#import "Header.h"
@interface UseDirectionViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UseDirectionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self initNavigation];
    [self initWebView];
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
-(void)btnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}
@end
