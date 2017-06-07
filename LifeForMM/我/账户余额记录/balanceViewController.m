//
//  balanceViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/24.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "balanceViewController.h"
#import "Header.h"
#import "getBalanceViewController.h"
#import "blanceModel.h"
#import "balanceCell.h"
#import "OnLinePayView.h"
#import "Order.h"
#import "DataSigner.h"
#import "MaskView.h"
#import "PaymentPasswordView.h"
#import "SetPaymentPasswordView.h"
@interface balanceViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,PaymentPasswordViewDelegate,OnLinePayViewDelegate,SetPaymentPasswordViewDelegate>
{
    UITableView *listTabel;
    
    UILabel *moneyLb;//
    NSMutableArray *balabce_paymentDatAry;//收支数据
    MBProgressHUD *Hud;
    NSInteger lastChoose;
    NSString *payMonyeNumStr;
    UIView *maskView;//遮罩层
    OnLinePayView *rechargePopView;//充值弹框
    SetPaymentPasswordView *nextPayPas;//支付密码
    MaskView *masView;//遮罩层
    NSString *isPasdStr;
    PaymentPasswordView *passPopView;
}
@end

@implementation balanceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tixiansuccess) name:@"tixianAccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllData) name:@"chongzhiSueecss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    [self getAllData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    payMonyeNumStr = @"50.0";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    balabce_paymentDatAry = [[NSMutableArray alloc]init];
    lastChoose = 10;
    isPasdStr = @"1";
    [self initNavigation];
    [self initTableView];
    [self getAllData];
    [self initPayPopView];
    [self initMaskView];
    [self relodpayPaswd];
    [self payPasword];
    [self initMask];
    [self initPaymentPasswordView];
    [self reshView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"账户余额记录";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)getAllData
{
    [balabce_paymentDatAry removeAllObjects];
    [self shopMessageData];
}

-(void)tixiansuccess
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"提现成功";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self getAllData];
}

-(void)relodpayPaswd
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"zhiFuPwd.action" params:pram success:^(id json) {
        isPasdStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
    } failure:^(NSError *error) {
        
    }];
}
//收支明细信息
-(void)shopMessageData
{

    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"findbyuseridday.action" params:pram success:^(id json) {
        NSArray *ary = [json valueForKey:@"jilushow"];
        if (ary.count > 0) {
            for(NSDictionary *dic in ary){
                blanceModel *model = [[blanceModel alloc]initWithContent:dic];
                [balabce_paymentDatAry addObject:model];
            }
//            blanceModel *md = balabce_paymentDatAry[0];
//            CGFloat yue = [md.money floatValue];
            [listTabel reloadData];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误1";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)reshView{
    moneyLb.text = [NSString stringWithFormat:@"%@元",_ketixMoney];
}
//遮罩视图
-(void)initMask
{
    masView = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    masView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [masView addGestureRecognizer:tap];
}
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        masView.alpha = 0;
        [masView removeFromSuperview];
        nextPayPas.alpha = 0;
        [self.view endEditing:YES];
        [nextPayPas removeFromSuperview];
    }];
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

//表
-(void)initTableView
{
    listTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    listTabel.backgroundColor = [UIColor whiteColor];
    listTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTabel.delegate = self;
    listTabel.dataSource = self;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , 140*MCscale_1)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, 100*MCscale, 20*MCscale)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"当前余额";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_5];
    [headView addSubview:label];
    
    moneyLb = [[UILabel alloc]initWithFrame:CGRectMake(54*MCscale, 35*MCscale_1, 180*MCscale, 40*MCscale)];
    moneyLb.backgroundColor = [UIColor clearColor];
    moneyLb.text = @"0.0元";
    moneyLb.textAlignment = NSTextAlignmentLeft;
    moneyLb.textColor = txtColors(248, 53, 74, 1);
    moneyLb.font = [UIFont boldSystemFontOfSize:MLwordFont_1];
    [headView addSubview:moneyLb];
    
    UIButton *removeMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    removeMoney.frame = CGRectMake(30*MCscale, 88*MCscale_1, kDeviceWidth/3.0+10*MCscale, MCbtnHeight);
    removeMoney.backgroundColor = txtColors(248, 53, 74, 1);
    [removeMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeMoney setTitle:@"余额提现" forState:UIControlStateNormal];
    removeMoney.tag = 101;
    removeMoney.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_11];
    [removeMoney addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    removeMoney.layer.cornerRadius = 3.0;
    removeMoney.layer.masksToBounds = YES;
    [headView addSubview:removeMoney];
    
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    pay.frame = CGRectMake(kDeviceWidth*2/3.0-40*MCscale, 88*MCscale_1, kDeviceWidth/3.0+10*MCscale, MCbtnHeight);
    pay.backgroundColor = txtColors(25, 182, 133, 1);
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pay setTitle:@"充值" forState:UIControlStateNormal];
    pay.tag = 102;
    pay.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_11];
    [pay addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    pay.layer.cornerRadius = 3.0;
    pay.layer.masksToBounds =YES;
    [headView addSubview:pay];
    listTabel.tableHeaderView = headView;
    [self.view addSubview:listTabel];
}
//充值弹框
-(void)initPayPopView
{
    rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
    rechargePopView.isFrom = 2;
    rechargePopView.onLinePayDelegate = self;
}
//遮罩层
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewAction)];
    [maskView addGestureRecognizer:maskTap];
}
#pragma mark -- OnLinePayViewDelegate
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money
{
    [self morePayWay];
}

//接受来自支付成功的通知实现方法
-(void)PaymentSuccessClick:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        rechargePopView.alpha = 0;
        [rechargePopView removeFromSuperview];
    }];
    
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付成功";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    [self getAllData];
}
-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return balabce_paymentDatAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    balanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[balanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.bModel = balabce_paymentDatAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*MCscale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , 30*MCscale)];
    secHeadView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [secHeadView addSubview:line];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale, 5*MCscale, 200*MCscale, 20*MCscale)];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,label.bottom + 5*MCscale, kDeviceWidth, 0.5)];
    line1.backgroundColor = lineColor;
    [secHeadView addSubview:line1];
    if (balabce_paymentDatAry.count>0) {
        label.text = @"最近30天收支明细";
    }
    else
        label.text = @"";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_5];
    [secHeadView addSubview:label];
    return secHeadView;
}
-(void)popSetPasdView
{
    [UIView animateWithDuration:0.3 animations:^{
        masView.alpha =1;
        nextPayPas.alpha = 0.95;
        [self.view addSubview:masView];
        nextPayPas.isFrom = 2;
        NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
        [nextPayPas getTextFieldPlaceholderWithArray:array];
        [self.view addSubview:nextPayPas];
    }];
}
#pragma mark btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    if (btn.tag == 101) {
        
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
        [HTTPTool getWithUrl:@"checkTixianInfo.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue] == 1) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self .view addSubview:maskView];
                    passPopView.alpha = 0.95;
                    [self.view addSubview:passPopView];
                }];
            }
            else if([[json valueForKey:@"message"]integerValue] == 2){
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"今天已经提现过";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else if([[json valueForKey:@"message"]integerValue] == 3){
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"无可提现金额";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else
            {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"用户没有设置支付密码";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误2";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    if (btn.tag == 102) {
        [UIView animateWithDuration:0.3 animations:^{
            rechargePopView.alpha = 0.95;
            maskView.alpha = 1;
            [self.view addSubview:maskView];
            rechargePopView.moneyTextFiled.text = @"50";
            rechargePopView.yueZhifu.text = @"更多充值方式";
            [self.view addSubview:rechargePopView];
        }];
    }
}
//支付密码
-(void)initPaymentPasswordView
{
    //支付密码
    passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
    passPopView.paymentPasswordDelegate = self;
    passPopView.alpha = 0;
}

#pragma  mark  PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    
    getBalanceViewController *balVc = [[getBalanceViewController alloc]init];
    [self reshView];

    [self.navigationController pushViewController:balVc animated:YES];
}
//遮罩层事件
-(void)maskViewAction
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        rechargePopView.alpha = 0;
        passPopView.alpha = 0;
        [rechargePopView removeFromSuperview];
        [passPopView removeFromSuperview];
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

-(void)myTask
{
    sleep(1.5);
}
-(void)mtask
{
    sleep(2.5);
}
@end
