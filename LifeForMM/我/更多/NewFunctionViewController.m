//
//  NewFunctionViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 新功能介绍

#import "NewFunctionViewController.h"
#import "Header.h"
#import "MainScrollView.h"
@interface NewFunctionViewController ()<UIGestureRecognizerDelegate>
@end

@implementation NewFunctionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self functionImageData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"新功能介绍";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)functionImageData
{
    [HTTPTool getWithUrl:@"newFunction.action" params:nil success:^(id json) {
        NSArray *ary = [json valueForKey:@"xingongneng"];
        MyLog(@"-- %@",json);
        NSMutableArray *urlAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in ary) {
            NSString *url = [dic valueForKey:@"url"];
            [urlAry addObject:url];
        }
        [self loadScrolloview:urlAry];
    } failure:^(NSError *error) {
    }];
}
-(void)loadScrolloview:(NSArray *)imgAry
{
    MainScrollView *scrol = [[MainScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
   
//    for (int i =0; i<imgAry.count; i++) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*i,0, kDeviceWidth, kDeviceHeight-64)];
//        image.backgroundColor = [UIColor clearColor];
//        [image sd_setImageWithURL:[NSURL URLWithString:imgAry[i]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
//        [scrol addSubview:image];
//    }
//        scrol.contentSize = CGSizeMake(imgAry.count*kDeviceWidth*MCscale, kDeviceHeight-64);
    [self.view addSubview:scrol];
    
    [scrol addImageViewForScrollViewWith:imgAry];
}
-(void)btnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
