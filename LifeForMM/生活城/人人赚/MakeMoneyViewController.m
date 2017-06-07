//
//  MakeMoneyViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MakeMoneyViewController.h"
#import "MyInvitationView.h"
#import "RegisterViewController.h"
#import "Header.h"
@interface MakeMoneyViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>

@end

@implementation MakeMoneyViewController
{
    UIImageView *topImage;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIView *backView1;
    UIView *lineView;
    UIView *ActivityRuleView;
    MyInvitationView *invitationView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    //    [self onlyLognUser];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self reloadGesture];
    [self initNavigation];
    [self initSubViews];
    [self initData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"人人赚";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -- btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark -- 列表数据
-(void)initData
{
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    [HTTPTool getWithUrl:@"enterEarnMoney.action" params:nil success:^(id json) {
        [dbud hide:YES];
        NSLog(@"人人赚 %@",json);
        NSDictionary *dict = (NSDictionary *)json;
        [topImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"image1"]]] placeholderImage:[UIImage imageNamed:@""]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"image2"]]] placeholderImage:[UIImage imageNamed:@""]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"image3"]]] placeholderImage:[UIImage imageNamed:@""]];
    } failure:^(NSError *error) {
        [dbud hide:YES];
        [self requestNetworkWrong:@"网络连接错误"];
    }];
}

-(void)initSubViews
{
    topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth,190*MCscale)];
    topImage.userInteractionEnabled = YES;
    [self.view addSubview:topImage];
    NSArray *array = @[@"立即邀请",@"面对面邀请"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kDeviceWidth -20*MCscale)/2*i+20*MCscale , topImage.bottom+10*MCscale, (kDeviceWidth -60*MCscale)/2, 40*MCscale);
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, topImage.bottom+60*MCscale, kDeviceWidth, 40*MCscale)];
    backView1.backgroundColor = lineColor;
    [self.view addSubview:backView1];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(50*MCscale, backView1.height-2, (kDeviceWidth -60*MCscale)/2-60*MCscale, 2)];
    lineView.backgroundColor = redTextColor;
    [backView1 addSubview:lineView];
    
    NSArray *btnArray = @[@"活动规则",@"我的邀请"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kDeviceWidth -20*MCscale)/2*i+20*MCscale , 0, (kDeviceWidth -60*MCscale)/2, 40*MCscale);
        [button setTitle:btnArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
        [button setTitleColor:redTextColor forState:UIControlStateSelected];
        [button setTitleColor:textColors forState:UIControlStateNormal];
        button.tag = 2000+i;
        button.selected = NO;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView1 addSubview:button];
        if (i == 0) {
            button.selected = YES;
        }
    }
    
    ActivityRuleView = [[UIView alloc]initWithFrame:CGRectMake(0, backView1.bottom, kDeviceWidth, kDeviceHeight-backView1.bottom )];
    ActivityRuleView.backgroundColor = [UIColor clearColor];
    ActivityRuleView.hidden = NO;
    [self.view addSubview:ActivityRuleView];
    
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 100*MCscale)];
    imageView2.userInteractionEnabled = YES;
    [ActivityRuleView addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,imageView2.bottom, kDeviceWidth, 200*MCscale)];
    imageView3.userInteractionEnabled = YES;
    [ActivityRuleView addSubview:imageView3];
    
    invitationView = [[MyInvitationView alloc]initWithFrame:CGRectMake(0, backView1.bottom, kDeviceWidth, kDeviceHeight-backView1.bottom) style:UITableViewStylePlain];
    invitationView.backgroundColor = [UIColor clearColor];
    invitationView.hidden = YES;
    [self.view addSubview:invitationView];
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1000) {
        NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
        if ([[def valueForKey:@"isLogin"]integerValue]==1) {
            [self receiveNewGift];
        }
        else
        {
            if ([self.moneyDelegate respondsToSelector:@selector(gotoLogin)]) {
                [self.moneyDelegate gotoLogin];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (button.tag == 1001)
    {
        NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
        if ([[def valueForKey:@"isLogin"]integerValue]==1) {
            RegisterViewController *regis = [[RegisterViewController alloc]init];
            regis.isInvite = YES;
            [self.navigationController pushViewController:regis animated:YES];        }
        else
        {
            if ([self.moneyDelegate respondsToSelector:@selector(gotoLogin)]) {
                [self.moneyDelegate gotoLogin];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        UIButton *button1 = [backView1 viewWithTag:2000];
        UIButton *button2 = [backView1 viewWithTag:2001];
        button.selected = YES;
        if (button == button1) {
            button2.selected = NO;
            ActivityRuleView.hidden = NO;
            invitationView.hidden = YES;
            lineView.frame = CGRectMake(50*MCscale, backView1.height-2, (kDeviceWidth -60*MCscale)/2-60*MCscale, 2);
        }
        else
        {
            button1.selected = NO;
            ActivityRuleView.hidden = YES;
            invitationView.hidden = NO;
            NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
            if ([[def valueForKey:@"isLogin"]integerValue]==1) {
                [invitationView reloadMyInviteData];
            }
            else
            {
                invitationView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"haoyoupng"]];
            }
            lineView.frame = CGRectMake(50*MCscale+ (kDeviceWidth -20*MCscale)/2, backView1.height-2, (kDeviceWidth -60*MCscale)/2-60*MCscale, 2);
        }
    }
}
//新人礼
-(void)receiveNewGift
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":@"0",@"shequid":userShequ_id,@"hongbaotype":@"1"}];
    
    [HTTPTool getWithUrl:@"fahongbao.action" params:pram success:^(id json) {
        
        if(![json valueForKey:@"message"]){
            NSArray *ary = [json valueForKey:@"fahongbao"];
            NSDictionary *dic = ary[0];
            NSString *urll= [NSString stringWithFormat:@"%@",[dic valueForKey:@"hongbaourl"]];
            NSString *imagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"imgurl"]];
            NSString *hongMessage = [dic valueForKey:@"shuoming"];
            [UIView animateWithDuration:0.3 animations:^{
                //构造分享内容
                id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                                   defaultContent:@"妙生活城"
                                                            image:[ShareSDK imageWithUrl:imagePath]
                                                            title:hongMessage
                                                              url:urll
                                                      description:hongMessage
                                                        mediaType:SSPublishContentMediaTypeNews];
                //弹出分享菜单
                [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                      container:nil
                                        content:publishContent
                                  statusBarTips:YES
                                    authOptions:nil
                                   shareOptions:nil
                                         result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                             if (state == SSResponseStateSuccess){
                                                 NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id,@"dianpuid":@"0",@"fenxiangstatus":@"1",@"danhao":@"0"}];
                                                 NSLog(@"%@",pram);
                                                 
                                                 [HTTPTool getWithUrl:@"fenxiang.action" params:pram success:^(id json) {
                                                     if ([[json valueForKey:@"fenzuid"]integerValue]<0) {
                                                         [self requestNetworkWrong:@"创建红包失败"];
                                                     }
                                                     else{
                                                         [self requestNetworkWrong:@"分享成功"];

                                                         NSNotification *newGoodNotification = [NSNotification notificationWithName:@"newGoodNotification" object:nil];
                                                         [[NSNotificationCenter defaultCenter]postNotification:newGoodNotification];
                                                         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newGoodNotification" object:nil];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                     bud.mode = MBProgressHUDModeCustomView;
                                                     bud.labelText = @"网络连接错误2";
                                                     [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                                 }];
                                             }
                                             else if (state == SSResponseStateFail){
                                                 [self requestNetworkWrong:[error errorDescription]];
                                             }
                                         }];
            }];
        }
        else{
            [self requestNetworkWrong:@"分享失败"];
        }
    } failure:^(NSError *error) {
        [self requestNetworkWrong:@"网络连接错误3"];
    }];
}

#pragma mark -- 滑动选择近期或历史订单
-(void)reloadGesture
{
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwip];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwip];
}
-(void)swipAction:(UISwipeGestureRecognizer *)swip
{
    UIButton *button1 = [backView1 viewWithTag:2000];
    UIButton *button2 = [backView1 viewWithTag:2001];
    if (swip.direction == 2) {
        button2.selected = NO;
        button1.selected = YES;
        ActivityRuleView.hidden = NO;
        invitationView.hidden = YES;
        lineView.frame = CGRectMake(50*MCscale, backView1.height-2, (kDeviceWidth -60*MCscale)/2-60*MCscale, 2);
    }
    else
    {
        button1.selected = NO;
        button2.selected = YES;
        ActivityRuleView.hidden = YES;
        invitationView.hidden = NO;
        [invitationView reloadMyInviteData];
        lineView.frame = CGRectMake(50*MCscale+ (kDeviceWidth -20*MCscale)/2, backView1.height-2, (kDeviceWidth -60*MCscale)/2-60*MCscale, 2);
    }
}

//错误提示
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeText;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
