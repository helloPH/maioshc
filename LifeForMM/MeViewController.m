//
//  MeViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "MeViewController.h"
#import "Header.h"
#import "feedbackViewController.h"
#import "helpCenterViewController.h"
#import "couponViewController.h"
#import "balanceViewController.h"
#import "MaskView.h"
#import "UserAgreeViewController.h"
#import "SetPaymentPasswordView.h"
#import "redMoneyModel.h"
#import "userMessModel.h"
#import "UseDirectionViewController.h"
#import "OnLinePayView.h"
#import "Order.h"
#import "DataSigner.h"
#import "MoreViewController.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,OnLinePayViewDelegate,SetPaymentPasswordViewDelegate,UITextFieldDelegate>
{
    UITableView *personTabelView; //表
    NSInteger stateNum,rzcode; //状态标记值、认证标记值
    UIImageView *favicon,*rzImage;//用户头像 、认证图标
    NSString *account;//电话号码（账户）
    CGFloat balance,coupon;//余额 、优惠
    UIImagePickerController *imagePick;
    UIView *pView;
    NSMutableArray *tolMoneyData;//推荐奖励
    NSInteger totcount; //红包个数
    NSInteger totMoney,maxtiqumoney; //选中红包总金额
    MaskView *makView;
    NSString *stats;
    UIView *headView;
    NSMutableArray *hongbIdAry;
    NSMutableArray *userDataAry;
    OnLinePayView *rechargePopView;//充值弹框
    NSInteger popTag;
    NSString *payMonyeNumStr;//充值金额
    SetPaymentPasswordView *nextPayPas;//支付密码
    MaskView *maskView;//遮罩层
    NSString *isPasdStr;
    NSMutableDictionary *wxPaymessage;
    CGFloat maxReceive;//最高领取
    MBProgressHUD *ddHud;
}
@end
@implementation MeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"orderYouhActess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAgin) name:@"userLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"tixianAccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber) name:@"changeNumberNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"chongzhiSueecss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"newGoodNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"orderCreatSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
//    [self onlyLognUser];
    [self reloadUserData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [ddHud hide:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    tolMoneyData = [[NSMutableArray alloc]init];
    userDataAry= [[NSMutableArray alloc]init];
    hongbIdAry = [[NSMutableArray alloc]init];
    wxPaymessage = [[NSMutableDictionary alloc]init];
    stateNum = 1;
    rzcode = 1;
    balance = 0.00;
    totcount = 0;
    totMoney = 0;
    popTag = -1;
    maxReceive = 10.0;
    isPasdStr = @"1";
    payMonyeNumStr =@"50.0";
    [self loadNavigation];
    [self initTableView];
    [self popViewshare];
    [self reloadPopViewData];
    [self relodpayPaswd];
    [self maskView];
    [self initPayPopView];
    [self payPasword];
    [self initMaskView];
}
//-(void)onlyLognUser
//{
//    mainController *main = (mainController *)self.tabBarController;
//    [main tabarNoEnable:0];
//    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"user.shebeiId":userSheBei_id}];
//    [HTTPTool getWithUrl:@"findxulehao.action" params:pram success:^(id json) {
//        if ([[json valueForKey:@"masssages"] isEqualToString:@"1"]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"异常提示" message:@"您的账号在其他地方登陆,如非本人操作,则密码可能泄露,建议到安全设置修改密码" preferredStyle:1];
//            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                exit(0);
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//                [def setInteger:0 forKey:@"isLogin"];
//                
//                [def setValue:userSheBei_id forKey:@"userId"];
//                mainController *main = (mainController *)self.tabBarController;
//                main.controlShowStyle = 1;
//                [main showOrHiddenTabBarView:NO];
//                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"xrlTapNum"];
//                NSNotification *userExitNotification = [NSNotification notificationWithName:@"userExitFication" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:userExitNotification];
//                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userExitFication" object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//                [main tabarNoEnable:1];
//            }];
//            [main tabarNoEnable:1];
//            [alert addAction:suerAction];
//            [alert addAction:cancelAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        [main tabarNoEnable:1];
//    } failure:^(NSError *error) {
//        [main tabarNoEnable:1];
//    }];
//}
//导航栏
-(void)loadNavigation
{
    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}
-(void)loginAgin
{
    totMoney = 0;
    [self reloadUserData];
    [self reloadPopViewData];
}
//改变绑定手机号码
-(void)changeNumber
{
    UILabel *lab = (UILabel *)[headView viewWithTag:103];
    lab.text = [userName_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
}
//用户信息
-(void)reloadUserData
{
    ddHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ddHud.mode = MBProgressHUDModeIndeterminate;
    ddHud.delegate = self;
    ddHud.labelText = @"请稍等...";
    [ddHud show:YES];
    [userDataAry removeAllObjects];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"tel":userName_tel,@"shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"gerenzhongxin.action" params:pram success:^(id json) {
        [ddHud hide:YES];
        NSArray *ary = [json valueForKey:@"userinfo"];
        if (ary.count > 0) {
            for(NSDictionary *dic in ary){
                userMessModel *mod = [[userMessModel alloc]initWithContent:dic];
                [userDataAry addObject:mod];
            }
            [personTabelView reloadData];
            [self relodheadView];
        }
    } failure:^(NSError *error) {
        [ddHud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
///推荐红包金额
-(void)reloadPopViewData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"tel":userShequ_id}];
    [HTTPTool getWithUrl:@"jiangli.action" params:pram success:^(id json) {
        NSArray *ary = [json valueForKey:@"jiangli"];
        NSString *stri = [json valueForKey:@"totalmoney"];
        stats = [NSString stringWithFormat:@"%@",[json valueForKey:@"status"]];
        maxReceive = [[json valueForKey:@"maxjine"] floatValue];
        [tolMoneyData removeAllObjects];
        maxtiqumoney = [stri integerValue];
        NSIndexPath *indpath = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell = [personTabelView cellForRowAtIndexPath:indpath];
        UILabel *lab = (UILabel *)[cell viewWithTag:203];
        UIImageView *img = (UIImageView *)[cell viewWithTag:204];
        lab.text = @"";
        if (ary.count>0) {
            [tolMoneyData removeAllObjects];
            for(NSDictionary *dic in ary){
                redMoneyModel *mod = [[redMoneyModel alloc]initWithContent:dic];
                [tolMoneyData addObject:mod];
            }
            [self popViewshare];
            lab.text = [NSString stringWithFormat:@"好友%ld奖励%ld元",(long)tolMoneyData.count,(long)maxtiqumoney];
            img.alpha = 0;
            cell.userInteractionEnabled = YES;
        }
        else{
            lab.text = @"暂无好友奖励";
            img.alpha =1;
            cell.userInteractionEnabled = NO;
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)relodpayPaswd
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"zhiFuPwd.action" params:pram success:^(id json) {
        isPasdStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
    } failure:^(NSError *error) {
        
    }];
}
//表视图
-(void)initTableView
{
    personTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-49) style:UITableViewStyleGrouped];
    personTabelView.delegate = self;
    personTabelView.dataSource = self;
    personTabelView.backgroundColor = [UIColor whiteColor];
    personTabelView.scrollEnabled = NO;
    personTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeadView];
    [self.view addSubview:personTabelView];
    
}
//充值弹框
-(void)initPayPopView
{
    rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
    rechargePopView.isFrom = 2;
    rechargePopView.onLinePayDelegate = self;
}
#pragma mark -- OnLinePayViewDelegate
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money
{
    [self morePayWay];
}

//接受来自onLinePayDelegate的通知实现方法
-(void)PaymentSuccessClick:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
    makView.alpha = 0;
    rechargePopView.alpha = 0;
    [makView removeFromSuperview];
    [rechargePopView removeFromSuperview];
}];
    
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"充值成功";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"充值失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

//遮罩
-(void)maskView
{
    makView = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    makView.backgroundColor = [UIColor clearColor];
    makView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mskdiss)];
    [makView addGestureRecognizer:tap];
}
-(void)mskdiss
{
    [UIView animateWithDuration:0.3 animations:^{
        makView.alpha = 0;
        rechargePopView.alpha = 0;
        pView.alpha = 0;
        [makView removeFromSuperview];
        [rechargePopView removeFromSuperview];
        [pView removeFromSuperview];
    }];
}
-(void)initHeadView
{
    //表头
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 185*MCscale)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 116*MCscale)];
    backImage.image = [UIImage imageNamed:@"个人中心背景图.jpg"];
    [headView addSubview:backImage];
    //用户头像
    favicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 73*MCscale, 73*MCscale)];
    favicon.center = CGPointMake(kDeviceWidth/2.0, 42*MCscale);
    favicon.image = [UIImage imageNamed:@"个人中心held"];
    favicon.contentMode = UIViewContentModeScaleAspectFit;
    favicon.layer.cornerRadius = 36.5*MCscale;
    favicon.layer.masksToBounds = YES;
    favicon.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseUserHeadimage)];
    [favicon addGestureRecognizer :chooseTap];
    [headView addSubview:favicon];
    //认证图标
    NSArray *rzArray = @[@"认证",@"未认证"];
    rzImage = [[UIImageView alloc]initWithFrame:CGRectMake(favicon.right-20*MCscale, favicon.bottom-22*MCscale, 25*MCscale, 25*MCscale)];
    rzImage.image = [UIImage imageNamed:rzArray[rzcode]];
    [headView addSubview:rzImage];
    //账户
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, favicon.width+20*MCscale, 20*MCscale)];
    accountLabel.center = CGPointMake(kDeviceWidth/2.0, favicon.bottom+15*MCscale);
    accountLabel.tag = 103;
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.font = [UIFont systemFontOfSize:MLwordFont_8];
    accountLabel.textColor = [UIColor blackColor];
    accountLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:accountLabel];
    //余额
    UILabel *lanceLabe =[[UILabel alloc]initWithFrame:CGRectMake(0, backImage.bottom+12*MCscale, kDeviceWidth/2, 20*MCscale)];
    lanceLabe.backgroundColor = [UIColor clearColor];
    lanceLabe.font = [UIFont systemFontOfSize:MLwordFont_2];
    lanceLabe.textAlignment = NSTextAlignmentCenter;
    lanceLabe.textColor = txtColors(233, 67, 67, 1);
    lanceLabe.tag = 101;
    lanceLabe.text = [NSString stringWithFormat:@"%.2f",balance];
    [headView addSubview:lanceLabe];
    UILabel *lance = [[UILabel alloc]initWithFrame:CGRectMake(0, lanceLabe.bottom, lanceLabe.width, 20*MCscale)];
    lance.text = @"余额";
    lance.tag = 104;
    lance.backgroundColor = [UIColor clearColor];
    lance.font = [UIFont systemFontOfSize:MLwordFont_5];
    lance.textAlignment = NSTextAlignmentCenter;
    lance.textColor = txtColors(72, 73, 74, 1);
    [headView addSubview:lance];
    //分割线
    UIView *sepView1 = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2, backImage.bottom+3*MCscale,0.5, 60*MCscale)];
    sepView1.backgroundColor = lineColor;
    [headView addSubview:sepView1];
    //优惠
    UILabel *coupLabe =[[UILabel alloc]initWithFrame:CGRectMake(lanceLabe.right, backImage.bottom+12*MCscale, kDeviceWidth/2, 20*MCscale)];
    coupLabe.backgroundColor = [UIColor clearColor];
    coupLabe.text = @"0";
    coupLabe.font = [UIFont systemFontOfSize:MLwordFont_2];
    coupLabe.textAlignment = NSTextAlignmentCenter;
    coupLabe.textColor = txtColors(49, 110, 0, 1);
    coupLabe.tag = 102;
    [headView addSubview:coupLabe];
    UILabel *coup = [[UILabel alloc]initWithFrame:CGRectMake(coupLabe.left, lanceLabe.bottom, lanceLabe.width, 20*MCscale)];
    coup.text = @"优惠";
    coup.backgroundColor = [UIColor clearColor];
    coup.font = [UIFont systemFontOfSize:MLwordFont_5];
    coup.textAlignment = NSTextAlignmentCenter;
    coup.textColor = txtColors(72, 73, 74, 1);
    [headView addSubview:coup];
    
    UIButton *lanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lanceBtn.backgroundColor = [UIColor clearColor];
    lanceBtn.frame = CGRectMake(5, backImage.bottom+12*MCscale, kDeviceWidth/2.0-10*MCscale, 50*MCscale);
    lanceBtn.tag = 1001;
    [lanceBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:lanceBtn];
    
    UIButton *coupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coupBtn.frame = CGRectMake(kDeviceWidth/2.0 +5*MCscale, lanceBtn.top, kDeviceWidth/2.0 - 10*MCscale, 50*MCscale);
    coupBtn.tag = 1002;
    coupBtn.backgroundColor = [UIColor clearColor];
    [coupBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:coupBtn];
    personTabelView.tableHeaderView = headView;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height - 1*MCscale, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [headView addSubview:line];
}
-(void)payPasword
{
    nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    nextPayPas.setPaymentDelegate = self;
    nextPayPas.alpha = 0;
    nextPayPas.tag = 101;
}

#pragma mark SetPaymentPasswordViewDelegate
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改密码成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            nextPayPas.alpha = 0;
            [nextPayPas removeFromSuperview];
        }];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改失败!请稍后再试";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
//遮罩视图
-(void)initMaskView
{
    maskView = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [maskView addGestureRecognizer:tap];
}
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        nextPayPas.alpha = 0;
        [self.view endEditing:YES];
        [nextPayPas removeFromSuperview];
    }];
}
//给表头赋值
-(void)relodheadView
{
    userMessModel *mod = userDataAry[0];
    //余额
    UILabel *yelb = (UILabel *)[headView viewWithTag:101];
    UILabel *yeStrl = (UILabel *)[headView viewWithTag:104];
    CGFloat uye = [mod.yue floatValue];
    if (uye <=0) {
        yelb.text = @"去充值";
        yelb.textColor = txtColors(5, 170, 131, 1);
        yeStrl.text = @"开启余额支付功能";
        yeStrl.textColor = txtColors(254, 42, 68, 0.9);
    }
    else{
        yelb.text = [NSString stringWithFormat:@"%.2f",uye];
        yelb.textColor = txtColors(254, 42, 68, 0.9);
        yeStrl.text = @"余额";
        yeStrl.textColor = txtColors(72, 73, 74, 1);
    }
    //优惠
    UILabel *youhLb = (UILabel *)[headView viewWithTag:102];
    youhLb.text = [NSString stringWithFormat:@"%@",mod.youhuiquancount];
    [[NSUserDefaults standardUserDefaults] setValue:mod.youhuiquancount forKey:@"youhuiquancount"];
    //个人头像
    [favicon sd_setImageWithURL:[NSURL URLWithString:mod.headImg] placeholderImage:[UIImage imageNamed:@"个人中心held"] options:SDWebImageRefreshCached];
    //userName
    UILabel *lab = (UILabel *)[headView viewWithTag:103];
    lab.text = [userName_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    if([mod.renzheng integerValue]){
        rzImage.image = [UIImage imageNamed:@"认证"];
    }
    else{
        rzImage.image = [UIImage imageNamed:@"未认证"];
    }
}
#pragma mark  账户
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        userMessModel *mod = userDataAry[0];
        CGFloat uye = [mod.yue floatValue];
        if (uye<=0) {
            [UIView animateWithDuration:0.3 animations:^{
                rechargePopView.alpha = 0.95;
                makView.alpha = 1;
                [self.view addSubview:makView];
                rechargePopView.moneyTextFiled.text = @"50";
                rechargePopView.yueZhifu.text = @"更多充值方式";
                [self.view addSubview:rechargePopView];
            }];
        }
        else{
            balanceViewController *balvc = [[balanceViewController alloc]init];
            balvc.ketixMoney=((userMessModel*)userDataAry.firstObject).yue;
            [self.navigationController pushViewController:balvc animated:YES];
        }
    }
    else if (btn.tag == 1002) {
        couponViewController *coupVc = [[couponViewController alloc]init];
        [self.navigationController pushViewController:coupVc animated:YES];
    }
}
#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identificer = @"cell";
    NSArray *imageArray = @[@"我的收藏",@"安全设置",@"推荐",@"客服-全黑",@"意见反馈"];
    NSArray *titleArray = @[@"我的收藏",@"安全设置",@"推荐免费领现金",@"我的客服",@"更多..."];
    NSArray *safeImageArray = @[@"安全状态-差",@"安全状态-低",@"安全状态-中",@"安全状态-高"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificer];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 15/MCscale, 20*MCscale, 20*MCscale)];
        image.backgroundColor = [UIColor clearColor];
        image.tag = 201;
        [cell addSubview:image];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(image.right+5*MCscale, 6/SCscale1, 180*MCscale, 40*MCscale)];
        title.tag = 202;
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:MLwordFont_3];
        title.textColor = txtColors(72, 73, 74, 1);
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-25*MCscale, 15/MCscale, 15*MCscale, 20*MCscale)];
        arrowImage.image = [UIImage imageNamed:@"下拉键"];
        arrowImage.backgroundColor = [UIColor clearColor];
        [cell addSubview:arrowImage];
        
        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        subTitle.tag = 203;
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.font = [UIFont systemFontOfSize:MLwordFont_6];
        [cell addSubview:subTitle];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.tag = 204;
        imageView.alpha = 0;
        imageView.image = [UIImage imageNamed:@"叹号"];
        imageView.backgroundColor = [UIColor clearColor];
        [cell addSubview:imageView];
        
        if (indexPath.row == 4) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height + 5*MCscale, kDeviceWidth,0.5)];
            line.backgroundColor = lineColor;
            [cell addSubview:line];
        }
        else
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale,cell.height + 5*MCscale, kDeviceWidth - 20*MCscale,0.5)];
            line.backgroundColor = lineColor;
            [cell addSubview:line];
        }
    }
    UIImageView *image = (UIImageView *)[cell viewWithTag:201];
    UILabel *label = (UILabel *)[cell viewWithTag:202];
    image.image = [UIImage imageNamed:imageArray[indexPath.row]];
    label.text = titleArray[indexPath.row];
    if (indexPath.row == 1) {
        UILabel *subTitle = (UILabel *)[cell viewWithTag:203];
        subTitle.frame = CGRectMake(kDeviceWidth-150*MCscale, 15/MCscale, 98*MCscale, 20*MCscale);
        subTitle.text = @"账号安全状态";
        subTitle.textColor = txtColors(72, 73, 74, 0.9);
        UIImageView *stateImage = (UIImageView *)[cell viewWithTag:204];
        stateImage.frame = CGRectMake(subTitle.right+2*MCscale, 16/MCscale, 17*MCscale, 17*MCscale);
        stateImage.alpha =1;
        if (userDataAry.count>0) {
            userMessModel *mod = userDataAry[0];
            stateNum = [mod.anquanjibie integerValue]-1;
        }
        stateImage.image = [UIImage imageNamed:safeImageArray[stateNum]];
    }
    if (indexPath.row == 2) {
        UIImageView *stateImage = (UIImageView *)[cell viewWithTag:204];
        stateImage.frame = CGRectMake(kDeviceWidth-(45*MCscale+110*MCscale), 16/MCscale, 18*MCscale, 18*MCscale);
        UILabel *subTitle = (UILabel *)[cell viewWithTag:203];
        subTitle.textColor = txtColors(254, 42, 68, 0.9);
        subTitle.frame = CGRectMake(stateImage.right+2, 15/MCscale, 110*MCscale, 20*MCscale);
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        myCollectViewController *myCollect = [[myCollectViewController alloc]init];
        [self.navigationController pushViewController:myCollect animated:YES];
    }
    else if (indexPath.row == 1) {
        securitySetViewController *vc = [[securitySetViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2){
        if (tolMoneyData.count>0){
            popTag = 10101;
            makView.alpha =1;
            pView.alpha = 0.95;
            [self.view addSubview:makView];
            [self.view addSubview:pView];
        }
    }
    else if (indexPath.row==3) {
        helpCenterViewController *agr = [[helpCenterViewController alloc]init];
        agr.pageUrl = [NSString stringWithFormat:@"http://www.m1ao.com/Mshc/gonggao/guanyuwenti.jsp"];
        agr.titStr = @"我的客服";
        [self.navigationController pushViewController:agr animated:YES];
    }
    else{
        //        feedbackViewController *feedbackVC = [[feedbackViewController alloc]init];
        MoreViewController *vc = [[MoreViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*MCscale;
}
//推荐领现金
-(void)popViewshare
{
    pView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 300*MCscale)];
    pView.backgroundColor = [UIColor whiteColor];
    pView.layer.cornerRadius = 15.0;
    pView.layer.shadowRadius = 5.0;
    pView.layer.shadowOpacity = 0.5;
    pView.layer.shadowOffset = CGSizeMake(0, 0);
    pView.tag = 10101;
    UIScrollView *scrllo = [[UIScrollView alloc]initWithFrame:CGRectMake(5*MCscale, 15*MCscale, pView.width-10*MCscale, 220*MCscale)];
    for (int i =0; i<tolMoneyData.count; i++) {
        redMoneyModel *mod = tolMoneyData[i];
        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 82*i*MCscale, pView.width-10*MCscale, 80*MCscale)];
        vie.tag = i+1;
        [scrllo addSubview:vie];
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*MCscale, 30*MCscale, 22*MCscale, 22*MCscale)];
        imgv.backgroundColor = [UIColor clearColor];
        imgv.image = [UIImage imageNamed:@"选择"];
        imgv.tag = 1001;
        imgv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseAction:)];
        [vie addGestureRecognizer:tp];
        [vie addSubview:imgv];
        
        UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(imgv.right+15*MCscale, 2, 74*MCscale, 74*MCscale)];
        logoImage.image = [UIImage imageNamed:@"现金"];
        
        UILabel *mlb = [[UILabel alloc]initWithFrame:CGRectMake(32*MCscale, 15*MCscale, 20*MCscale, 20*MCscale)];
        mlb.text = [NSString stringWithFormat:@"%@",mod.money];
        mlb.textColor = redTextColor;
        mlb.textAlignment = NSTextAlignmentCenter;
        mlb.font = [UIFont systemFontOfSize:MLwordFont_2];
        [logoImage addSubview:mlb];
        [vie addSubview:logoImage];
        
        UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(logoImage.right+5*MCscale, 30*MCscale, 65*MCscale, 20*MCscale)];
        lb1.text = @"好友账号:";
        lb1.textAlignment = NSTextAlignmentLeft;
        lb1.backgroundColor = [UIColor clearColor];
        lb1.font = [UIFont systemFontOfSize:MLwordFont_7];
        [vie addSubview:lb1];
        
        UILabel *lb11 = [[UILabel alloc]initWithFrame:CGRectMake(lb1.right, 30*MCscale, 90*MCscale, 20*MCscale)];
        if (![mod.jieshouzhe isEqual:[NSNull null]]) {
            lb11.text = [mod.jieshouzhe stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        }
        else
            lb11.text = @"妙生活城";
        lb11.textAlignment = NSTextAlignmentLeft;
        lb11.backgroundColor = [UIColor clearColor];
        lb11.font = [UIFont systemFontOfSize:MLwordFont_7];
        [vie addSubview:lb11];
        
        UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(logoImage.right+5*MCscale, lb1.bottom, 40*MCscale, 20*MCscale)];
        lb2.text = @"状态:";
        lb2.textAlignment = NSTextAlignmentLeft;
        lb2.backgroundColor = [UIColor clearColor];
        lb2.font = [UIFont systemFontOfSize:MLwordFont_7];
        [vie addSubview:lb2];
        
        UILabel *lb22 = [[UILabel alloc]initWithFrame:CGRectMake(lb2.right, lb1.bottom, 40*MCscale, 20*MCscale)];
        if ([mod.status integerValue]==2) {
            lb22.text = @"注册";
        }
        else if ([mod.status integerValue]==3){
            lb22.text = @"使用";
        }
        lb22.textAlignment = NSTextAlignmentLeft;
        lb22.backgroundColor = [UIColor clearColor];
        lb22.font = [UIFont systemFontOfSize:MLwordFont_7];
        [vie addSubview:lb22];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, logoImage.bottom+2, pView.width-20*MCscale, 1)];
        line.backgroundColor = lineColor;
        [vie addSubview:line];
    }
    scrllo.contentSize = CGSizeMake(pView.width-10*MCscale, 82*tolMoneyData.count*MCscale);
    [pView addSubview:scrllo];
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, 245*MCscale, pView.width-40, 40*MCscale)];
    btnView.layer.cornerRadius = 7.0*MCscale;
    btnView.layer.masksToBounds = YES;
    btnView.tag = 1002;
    [pView addSubview:btnView];
    
    UILabel *moyLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, 10*MCscale, 40*MCscale, 20*MCscale)];
    moyLab.textColor = [UIColor yellowColor];
    moyLab.text = @"¥0";
    moyLab.tag = 1003;
    moyLab.textAlignment = NSTextAlignmentCenter;
    moyLab.font = [UIFont systemFontOfSize:MLwordFont_2];
    [btnView addSubview:moyLab];
    
    UILabel *chaoblb = [[UILabel alloc]initWithFrame:CGRectMake(moyLab.right+5*MCscale, 15*MCscale, 120*MCscale, 15*MCscale)];
    chaoblb.alpha = 0;
    chaoblb.tag = 1004;
    chaoblb.text = [NSString stringWithFormat:@"本次最高提取金额¥%ld",(long)maxtiqumoney];
    chaoblb.textColor  =textBlackColor;
    chaoblb.font = [UIFont systemFontOfSize:MLwordFont_9];
    [btnView addSubview:chaoblb];
    
    UILabel *lingqLab = [[UILabel alloc]initWithFrame:CGRectMake(btnView.right-100*MCscale, 10*MCscale, 60*MCscale, 20*MCscale)];
    lingqLab.textColor = [UIColor whiteColor];
    lingqLab.textAlignment = NSTextAlignmentLeft;
    lingqLab.font = [UIFont systemFontOfSize:MLwordFont_5];
    lingqLab.text = @"领现金";
    
    UILabel *mesLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, 0, btnView.width-20*MCscale, 40*MCscale)];
    mesLab.text = @"今天已经领过!请明天再来";
    mesLab.alpha = 0;
    mesLab.textColor = textBlackColor;
    mesLab.font = [UIFont systemFontOfSize:MLwordFont_5];
    mesLab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:mesLab];
    [btnView addSubview:lingqLab];
    if ([stats isEqualToString:@"0"]) {
        btnView.backgroundColor = redTextColor;
        btnView.userInteractionEnabled = YES;
    }
    else{
        btnView.backgroundColor = lineColor;
        btnView.userInteractionEnabled = NO;
        moyLab.alpha = 0;
        lingqLab.alpha = 0;
        mesLab.alpha = 1;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewAction:)];
    [btnView addGestureRecognizer:tap];
}
//领取现金 Action
-(void)popViewAction:(UITapGestureRecognizer *)tap
{
    if (totMoney>maxReceive) {
        NSString *maxMoney = [NSString stringWithFormat:@"最高领取金额为%.f元",maxReceive];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = maxMoney;
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        NSString *hbidStr = [hongbIdAry componentsJoinedByString:@","];
        NSString *mony = [NSString stringWithFormat:@"%ld",(long)totMoney];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"jine":mony,@"youhuiquanid":hbidStr}];
        [HTTPTool getWithUrl:@"lingquJiangli.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                [self mskdiss];
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"领取现金成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [self loginAgin];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
-(void)choseAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    redMoneyModel *mod = tolMoneyData[view.tag-1];
    NSInteger num = [mod.money integerValue];
    NSString *hbid =[NSString stringWithFormat:@"%@",mod.hongbaoid];
    UIImageView *img = (UIImageView *)[view viewWithTag:1001];
    if ([img.image isEqual:[UIImage imageNamed:@"选中"]]) {
        img.image = [UIImage imageNamed:@"选择"];
        totMoney = totMoney-num;
        for (int i = 0; i<hongbIdAry.count; i++) {
            NSString *str = hongbIdAry[i];
            if ([str isEqualToString:hbid]) {
                [hongbIdAry removeObjectAtIndex:i];
                break;
            }
        }
    }
    else{
        img.image = [UIImage imageNamed:@"选中"];
        totMoney = totMoney+num;
        [hongbIdAry addObject:hbid];
    }
    UIView *btView = [pView viewWithTag:1002];
    UILabel *mlb = [btView viewWithTag:1003];
    UILabel *tlb = [btView viewWithTag:1004];
    if ([stats isEqualToString:@"0"]) {
        if (totMoney>maxtiqumoney) {
            tlb.alpha = 1;
            btView.userInteractionEnabled = NO;
            btView.backgroundColor = lineColor;
        }
        else{
            tlb.alpha = 0;
            btView.userInteractionEnabled = YES;
            btView.backgroundColor = redTextColor;
        }
    }
    mlb.text = [NSString stringWithFormat:@"¥%ld",(long)totMoney];
}
-(void)popSetPasdView
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha =1;
        nextPayPas.alpha = 0.95;
        nextPayPas.isFrom = 2;
        NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
        [nextPayPas getTextFieldPlaceholderWithArray:array];
        [self.view addSubview:maskView];
        [self.view addSubview:nextPayPas];
    }];
}
//选择更多充值方法
-(void)morePayWay
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeText;
    mbHud.labelText = @"暂无更多的充值方式";
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
//选择头像
-(void)chooseUserHeadimage
{
    if (imagePick == nil) {
        imagePick = [[UIImagePickerController alloc]init];
    }
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    imagePick.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UIAlertController  *alte = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:0];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePick animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePick animated:YES completion:nil];
    }];
    UIAlertAction *cleAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alte addAction:cancleAction];
    [alte addAction:otherAction];
    [alte addAction:cleAction];
    [self presentViewController:alte animated:YES completion:nil];
}
//相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        favicon.image = image;
    }];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool postWithUrl:@"fileUp.action" params:pram image:image success:^(id json) {
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"头像更换成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
-(void)mTsak
{
    sleep(2.5);
}

@end
