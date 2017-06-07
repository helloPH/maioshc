//
//  LunchViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/3.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "LunchViewController.h"
#import "lifeCityViewController.h"
#import "Header.h"
#import "MBProgressHUD.h"
//#import "md5_password.h"
//#import "AFNetworking.h"
@interface LunchViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrol;
    NSUserDefaults *userDefault;
    NSString *tel,*pas;
}
@end

@implementation LunchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ping命令 原理：向大型的门户网址发送请求，来判断当前的网络状态
    //1、请求队列管理者(数据请求工具)
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.m1ao.com/"]];
    //2、发送请求监测网络
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //判断状态
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self performSelector:@selector(setScrolCurrenPag) withObject:self afterDelay:2];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            [self performSelector:@selector(setScrolCurrenPag) withObject:self afterDelay:2];
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"'已为妙生活城'关闭蜂窝移动数据" message:@"您可以在'设置'中为此应用打开蜂窝移动数据" preferredStyle:1];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self performSelector:@selector(setScrolCurrenPag) withObject:self afterDelay:2];
            }];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }   [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addAction:suerAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];

        }else{
//            [self requestNetworkWrong:@"不可是别的网络状态"];
        }
    }];
    //3、启动网络监测
    [manager.reachabilityManager startMonitoring];//stopMonitoring
    self.view.backgroundColor = [UIColor whiteColor];
    if (!userShequ_id) {
        [[NSUserDefaults standardUserDefaults] setValue:@"8" forKey:@"userShequid"];
    }
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
//    [userDefault setInteger:0 forKey:@"isLogin"];
//    [[NSUserDefaults standardUserDefaults]setValue:userSheBei_id forKey:@"userId"];
    if ([userDefault integerForKey:@"isLogin"] == 1) {
        tel = userName_tel;
        pas = userPass_pas;
//        if ([[userDefault valueForKey:@"longCode_bol"] isEqualToString:@"1"]) {
//            
//        }
//        [self login];
        
    }
    else{
//        [userDefault setInteger:0 forKey:@"isLogin"];
//        [userDefault setObject:@"1" forKey:@"xinrenli"];
        [userDefault setValue:@"0" forKey:@"xrlTapNum"];
//        [userDefault setValue:@"1" forKey:@"longCode_bol"];
        [userDefault setValue:userSheBei_id forKey:@"userId"];
    }
    
//  
    [self initSubViews];
}
-(void)login
{
    NSString *pasStr = [md5_password encryptionPassword:pas userTel:tel];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:tel forKey:@"user.tel"];
    [jsonDict setObject:pasStr forKey:@"user.password"];
    [jsonDict setObject:userSheBei_id forKey:@"user.shebeiId"];
    [jsonDict setObject:userShequ_id forKey:@"user.defaultShequ"];
    [HTTPTool getWithUrl:@"login4.action" params:jsonDict success:^(id json) {
        NSDictionary * dic = (NSDictionary * )json;
        if ([[dic objectForKey:@"massage"]intValue]==2) {
            [userDefault setInteger:1 forKey:@"isLogin"];
            [userDefault setValue:[dic objectForKey:@"xinrenli"] forKey:@"xinrenli"];
            NSString *userid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"]];
            [userDefault setValue:userid forKey:@"userId"];
            
            if ([[json valueForKey:@"canshu"] integerValue] == 1) {
                //denglulinshi.action
                // 1.获取AFN的请求管理者
                AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
                //网络延时设置15秒
                manger.requestSerializer.timeoutInterval = 15;
                manger.responseSerializer = [AFJSONResponseSerializer serializer];
                NSString * urlPath = [NSString stringWithFormat:@"%@Denglulinshi.action",HTTPWeb];
                // 3.发送请求
                [manger GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
            }
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)myTask
{
    sleep(1.5);
}
-(void)initSubViews
{
    scrol = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , kDeviceHeight)];
    scrol.backgroundColor = [UIColor whiteColor];
    scrol.pagingEnabled = YES;
    scrol.tag = 1001;
    scrol.delegate = self;
    scrol.showsHorizontalScrollIndicator = NO;
    scrol.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    image.image = [UIImage imageNamed:@"guide_3.jpg"];
    image.backgroundColor = [UIColor clearColor];
    image.userInteractionEnabled = YES;
    [scrol addSubview:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.width, image.height);
    btn.center = CGPointMake(kDeviceWidth/2.0, kDeviceHeight-70);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:btn];
    [self.view addSubview:scrol];
}
-(void)btnAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    mainController *main = [[mainController alloc]init];
    self.view.window.rootViewController = main;
}
-(void)setScrolCurrenPag
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    mainController *main = [[mainController alloc]init];
    self.view.window.rootViewController = main;
}
#pragma mark -- UIScrollViewDelege
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>kDeviceWidth*6/5.0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        mainController *main = [[mainController alloc]init];
        self.view.window.rootViewController = main;
    }
    return;
}
@end
