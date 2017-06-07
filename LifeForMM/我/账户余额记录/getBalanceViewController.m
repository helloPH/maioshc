//
//  getBalanceViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/24.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//
#import "getBalanceViewController.h"
#import "Header.h"
#import "OnLinePayView.h"
#import "MaskView.h"
#import "GetBalanceCell.h"
#import "BindAccountModel.h"
@interface getBalanceViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,OnLinePayViewDelegate,GetBalanceCellDelegate>
{
    UIView *maskView;
    UIImageView *selectImage;
    UITextField *numTextfiled;
    UILabel *useMoney;
    UILabel *moneyNum;
    UILabel *titleLabel;
    UITableView *accountTableView;
    UIButton *submitBtn;
    OnLinePayView *onLinePayView;
    MaskView *mask;
    NSMutableArray *shujuArray;
    BOOL isSeleted;
}
@end

@implementation getBalanceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    shujuArray = [NSMutableArray array];
    isSeleted = YES;
    [self initNavigation];
    [self relodData];
    [self initSubViews];
    [self initMaskView];
    [self maskView];
    [self initOnLinePayView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"余额提现";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(void)initSubViews
{
    useMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    useMoney.textAlignment = NSTextAlignmentLeft;
    useMoney.textColor = lineColor;
    useMoney.text = @"可提现金额:";
    useMoney.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.view addSubview:useMoney];
    
    moneyNum = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyNum.textAlignment = NSTextAlignmentLeft;
    moneyNum.textColor = redTextColor;
    moneyNum.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.view addSubview:moneyNum];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = lineColor;
    titleLabel.text = @"可选提现账户";
    titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.view addSubview:titleLabel];
    
    accountTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    accountTableView.delegate = self;
    accountTableView.dataSource = self;
    accountTableView.layer.borderColor = lineColor.CGColor;
    accountTableView.layer.borderWidth = 1;
    accountTableView.separatorStyle = NO;
    accountTableView.backgroundColor = lineColor;
    accountTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview:accountTableView];
    
    numTextfiled = [[UITextField alloc]initWithFrame:CGRectZero];
    numTextfiled.delegate = self;
    numTextfiled.backgroundColor = txtColors(236, 237, 239, 1);
    numTextfiled.textAlignment = NSTextAlignmentCenter;
    numTextfiled.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    numTextfiled.keyboardType = UIKeyboardTypeNumberPad;
    numTextfiled.placeholder = @"请输入提现金额";
    [self.view addSubview:numTextfiled];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = txtColors(249, 54, 73, 1);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 5.0;
    submitBtn.layer.masksToBounds = YES;
    [self.view addSubview:submitBtn];
    
    selectImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    selectImage.image = [UIImage imageNamed:@"灯泡提示"];
    [self.view addSubview:selectImage];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.text = @"1-3个工作日内退回";
    label.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = textColors;
    label2.text = @"银行处理可能有延迟，具体以账户的到账时间为准。每日可提现1次";
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:MLwordFont_8];
    [self.view addSubview:label2];
    
    useMoney.frame = CGRectMake(20*MCscale,84*MCscale,110*MCscale, 20*MCscale);
    moneyNum.frame = CGRectMake(useMoney.right, useMoney.top,kDeviceWidth-150*MCscale , 20*MCscale);
    titleLabel.frame = CGRectMake(useMoney.left, useMoney.bottom + 50*MCscale, 200*MCscale, 20*MCscale);
    accountTableView.frame = CGRectMake(0, titleLabel.bottom + 5*MCscale, kDeviceWidth, 50*MCscale);
    numTextfiled.frame = CGRectMake(kDeviceWidth/2-80*MCscale, accountTableView.bottom + 50*MCscale, 160*MCscale,40*MCscale);
    submitBtn.frame = CGRectMake(20*MCscale, numTextfiled.bottom + 30*MCscale, kDeviceWidth-40*MCscale, 48*MCscale);
    selectImage.frame = CGRectMake(25*MCscale, submitBtn.bottom + 20*MCscale,25*MCscale,30*MCscale);
    label.frame = CGRectMake(selectImage.right + 5*MCscale,submitBtn.bottom + 25*MCscale,180*MCscale,16*MCscale);
    label2.frame = CGRectMake(selectImage.right,label.bottom-5*MCscale,kDeviceWidth - 75*MCscale,60*MCscale);
}
//获取余额
-(void)relodData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"findYuE.action" params:pram success:^(id json) {
        
        CGFloat yue = [[json valueForKey:@"money"] floatValue];
        NSString *ketixMoney = [NSString stringWithFormat:@"%.2f",yue];
        moneyNum.text = [NSString stringWithFormat:@"%@元",ketixMoney];
        _tixinJe=ketixMoney;
        if ([[json valueForKey:@"massage"]integerValue] == 1) {
            [submitBtn setTitle:@"请绑定提现到账平台" forState:UIControlStateNormal];
            titleLabel.hidden = YES;
            accountTableView.hidden = YES;
            numTextfiled.hidden = YES;
        }
        else
        {
            
            [submitBtn setTitle:@"确认提现" forState:UIControlStateNormal];
            titleLabel.hidden = NO;
            accountTableView.hidden = NO;
            numTextfiled.hidden = NO;
        }
        NSArray *arr = [json valueForKey:@"shuju"];
        for (NSDictionary *dict in arr) {
            BindAccountModel *model = [[BindAccountModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [shujuArray addObject:model];
        }
        [accountTableView reloadData];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
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
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
    [self relodData];
}
-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}


//手势遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [maskView addGestureRecognizer:tap];
}
#pragma mark btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
//弹框遮罩
-(void)maskView
{
    mask = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    mask.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
    [self.view addSubview:mask];
}
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onLinePayView.alpha = 0;
        [self.view endEditing:YES];
        [onLinePayView removeFromSuperview];
    }];
}
-(void)submitBtnAction:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"请绑定提现到账平台"])
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 1;
            [self .view addSubview:mask];
            onLinePayView.alpha = 0.95;
            [onLinePayView.line2 removeFromSuperview];
            [onLinePayView.wChatImageView removeFromSuperview];
            [onLinePayView.line3 removeFromSuperview];
            [onLinePayView.moreView removeFromSuperview];
            [self.view addSubview:onLinePayView];
        }];
    }
    else{
        if (isSeleted==YES) {
            NSString *textFiledValue = numTextfiled.text;
            BindAccountModel *model = shujuArray[0];
            if (([textFiledValue floatValue] <=[_tixinJe floatValue]) && [textFiledValue floatValue] >0) {
                NSMutableDictionary *pram= [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"tixianjine":textFiledValue,@"ketixianjine":_tixinJe,@"zhanghao":model.zhanghao,@"fangshi":model.name}];
                [HTTPTool postWithUrl:@"yuETiXian4.action" params:pram success:^(id json) {
                    NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"money"]];
                    if([message isEqualToString:@"1"]){
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        mbHud.mode = MBProgressHUDModeCustomView;
                        mbHud.labelText = @"提现成功";
                        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                        _tixinJe =[NSString stringWithFormat:@"%.2f",[_tixinJe floatValue] - [textFiledValue floatValue]];
                        UILabel *lb = [self.view viewWithTag:1101];
                        lb.text = _tixinJe;
                        numTextfiled.text = @"";
                        NSNotification *shopNotification = [NSNotification notificationWithName:@"tixianAccess" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:shopNotification];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tixianAccess" object:nil];
                    }
                    else if ([message isEqualToString:@"-3"]){
                        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        mbHud.mode = MBProgressHUDModeText;
                        mbHud.labelText = @"今天已提现过";
                        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"网络连接错误";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else{
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeText;
                mbHud.labelText = @"你输入的金额有误!请重新输入";
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
        else
        {
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"请选择提现账号";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    }
}
//订单验证
-(void)initOnLinePayView
{
    onLinePayView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,130*MCscale)];
    onLinePayView.isFrom = 3;
    onLinePayView.alpha = 0;
    onLinePayView.moneyTextFiled.placeholder = @"最小金额为0.01";
    onLinePayView.onLinePayDelegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shujuArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetBalanceCell"];
    if (cell == nil) {
        cell = [[GetBalanceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GetBalanceCell"];
    }
    cell.balanceDelegate = self;
    BindAccountModel *model = shujuArray[indexPath.row];
    [cell loadDataForCellWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
#pragma mark GetBalanceCellDelegate
-(void)changeAccountForBalance
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self .view addSubview:mask];
        onLinePayView.alpha = 0.95;
        [onLinePayView.line2 removeFromSuperview];
        [onLinePayView.wChatImageView removeFromSuperview];
        [onLinePayView.line3 removeFromSuperview];
        [onLinePayView.moreView removeFromSuperview];
        [self.view addSubview:onLinePayView];
    }];
}
-(void)changeSeletedForButton:(UIButton *)btn
{
    isSeleted = btn.selected;
}
- (void)myTask {
    sleep(1.5);
}
#pragma mark 键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    [self.view addSubview:maskView];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    [maskView removeFromSuperview];
}
#pragma mark UITextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.placeholder = @"请输入提现金额";
}

@end
