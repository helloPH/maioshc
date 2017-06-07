//
//  OrderViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "OrderViewController.h"
#import "Header.h"
#import "orderViewCell.h"
#import "oldOrderViewCell.h"
#import "orderDetailViewController.h"
#import "orderEvaluateViewController.h"
#import "OnlineServiceViewController.h"
#import "NewFunctionViewController.h"
#import "MaskView.h"
#import "Order.h"
#import "DataSigner.h"
#import "PaymentPasswordView.h"
#import "OnLinePayView.h"
#import "OrderExceptionPrompt.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,PaymentPasswordViewDelegate,OrderExceptionPromptDelegate>
{
    UIView *orderView,*btnView,*lineView;//商品、店铺
    UITableView *orderTableView;//商品表、店铺表
    BOOL btBool;//选择按钮表示
    NSMutableArray *recentDataAry;//近期订单
    NSMutableArray *oldDataAry;//历史订单
    BOOL isFirst;//第一次点击历史订单
    BOOL isRefresh;
    NSInteger loadType,page;
    BOOL isfistRelod;
    UIView *newFunctionView;
    PaymentPasswordView *passPopView;//密码输入
    NSMutableArray *passArray;//密码
    NSArray *numBtnTitleAry;//按钮数字
    NSMutableArray *labelAry;//密码输入框
    NSMutableArray *btnArray;//数字键
    NSInteger tapNumber;//点击次数
    MaskView *mask;//弹框遮罩层
    NSInteger selectCellRow;
    OnLinePayView *onlinePayWayPop;// 在线支付选择支付方式
    BOOL isOnlinePay; //在线支付
    NSMutableDictionary *wxPaymessage;
    UIImageView *caozuotishiImage;
    OrderExceptionPrompt *orderPromptView;
    UIView *updateBackgroundView;
}
@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"orderCreatSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"orderPingjiaNotfic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"userExitFication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"userLoginNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLinePayViewHidden) name:@"onLinePayViewHidden" object:nil];
//    [self onlyLognUser];
//    [self userExitRefresh];
    [self orderStatus];

}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    btBool = 0;
    isFirst = 0;
    isRefresh =0;
    isfistRelod = 0;
    tapNumber = 0;
    selectCellRow = 0;
    recentDataAry = [[NSMutableArray alloc]init];
    oldDataAry = [[NSMutableArray alloc]init];
    passArray = [[NSMutableArray alloc]init];
    numBtnTitleAry = [[NSArray alloc]init];
    labelAry = [[NSMutableArray alloc]init];
    btnArray = [[NSMutableArray alloc]init];
    wxPaymessage = [[NSMutableDictionary alloc]init];
    [self loadNavigation];
    [self initGoodView];
    [self reloadData];
    [self reloadGesture];
    [self refresh];
    [self initNewFunchionView];
    [self maskView];
    [self initPaymentPasswordView];
    [self judgeTheFirst];
}

-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstOrder"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/kefu.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
        caozuotishiImage.alpha = 0.9;

        caozuotishiImage.userInteractionEnabled = YES;
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [caozuotishiImage addGestureRecognizer:imageTap];
        [self.view addSubview:caozuotishiImage];
    }
}
-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstOrder"];
    [caozuotishiImage removeFromSuperview];
}
//判断订单状态
-(void)orderStatus
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"dingdanyichangchuli.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"]integerValue] == 1){
            NSArray *arr = [json valueForKey:@"list"];
            updateBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
            updateBackgroundView.backgroundColor = [UIColor clearColor];
           orderPromptView = [[OrderExceptionPrompt alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 270*MCscale)];
            orderPromptView.alpha = 0.95;
            orderPromptView.orderDelegate = self;
            mainController *main = (mainController *)self.tabBarController;
            [main tabarNoEnable:0];
            [self.view addSubview:updateBackgroundView];
            [self.view addSubview:orderPromptView];
            NSString *string = [arr componentsJoinedByString:@","];//--分隔符
            NSString *money = [NSString stringWithFormat:@"￥%@",[json valueForKey:@"money"]];
            NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
            NSString *nameStr;
            if ([sdf integerForKey:@"isLogin"]== 1) {
               nameStr = @"账户余额";
            }
            else
            {
                 nameStr = @"支付账号";
            }
            NSString *content = [NSString stringWithFormat:@"该订单(%@)由于网络异常未能形成,订单金额(%@)将在三个工作日内返回您的%@,请注意查收.由此给您带来的不便,敬请谅解!",string,money,nameStr];
            [orderPromptView getOrderPromptContentWithString:content];
        }
    } failure:^(NSError *error){
    }];
}

#pragma mark OrderExceptionPromptDelegate
-(void)titleViewHidden
{
    mainController *main = (mainController *)self.tabBarController;
    [main tabarNoEnable:1];
    [UIView animateWithDuration:0.3 animations:^{
//        mask.alpha = 0;
//        [mask removeFromSuperview];
        orderPromptView.alpha = 0;
        [orderPromptView removeFromSuperview];
        [updateBackgroundView removeFromSuperview];
    }];
}
//导航栏
-(void)loadNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    self.navigationItem.title = @"订单";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"客服-空白"] forState:UIControlStateNormal];
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)userExitRefresh
{
    isFirst = 0;
    [recentDataAry removeAllObjects];
//    [oldDataAry removeAllObjects];
    [self reloadData];
//    [self reloadLoadData];
}
//近期订单
-(void)reloadData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"pageNum":@"1"}];
    [HTTPTool getWithUrl:@"findjinqidingdan3.action" params:pram success:^(id json) {
        MyLog(@"---------%@",json);
        isfistRelod = 1;
        [Hud hide:YES];
        if(isRefresh){
            [self endRefresh:loadType];
        }
        orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
        if ([[json valueForKey:@"massages"]integerValue] == 1) {
            [recentDataAry removeAllObjects];
            [self.view addSubview:newFunctionView];
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
        }
        else{
            [newFunctionView removeFromSuperview];
            [recentDataAry removeAllObjects];
            NSArray *ary = [json valueForKey:@"diangdanlist"];
            for(NSDictionary *dic in ary){
                recentOrderModel *mod = [[recentOrderModel alloc]initWithContent:dic];
                [recentDataAry addObject:mod];
            }
        }
        [orderTableView reloadData];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self endRefresh:loadType];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//历史订单
-(void)reloadLoadData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"findlishidingdan.action" params:pram success:^(id json) {
        NSArray *ary = [json valueForKey:@"lishidingdan"];
        orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
        [newFunctionView removeFromSuperview];
        [Hud hide:YES];
        if(isRefresh){
            [self endRefresh:loadType];
        }
        if (ary.count >0) {
            [oldDataAry removeAllObjects];
            for(NSDictionary *dic in ary){
                oldOrderModel *mod = [[oldOrderModel alloc]initWithContent:dic];
                [oldDataAry addObject:mod];
            }
            [orderTableView reloadData];
        }
        else{
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
            [self.view addSubview:newFunctionView];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self endRefresh:loadType];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark -- 初始化视图
// 商品、店铺列表
-(void)initGoodView
{
    orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , kDeviceHeight)];
    orderView.backgroundColor = [UIColor clearColor];
    orderTableView = [[UITableView alloc]initWithFrame:orderView.bounds style:UITableViewStyleGrouped];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundColor = [UIColor whiteColor];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [orderView addSubview:orderTableView];
    [self.view addSubview:orderView];
    
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 38)];
    btnView.backgroundColor = [UIColor whiteColor];
    lineView = [[UIView alloc]initWithFrame:CGRectMake(35*MCscale, 36, kDeviceWidth/3.0, 2)];
    lineView.backgroundColor = txtColors(25, 182, 133, 1);
    [btnView addSubview:lineView];
    
    UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodBtn.frame = CGRectMake(0, 0, kDeviceWidth/2.0, 36);
    goodBtn.tag = 1001;
    goodBtn.backgroundColor = [UIColor clearColor];
    [goodBtn setTitle:@"近期订单" forState:UIControlStateNormal];
    [goodBtn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    [goodBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    goodBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    [btnView addSubview:goodBtn];
    
    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeBtn.frame = CGRectMake(kDeviceWidth/2.0, 0, kDeviceWidth/2.0, 36);
    storeBtn.tag = 1002;
    storeBtn.backgroundColor = [UIColor clearColor];
    [storeBtn setTitle:@"历史订单" forState:UIControlStateNormal];
    [storeBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    [btnView addSubview:storeBtn];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 37, kDeviceWidth, 1)];
    line1.backgroundColor = lineColor;
    [btnView addSubview:line1];
    [self.view addSubview:btnView];
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
        mask.alpha = 0;
        [mask removeFromSuperview];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    [self balancePay];
}
//余额支付
-(void)balancePay
{
    isOnlinePay = 0;
    recentOrderModel *model = recentDataAry[selectCellRow];
    NSString *payMoney = [NSString stringWithFormat:@"%@",model.chajia];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao,@"dindan.jine":payMoney}];
    [HTTPTool getWithUrl:@"savezhangdanchajia.action" params:pram success:^(id json) {
        NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        if ([message isEqualToString:@"1"]) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"支付成功";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [self userExitRefresh];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"支付失败!请稍后尝试";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//弹框遮罩
-(void)maskView
{
    mask = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    mask.alpha = 0;
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
}

//点击遮罩层
-(void)maskDisMiss
{
    if(!isOnlinePay){
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            passPopView.alpha = 0;
            [passPopView removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            onlinePayWayPop.alpha = 0;
            [onlinePayWayPop removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
}

//新功能
-(void)initNewFunchionView
{
    newFunctionView  =[[UIView alloc]initWithFrame:CGRectZero];
    if (IPHONE_Plus) {
        newFunctionView.frame = CGRectMake(kDeviceWidth*4/11+8, 315, 80, 133);
    }
    else
        newFunctionView.frame = CGRectMake(kDeviceWidth*4/11, 285*MCscale, 80*MCscale, 130*MCscale);
    newFunctionView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newFunction)];
    [newFunctionView addGestureRecognizer:tap];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (btBool == 0) {
        return recentDataAry.count;
    }
    return oldDataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 0) {
        NSString *identifier1 = [NSString stringWithFormat:@"index%ld%ld",indexPath.section,indexPath.row];
        orderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[orderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        if (recentDataAry.count>0) {
            cell.model = recentDataAry[indexPath.row];
        }
        cell.gotoeEvaluate.tag = indexPath.row + 100;
        cell.cancelOrderBtn.tag = indexPath.row + 1000;
        cell.payBtn.tag = indexPath.row + 2000;
        [cell.gotoeEvaluate addTarget:self action:@selector(gotoeEvaluateAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.payBtn addTarget:self action:@selector(payAgn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *identifier = @"cell";
        oldOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[oldOrderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.orderState.text = @"已收货";
        cell.model = oldDataAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 0) {
        recentOrderModel *model = recentDataAry[indexPath.row];
        orderDetailViewController *detailVc = [[orderDetailViewController alloc]init];
        detailVc.dingdanId = model.danhao;
        detailVc.isOrderAgn = 1;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else{
        oldOrderModel *model = oldDataAry[indexPath.row];
        orderDetailViewController *detailVc = [[orderDetailViewController alloc]init];
        detailVc.dingdanId = model.danhao;
        detailVc.isOrderAgn = 1;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 1) {
        return 88*MCscale;
    }
    else{
        recentOrderModel *model = recentDataAry[indexPath.row];
        NSString *guaj = [NSString stringWithFormat:@"%@",model.guanjia];
        if ([guaj isEqualToString:@"0"]) {
            return 144*MCscale;
        }
        return 174*MCscale;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
#pragma mark -- 事件处理
//按钮事件
-(void)goodOrStoreBtnAction:(UIButton *)btn
{
    [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    if (btn.tag == 1001) {
        UIButton *bt = (UIButton *)[btnView viewWithTag:1002];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineView.frame = CGRectMake(35*MCscale, 36, kDeviceWidth/3.0, 2);
        btBool = 0;
        if(recentDataAry.count>0){
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            [newFunctionView removeFromSuperview];
        }
        else{
            [self.view addSubview:newFunctionView];
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
        }
    }
    else{
        UIButton *bt = (UIButton *)[btnView viewWithTag:1001];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35*MCscale) + kDeviceWidth/2.0, 36, kDeviceWidth/3.0, 2);
        if(isFirst == 0){
            [self reloadLoadData];
            isFirst = 1;
        }
        if(oldDataAry.count>0){
            [newFunctionView removeFromSuperview];
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
        }
        else{
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
            [self.view addSubview:newFunctionView];
        }
        btBool = 1;
    }
    [orderTableView reloadData];
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
    if(!isOnlinePay){
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            passPopView.alpha = 0;
            [passPopView removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            onlinePayWayPop.alpha = 0;
            [onlinePayWayPop removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    
    if (swip.direction == 2) {
        UIButton *bt = (UIButton *)[btnView viewWithTag:1002];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[btnView viewWithTag:1001];
        [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
        lineView.frame = CGRectMake(35, 36, kDeviceWidth/3.0, 2);
        btBool = 0;
        if(recentDataAry.count>0){
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            [newFunctionView removeFromSuperview];
        }
        else{
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
            [self.view addSubview:newFunctionView];
        }
    }
    else{
        UIButton *bt = (UIButton *)[btnView viewWithTag:1001];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[btnView viewWithTag:1002];
        [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35) + kDeviceWidth/2.0, 36, kDeviceWidth/3.0, 2);
        if(isFirst == 0){
            [self reloadLoadData];
            isFirst = 1;
        }
        if(oldDataAry.count>0){
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            [newFunctionView removeFromSuperview];
        }
        else{
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新功能"]];
            [self.view addSubview:newFunctionView];
        }
        btBool = 1;
    }
    [orderTableView reloadData];
}
//导航右侧item
-(void)rightBtnAction
{
    OnlineServiceViewController *vc = [[OnlineServiceViewController alloc]init];
    vc.isOrder = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击 进入新功能介绍界面
-(void)newFunction
{
    NewFunctionViewController *vc = [[NewFunctionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
- (void)myTasks {
    // Do something usefull in here instead of sleeping ...
    sleep(30);
}
//订单评价
-(void)gotoeEvaluateAction:(UIButton *)btn
{
    NSInteger sender = btn.tag -100;
    orderEvaluateViewController *vc = [[orderEvaluateViewController alloc]init];
    recentOrderModel *model = recentDataAry[sender];
    vc.danhao = model.danhao;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消订单
-(void)cancelOrder:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消当前订单吗?" preferredStyle:1];
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelOrderWithIndex:btn.tag-1000];
    }];
    [alert addAction:suerAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

-(void)cancelOrderWithIndex:(NSInteger)index
{

    
    recentOrderModel *model = recentDataAry[index];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao}];
    [HTTPTool getWithUrl:@"findbydingdanquxiao.action" params:pram success:^(id json) {
        NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        if ([massage isEqualToString:@"1"]) {
            MyLog(@"-- 可以取消订单");
            [HTTPTool getWithUrl:@"updageyonhuquxiao.action" params:pram success:^(id json) {
                [self userExitRefresh];
                NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
                if ([massage isEqualToString:@"1"]) {
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"订单取消成功";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
           
//                    if ([isLogin isEqualToString:@"0"] && [model.zhifuleixing isEqualToString:@"2"]) {
//                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的退款将返还至您的付款账号" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
                
                }
                else{
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"订单取消失败";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"该订单不能取消";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [self userExitRefresh];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//再次支付
-(void)payAgn:(UIButton *)btn
{
    /**
     *  .用户点击支付按钮时的判断：
     A1.提供的接口：
     http://192.168.1.99:8080/Mshc/findbydingdanzhifu.action
     B1.提供的字段
     userid					//用户id
     dindan.danhao			//订单号
     
     C.返回结果：massages--------1   	//订单可以支付
     --------2		//订单不能支付
     */
    
    recentOrderModel *model = recentDataAry[btn.tag - 2000];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao}];
    [HTTPTool getWithUrl:@"findbydingdanzhifu.action" params:pram success:^(id json) {
        NSLog(@"json    是打饭时打发的面试 %@",json);
        if ([[json valueForKey:@"massages"] integerValue] == 1) {
            isOnlinePay = 1;
            NSString *payStyle = [NSString stringWithFormat:@"%@",model.zhifuleixing];
            if ([payStyle isEqualToString:@"2"]) {//在支付
                selectCellRow = btn.tag-2000;
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                if ([def integerForKey:@"isLogin"]==1) {
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 1;
                        onlinePayWayPop = [[OnLinePayView alloc]initWithFrame:CGRectMake(kDeviceWidth*3/20.0, 330*MCscale, kDeviceWidth*7/10.0, 135*MCscale)];
                        [self.view addSubview:mask];
                        [self getPaymentInformation];
                        onlinePayWayPop.isFrom = 1;
                        onlinePayWayPop.alpha = 0.95;
                        [self.view addSubview:onlinePayWayPop];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 1;
                        [self.view addSubview:mask];
                        onlinePayWayPop = [[OnLinePayView alloc]initWithFrame:CGRectMake(kDeviceWidth*3/20.0, 330*MCscale, kDeviceWidth*7/10.0, 70*MCscale)];
                        [self getPaymentInformation];
                        onlinePayWayPop.isFrom = 1;
                        onlinePayWayPop.alpha = 0.95;
                        [onlinePayWayPop.line2 removeFromSuperview];
                        [onlinePayWayPop.wChatImageView removeFromSuperview];
                        [self.view addSubview:onlinePayWayPop];
                    }];
                }
            }
            else if ([payStyle isEqualToString:@"3"]){//余额支付
                selectCellRow = btn.tag-2000;
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 1;
                    [self.view addSubview:mask];
                    passPopView.alpha = 0.95;
                    [self.view addSubview:passPopView];
                }];
            }
        }
        else
        {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"订单不能支付";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            
            [recentDataAry removeAllObjects];
            [oldDataAry removeAllObjects];
            [self reloadData];
        }
    } failure:^(NSError *error) {
    }];
}
//得到支付信息
-(void)getPaymentInformation
{
    recentOrderModel *model = recentDataAry[selectCellRow];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSString *payMoney;
    NSString *yingfu = [NSString stringWithFormat:@"%@",model.yingfujine];
    NSString *chajia = [NSString stringWithFormat:@"%@",model.chajia];
    if (![chajia isEqualToString:@"0"]) {
        payMoney = chajia;
    }
    else
        payMoney = yingfu;
    NSString *suffix;//后缀
    if ([[NSString stringWithFormat:@"%@",model.zhifuleixing] isEqualToString:@"2"] && [chajia isEqualToString:@"0"])
    {
        suffix = @"消费";
    }
    else
    {
        suffix = @"补差";
    }
    NSString *body = [NSString stringWithFormat:@"妙生活城+%@%@",danhao,suffix];
    [onlinePayWayPop reloadDataFromDanhao:danhao AndMoney:payMoney AndBody:body AndLeiming:nil];
}
//接受来自onLinePayDelegate的通知实现方法
-(void)PaymentSuccessClick:(NSNotification *)noti
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付成功";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onlinePayWayPop.alpha = 0;
        [onlinePayWayPop removeFromSuperview];
    }];
    isFirst = 0;
    [recentDataAry removeAllObjects];
    [oldDataAry removeAllObjects];
    [self reloadData];
}
-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

//接收隐藏弹框的通知
-(void)onLinePayViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onlinePayWayPop.alpha = 0;
        [onlinePayWayPop removeFromSuperview];
    }];
}
-(void)refresh
{
    //下拉刷新
    [orderTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    orderTableView.headerPullToRefreshText = @"下拉刷新数据";
    orderTableView.headerReleaseToRefreshText = @"松开刷新";
    orderTableView.headerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    loadType = 0;
    isRefresh = 1;
    if (!btBool) {
        [self reloadData];
    }
    else{
        [self reloadLoadData];
    }
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    [self reloadData];
}
-(void)endRefresh:(BOOL)success
{
    if (success) {
        [orderTableView footerEndRefreshing];
    }
    else{
        [orderTableView headerEndRefreshing];
    }
}
@end
