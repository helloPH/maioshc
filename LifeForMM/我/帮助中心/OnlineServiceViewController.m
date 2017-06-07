//
//  OnlineServiceViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OnlineServiceViewController.h"
#import "Header.h"
#import "feedbackViewController.h"
@interface OnlineServiceViewController ()

@end

@implementation OnlineServiceViewController
{
    UIImageView *caozuotishiImage;
    UIWebView *vb;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*  --- 手势返回 (系统) --- */
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    //初始化导航栏
    [self initNavigation];
    //获取数据
    [self reloadData];
}

-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstFankui"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/fankui.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,-10, kDeviceWidth, kDeviceHeight)];
        caozuotishiImage.alpha = 0.9;
        caozuotishiImage.userInteractionEnabled = YES;
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden:)];
        [caozuotishiImage addGestureRecognizer:imageTap];
        [self.view addSubview:caozuotishiImage];
    }
}

-(void)imageHidden:(UITapGestureRecognizer *)tap
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstFankui"];
    [caozuotishiImage removeFromSuperview];
}
//初始化导航
-(void)initNavigation
{
    self.navigationItem.title = @"在线客服";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"反馈"] forState:UIControlStateNormal];
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
//获取数据
-(void)reloadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@zaixiankefu.jsp?userid=%@",HTTPHEADER,user_id];
    vb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    vb.backgroundColor = [UIColor whiteColor];
    vb.scalesPageToFit = YES;//自动放缩适应屏幕
    vb.opaque = NO;
    [self.view addSubview:vb];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [vb loadRequest:request];
    
    [self judgeTheFirst];

}
//返回按钮 事件
-(void)btnAction
{
    if (_isOrder) { //在订单页面进入
        [self.navigationController popToRootViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    else{//非订单页进去
        [self.navigationController popToRootViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 1;
        [main showOrHiddenTabBarView:NO];
    }
}
//导航右侧按钮 事件
-(void)rightBtnAction
{
    feedbackViewController *vc = [[feedbackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
