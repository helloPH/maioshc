//
//  securitySetViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/18.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "securitySetViewController.h"
#import "Header.h"
#import "PopView.h"
#import "MaskView.h"
#import "safeSetingModel.h"
#import "md5_password.h"
#import "SetPaymentPasswordView.h"
#import "LoginPasswordView.h"
#import "ChangePhoneNumber.h"
#import "TrueNameView.h"
#import "BindMailboxView.h"
#import "SecuritySetCell.h"
@interface securitySetViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,PopViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,SetPaymentPasswordViewDelegate,LoginPasswordViewDelegate,ChangePhoneNumberDelegate,TrueNameViewDelegate,BindMailboxViewDelegate>
{
    UITableView *safeTableView;
    //    PopView *newPhonePopView;//设置新手机号弹框
    LoginPasswordView *newPayPas;//支付密码
    SetPaymentPasswordView *nextPayPas;//支付密码下一步
    BindMailboxView *newEmail;//邮箱
    TrueNameView *tureName;//实名认证
    ChangePhoneNumber *changPhoneNextPop;//改变手机号下一步
    PopView *renzhengChangePayPop; //认证后修改支付密码
    MaskView *maskView;//遮罩层
    NSInteger popViewTag;
    UIView *mask;//键盘遮罩
    BOOL isrenzhen;
    BOOL isshebei;//当前设备是否匹配
    NSMutableArray *safeData;
    NSMutableArray *setingDataAry;
    MBProgressHUD *Mhub;
    NSMutableArray *phoneLbaelAry,*emailLabelAry;
}
@end

@implementation securitySetViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isrenzhen = 0;
    isshebei = 0;
    self.navigationItem.title = @"安全设置";
    self.view .backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    safeData = [[NSMutableArray alloc]init];
    setingDataAry = [[NSMutableArray alloc]init];
    phoneLbaelAry = [[NSMutableArray alloc]initWithCapacity:1];
    emailLabelAry = [[NSMutableArray alloc]initWithCapacity:1];
    [self loadNavigation];//导航
    [self loadTableView];//表
    [self endBtn];
    [self initMask];
    [self initPopView];
    [self initMaskView];
    [self initData];
}
-(void)initData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id}];
    [HTTPTool getWithUrl:@"getSafe.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSLog(@"json  %@",json);
        NSDictionary *dic = (NSDictionary *)json;
        safeSetingModel *modl = [[safeSetingModel alloc]initWithContent:dic];
        [safeData addObject:modl];
        [self initSafeAry];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)initSafeAry
{
    safeSetingModel *modl = safeData[0];
    [setingDataAry addObject:@"更换"];
    if ([modl.denglumima integerValue] == 1) {
        [setingDataAry addObject:@"设置"];
    }
    else
        [setingDataAry addObject:@"重置"];
    if([modl.zhfumima integerValue] == 1){
        [setingDataAry addObject:@"设置"];
    }
    else
        [setingDataAry addObject:@"重置"];
    if([modl.email integerValue]==1){
        [setingDataAry addObject:@"设置"];
    }
    else
        [setingDataAry addObject:@"修改"];
    if ([modl.shenfenzhenghao integerValue]==0) {
        isrenzhen = 0;
    }
    else
        isrenzhen = 1;
    
    NSLog(@"chushishebei = %@  userSheBei_id= %@  ",modl.chushishebei,userSheBei_id);
    if (![modl.chushishebei isEqualToString:userSheBei_id]) {
        isshebei = 1;
        [setingDataAry addObject:@"修改"];
    }
    else
        isshebei = 0;
    [safeTableView reloadData];
}
//导航栏
-(void)loadNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mask addGestureRecognizer:tap];
}
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//表
-(void)loadTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    safeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50*MCscale, kDeviceWidth, kDeviceHeight-80*MCscale-60*MCscale) style:UITableViewStyleGrouped];
    safeTableView.backgroundColor = [UIColor clearColor];
    safeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    safeTableView.delegate = self;
    safeTableView.dataSource = self;
    safeTableView.scrollEnabled = NO;
    [self.view addSubview:safeTableView];
}
//退出登录
-(void)endBtn
{
    UIButton *endbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endbtn.frame = CGRectMake(10*MCscale, kDeviceHeight-80*MCscale, kDeviceWidth-20*MCscale, 50*MCscale);
    endbtn.backgroundColor = txtColors(249, 54, 73, 1);
    endbtn.layer.masksToBounds = YES;
    endbtn.layer.cornerRadius = 5.0;
    [endbtn setTitle:@"退出登录" forState:UIControlStateNormal];
    endbtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [endbtn addTarget:self action:@selector(goOutLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endbtn];
}
//更换手机号码
-(void)initPopView
{
    [self changePayPassword];
    [self tureName];
    [self changeEmail];
    [self changPhoneNetx];
    [self initShenFenzheng];
}
//支付密码
-(void)changePayPassword
{
    //登录密码弹框
    newPayPas = [[LoginPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    newPayPas.tag = 103;
    newPayPas.loginPasswordDelegate = self;
    newPayPas.alpha = 0;
    
    //设置支付密码
    nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    nextPayPas.setPaymentDelegate = self;
    nextPayPas.alpha = 0;
    nextPayPas.tag = 104;
}

#pragma mark LoginPasswordViewDelegate
-(void)LoginPasswordViewSuccessWithIndex:(NSInteger)index;
{
    if (index == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            changPhoneNextPop.alpha = 0.95;
            [self.view addSubview:changPhoneNextPop];
        }];
        popViewTag = 107;
    }
    else if (index == 1) {//登录密码修改
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            nextPayPas.isFrom = 1;
            NSArray *array = @[@"请输入新密码",@"确认新密码"];
            [nextPayPas getTextFieldPlaceholderWithArray:array];
            nextPayPas.alpha =0.95;
            [self.view addSubview:nextPayPas];
        }];
        popViewTag = 104;
    }
    else if(index == 2)
    {//支付密码修改
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            nextPayPas.alpha = 0.95;
            nextPayPas.isFrom = 2;
            NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
            [nextPayPas getTextFieldPlaceholderWithArray:array];
            [self.view addSubview:nextPayPas];
        }];
        popViewTag = 104;
    }
    else if (index == 4)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
        }];
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"chushishebei":userSheBei_id}];
        [HTTPTool getWithUrl:@"changeSheBei.action" params:pram success:^(id json) {
            NSLog(@"changeSheBei.action = %@",json);
            if ([[json valueForKey:@"message"] integerValue] == 1) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"修改成功";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                
                [self initData];
                [safeTableView reloadData];
            }
            else
            {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"修改失败";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            [Hud hide:YES];
        } failure:^(NSError *error) {
            [Hud hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
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
    else if(index == 2)
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改失败!请稍后再试";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"不能为空";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

//支付密码修改 -- 认证
-(void)initShenFenzheng
{
    renzhengChangePayPop = [[PopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232)];
    renzhengChangePayPop.btnTitle = @"下一步";
    renzhengChangePayPop.delegate = self;
    renzhengChangePayPop.alpha = 0;
    renzhengChangePayPop.tag = 108;
    UITextField *sfzFiled = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, 55*MCscale,renzhengChangePayPop.width-20*MCscale , 40*MCscale)];
    sfzFiled.tag = 1101;
    sfzFiled.placeholder = @"请输入认证身份证后六位";
    sfzFiled.textAlignment = NSTextAlignmentCenter;
    sfzFiled.textColor = [UIColor blackColor];
    sfzFiled.keyboardType = UIKeyboardTypeNumberPad;
    [renzhengChangePayPop addSubview:sfzFiled];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, sfzFiled.bottom+10*MCscale, renzhengChangePayPop.width-10*MCscale, 1)];
    line.backgroundColor = lineColor;
    [renzhengChangePayPop addSubview:line];
}
//更换手机号第二部
-(void)changPhoneNetx
{
    changPhoneNextPop = [[ChangePhoneNumber alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    changPhoneNextPop.changeDelegate = self;
    changPhoneNextPop.alpha = 0;
    changPhoneNextPop.tag = 107;
}

#pragma mark ChangePhoneNumberDelegate
-(void)ChangePhoneNumberWithString:(NSString *)string AndIndex:(NSInteger)index
{
    if (index == 4) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"更换绑定手机成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        UILabel *lbe = phoneLbaelAry[0];
        lbe.text = [string stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            changPhoneNextPop.alpha = 0;
            [changPhoneNextPop removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userTel"];
        }];
    }
    else if (index == 3)
    {
        //验证码有误
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"验证码有误";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        //更改失败请重试
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"操作失败请稍后重试";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            changPhoneNextPop.alpha = 0;
            [changPhoneNextPop removeFromSuperview];
        }];
    }
}

//邮箱
-(void)changeEmail
{
    newEmail = [[BindMailboxView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    newEmail.bingMailDelegate = self;
    newEmail.tag = 105;
}

#pragma mark  BindMailboxViewDelegate
-(void)BindMailboxSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newEmail.alpha = 0;
            [newEmail removeFromSuperview];
        }];
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"向绑定邮箱发送邮件成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:3 inSection:0];
        UITableViewCell *cell = [safeTableView cellForRowAtIndexPath:indexp];
        UILabel *lab = (UILabel *)[cell viewWithTag:204];
        lab.frame = CGRectMake(105*MCscale, 22*MCscale, 145*MCscale, 20*MCscale);
        lab.alpha = 1;
        lab.text = @"已发送到您的邮箱";
    }
}
//实名认证
-(void)tureName
{
    tureName =[[TrueNameView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 230)];
    tureName.trueNameDelegate = self;
    tureName.tag = 106;
    tureName.alpha = 0;
}
#pragma mark TrueNameViewDelegate
-(void)rengzhengSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"实名认证成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            tureName.alpha = 0;
            [tureName removeFromSuperview];
        }];
        isrenzhen = 1;
        [safeData removeAllObjects];
        [self initData];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"认证失败";
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
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isshebei) { //不匹配
        if (isrenzhen) {
            return 8;
        }
        return 6;
    }
    else
    {//匹配
        if (isrenzhen) {
            return 7;
        }
        return 5;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SecuritySetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SecuritySetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell loadDataWithIndexPath:indexPath AndIsSheBei:isshebei AndsetingArray:setingDataAry AndphoneArray:phoneLbaelAry AndsafeDataArray:safeData AndemailArray:emailLabelAry AndisRenZhen:isrenzhen];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isshebei) {
        if (indexPath.row == 5 || indexPath.row == 6) {
            return 45*MCscale;
        }
        return 60*MCscale;
    }
    else
    {
        if (indexPath.row == 4 || indexPath.row==5) {
            return 45*MCscale;
        }
        return 60*MCscale;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isshebei) {
        if (indexPath.row == 0){
            popViewTag = 103;
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = indexPath.row;
                [self.view addSubview:newPayPas];
            }];
        }
        else if (indexPath.row==1){
            safeSetingModel *modl = safeData[0];
            NSString *userPas = [NSString stringWithFormat:@"%@",modl.denglumima];
            if (![userPas isEqualToString:@"123456"]) {
                popViewTag = 103;
                [UIView animateWithDuration:0.6 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newPayPas.alpha = 0.95;
                    newPayPas.indexPath = indexPath.row;
                    [self.view addSubview:newPayPas];
                }];
            }
            else{
                nextPayPas.oldPas = @"123456";
                popViewTag = 102;
                [UIView animateWithDuration:0.6 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    nextPayPas.alpha = 0.95;
                    [self.view addSubview:nextPayPas];
                }];
            }
        }
        else if (indexPath.row ==2){
            if (isrenzhen) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    renzhengChangePayPop.alpha = 0.95;
                    [self.view addSubview:renzhengChangePayPop];
                }];
                popViewTag = 108;
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newPayPas.alpha =0.95;
                    newPayPas.indexPath = indexPath.row;
                    [self.view addSubview:newPayPas];
                }];
                popViewTag = 103;
            }
        }
        else if (indexPath.row ==3){
            safeSetingModel *modl = safeData[0];
            if ([modl.email integerValue]==1) {
                //设置
                popViewTag = 105;
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newEmail.alpha = 0.95;
                    [self.view addSubview:newEmail];
                }];
            }
            else{
                //修改
                Mhub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                Mhub.delegate = self;
                Mhub.mode = MBProgressHUDModeIndeterminate;
                Mhub.labelText = @"正在发送邮件,请稍等...";
                [Mhub show:YES];
                [self modifyEmail];
            }
        }
        else if (indexPath.row == 4){
            popViewTag = 103;
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = indexPath.row;
                [self.view addSubview:newPayPas];
            }];
        }
        else if (indexPath.row == 5){
            if (!isrenzhen) {
                popViewTag = 106;
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    tureName.alpha = 0.95;
                    [self.view addSubview:tureName];
                }];
            }
        }
    }
    else
    {
        if (indexPath.row == 0){
            popViewTag = 103;
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = indexPath.row;
                [self.view addSubview:newPayPas];
            }];
        }
        else if (indexPath.row==1){
            safeSetingModel *modl = safeData[0];
            NSString *userPas = [NSString stringWithFormat:@"%@",modl.denglumima];
            if (![userPas isEqualToString:@"123456"]) {
                popViewTag = 103;
                [UIView animateWithDuration:0.6 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newPayPas.alpha = 0.95;
                    newPayPas.indexPath = indexPath.row;
                    [self.view addSubview:newPayPas];
                }];
            }
            else{
                nextPayPas.oldPas = @"123456";
                popViewTag = 102;
                [UIView animateWithDuration:0.6 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    nextPayPas.alpha = 0.95;
                    [self.view addSubview:nextPayPas];
                }];
            }
        }
        else if (indexPath.row ==2){
            if (isrenzhen) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    renzhengChangePayPop.alpha = 0.95;
                    [self.view addSubview:renzhengChangePayPop];
                }];
                popViewTag = 108;
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newPayPas.alpha =0.95;
                    newPayPas.indexPath = indexPath.row;
                    [self.view addSubview:newPayPas];
                }];
                popViewTag = 103;
            }
        }
        else if (indexPath.row ==3){
            safeSetingModel *modl = safeData[0];
            if ([modl.email integerValue]==1) {
                //设置
                popViewTag = 105;
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newEmail.alpha = 0.95;
                    [self.view addSubview:newEmail];
                }];
            }
            else{
                //修改
                Mhub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                Mhub.delegate = self;
                Mhub.mode = MBProgressHUDModeIndeterminate;
                Mhub.labelText = @"正在发送邮件,请稍等...";
                [Mhub show:YES];
                [self modifyEmail];
            }
        }
        else if (indexPath.row == 4){
            if (!isrenzhen) {
                popViewTag = 106;
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    tureName.alpha = 0.95;
                    [self.view addSubview:tureName];
                }];
            }
        }
    }
}
#pragma mark -- PopViewDelegate
-(void)popBtnAction:(PopView *)pop atIndex:(NSInteger)index btnTag:(NSInteger)btag
{
    if (index ==105){
        safeSetingModel *model = safeData[0];
        if ([model.email integerValue]!=1) {
            [self modifyEmail];
        }
    }
    else if (index == 108){
        [self shenzhengRzLast];
    }
}
//认证身份证后6位
-(void)shenzhengRzLast
{
    UITextField *file = (UITextField *)[renzhengChangePayPop viewWithTag:1101];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"shenfen":file.text}];
    [HTTPTool getWithUrl:@"checkShenfen.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"message"] integerValue]== 1) {
            [UIView animateWithDuration:0.3 animations:^{
                renzhengChangePayPop.alpha = 0;
                [renzhengChangePayPop removeFromSuperview];
                newPayPas.alpha = 0.95;
                [self.view addSubview:newPayPas];
                file.text = @"";
            }];
            popViewTag = 103;
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"验证失败";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//修改邮箱
-(void)modifyEmail
{
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id}];
    [HTTPTool getWithUrl:@"updateEmail.action" params:pram success:^(id json) {
        [Hmud hide:YES];
        if ([[json valueForKey:@"message"]integerValue]==1) {
            [Mhub hide:YES];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"发送邮件成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 0;
                [maskView removeFromSuperview];
                newEmail.alpha = 0;
                [newEmail removeFromSuperview];
            }];
        }
        else{
            [Mhub hide:YES];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"发送邮件失败";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [Hmud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//弹框隐藏
-(void)maskDisMiss
{
    PopView *pop = (PopView *)[self.view viewWithTag:popViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        pop.alpha = 0;
        [self.view endEditing:YES];
        [pop removeFromSuperview];
    }];
}
//退出
-(void)goOutLogin
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:0 forKey:@"isLogin"];
    [def setValue:userSheBei_id forKey:@"userId"];
    mainController *main = (mainController *)self.tabBarController;
    main.controlShowStyle = 1;
    [main showOrHiddenTabBarView:NO];
    [[NSUserDefaults standardUserDefaults] valueForKey:@"xrlTapNum"];
    [[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"youhuiquancount"];
    
    NSNotification *userExitNotification = [NSNotification notificationWithName:@"userExitFication" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:userExitNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userExitFication" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
#pragma mark --键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    [self.view addSubview:mask];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    [mask removeFromSuperview];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}

@end
