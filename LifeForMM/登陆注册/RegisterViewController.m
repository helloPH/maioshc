//
//  RegisterViewController.m
//  LifeForMM
//
//  Created by HUI on 15/7/31.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "RegisterViewController.h"
#import "Header.h"
#import "UserAgreeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UseDirectionViewController.h"
#import "securitySetViewController.h"
#import "md5_password.h"
#import "locationViewController.h"
@interface RegisterViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *telNumber;//手机号
    UITextField *codeFiled;//验证码
    BOOL isAgree;//同意协议标记
    UIView *mask;//余额输入遮罩
    NSInteger timeSec;//
    UIView *newpasView;//设置密码
    BOOL isCode;//是否是验证码 1 验证码;0 邀请码
    BOOL isShow;//验证码输入框显示状态 1显示状态 0没有显示
    UIView *codeView,*regBtnView;//存放验证码输入框 存放注册按钮
}
@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(25, 182, 133, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    isAgree = 0;
    timeSec = 120;
    isCode = 1;
    isShow = 0;
    [self initNavigation];
    [self initSubViews];
    [self initMask];
    [self initNewPasView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"注册";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)initSubViews
{
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 191*MCscale, 22*MCscale, 22*MCscale)];
    phoneImage.backgroundColor = [UIColor clearColor];
    phoneImage.image = [UIImage imageNamed:@"输入手机号"];
    [self.view addSubview:phoneImage];
    
    telNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneImage.right, 184*MCscale, 190*MCscale, 35*MCscale)];
    telNumber.placeholder = @"请输入登录手机号";
    telNumber.tag = 11001;
    telNumber.delegate = self;
    telNumber.textColor = [UIColor blackColor];
    telNumber.font = [UIFont systemFontOfSize:MLwordFont_11];
    telNumber.textAlignment = NSTextAlignmentLeft;
    telNumber.backgroundColor = [UIColor clearColor];
    telNumber.keyboardType  = UIKeyboardTypeNumberPad;
    [self.view addSubview:telNumber];
    
    UIButton *sendCode = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCode.frame = CGRectMake(telNumber.right+2, 184*MCscale, kDeviceWidth-telNumber.width-65*MCscale, 40*MCscale);
    sendCode.backgroundColor = txtColors(248, 53, 74, 1);
    [sendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendCode.titleLabel.font =[UIFont systemFontOfSize:MLwordFont_2];
    sendCode.layer.cornerRadius = 3.0;
    sendCode.layer.masksToBounds = YES;
    sendCode.tag = 1002;
    [sendCode addTarget:self action:@selector(changeRegisterStyle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendCode];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20,telNumber.bottom+10, telNumber.width+20, 1)];
    line1.backgroundColor = lineColor;
    [self.view addSubview:line1];
    
    codeView = [[UIView alloc]initWithFrame:CGRectMake(0, telNumber.bottom+30*MCscale, kDeviceWidth, 45)];
    codeView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:codeView];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(22, 3*MCscale, 20*MCscale, 22*MCscale)];
    codeImage.backgroundColor = [UIColor clearColor];
    codeImage.image = [UIImage imageNamed:@"输入验证码"];
    [codeView addSubview:codeImage];
    
    codeFiled = [[UITextField alloc]initWithFrame:CGRectMake(codeImage.right+2, 0, 190*MCscale, 30*MCscale)];
    codeFiled.placeholder = @"请输入短信验证码";
    codeFiled.keyboardType = UIKeyboardTypeNumberPad;
    codeFiled.textColor = [UIColor blackColor];
    codeFiled.backgroundColor = [UIColor clearColor];
    codeFiled.textAlignment = NSTextAlignmentLeft;
    codeFiled.font = [UIFont systemFontOfSize:MLwordFont_11];
    [codeView addSubview:codeFiled];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, codeFiled.bottom+10, kDeviceWidth, 1)];
    
    line2.backgroundColor = lineColor;
    [codeView addSubview:line2];
    
    regBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, telNumber.bottom+40*MCscale, kDeviceWidth, 80*MCscale)];
    regBtnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:regBtnView];
    
    UIButton *regisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regisBtn.frame = CGRectMake(20, 0, kDeviceWidth-40*MCscale, 40*MCscale);
    regisBtn.tag = 110011;
    regisBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [regisBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    regisBtn.titleLabel.font =[UIFont systemFontOfSize:MLwordFont_11];
    regisBtn.layer.cornerRadius = 3.0;
    regisBtn.layer.masksToBounds = YES;
    [regisBtn addTarget:self action:@selector(regisAction) forControlEvents:UIControlEventTouchUpInside];
    [regBtnView addSubview:regisBtn];
    
    UIImageView *agreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(40*MCscale, regisBtn.bottom+15*MCscale, 22*MCscale, 22*MCscale)];
    agreeImage.backgroundColor = [UIColor clearColor];
    agreeImage.image = [UIImage imageNamed:@"选中"];
    agreeImage.tag = 1001;
    agreeImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeAction)];
    [agreeImage addGestureRecognizer:tap];
    [regBtnView addSubview:agreeImage];
    
    UILabel *xieyi = [[UILabel alloc]initWithFrame:CGRectMake(agreeImage.right+5, agreeImage.top, 115*MCscale, 22*MCscale)];
    xieyi.text = @"我已经阅读并同意";
    xieyi.textAlignment = NSTextAlignmentLeft;
    xieyi.textColor = textBlackColor;
    xieyi.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyi.backgroundColor = [UIColor clearColor];
    [regBtnView addSubview:xieyi];
    
    UILabel *xieyiCon = [[UILabel alloc]initWithFrame:CGRectMake(xieyi.right+2, xieyi.top, 150*MCscale_1, 22*MCscale)];
    xieyiCon.text = @"妙生活城平台用户协议";
    xieyiCon.textColor = txtColors(25, 182, 133, 1);
    xieyiCon.textAlignment = NSTextAlignmentLeft;
    xieyiCon.backgroundColor = [UIColor clearColor];
    xieyiCon.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyiCon.userInteractionEnabled = YES;
    [regBtnView addSubview:xieyiCon];
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAgreement)];
    [xieyiCon addGestureRecognizer:agreeTap];
    UIView *line3 =[[UIView alloc]initWithFrame:CGRectMake(xieyiCon.left-1, xieyiCon.bottom-2, xieyiCon.width+2, 1)];
    line3.backgroundColor = txtColors(25, 182, 133, 1);
    [regBtnView addSubview:line3];
}
-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mask addGestureRecognizer:tap];
}
//
-(void)initNewPasView
{
    newpasView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 200*MCscale)];
    newpasView.backgroundColor = [UIColor whiteColor];
    newpasView.layer.cornerRadius = 15.0;
    newpasView.layer.shadowRadius = 5.0;
    newpasView.layer.shadowOpacity = 0.5;
    newpasView.layer.shadowOffset = CGSizeMake(0, 0);
    NSArray *placeHolderArray = @[@"请输入新密码",@"确认新密码"];
    for (int i = 0; i<2; i++) {
        UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, (20+55*i)*MCscale, newpasView.width-20*MCscale, 40*MCscale)];
        password.placeholder = placeHolderArray[i];
        password.textAlignment = NSTextAlignmentCenter;
        password.textColor = [UIColor blackColor];
        password.font = [UIFont systemFontOfSize:MLwordFont_2];
        password.backgroundColor = [UIColor clearColor];
        password.tag = i+1;
        [password setSecureTextEntry:YES];
        password.keyboardType = UIKeyboardTypeDefault;
        [newpasView addSubview:password];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, password.bottom+5*MCscale, newpasView.width-10*MCscale, 1)];
        line.backgroundColor = lineColor;
        [newpasView addSubview:line];
    }
    UILabel *saveBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(0, newpasView.height-60*MCscale, (newpasView.width-2)/2.0, 40)];
    saveBtnLb.backgroundColor = [UIColor clearColor];
    saveBtnLb.textColor = [UIColor blackColor];
    saveBtnLb.textAlignment = NSTextAlignmentCenter;
    saveBtnLb.text = @"稍后再说";
    saveBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    saveBtnLb.userInteractionEnabled = YES;
    saveBtnLb.tag = 1001;
    [newpasView addSubview:saveBtnLb];
    UITapGestureRecognizer *saveTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savePasBtnAction:)];
    [saveBtnLb addGestureRecognizer:saveTap];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(newpasView.width/2.0, newpasView.height-68*MCscale, 1, 60*MCscale)];
    lineView.backgroundColor = lineColor;
    [newpasView addSubview:lineView];
    
    UILabel *cancelBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(saveBtnLb.right+2, newpasView.height-60*MCscale, (newpasView.width-2)/2.0, 40)];
    cancelBtnLb.backgroundColor = [UIColor clearColor];
    cancelBtnLb.textColor = txtColors(255, 40, 48, 1);
    cancelBtnLb.text = @"确定提交";
    cancelBtnLb.textAlignment = NSTextAlignmentCenter;
    cancelBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    cancelBtnLb.userInteractionEnabled = YES;
    [newpasView addSubview:cancelBtnLb];
    cancelBtnLb.tag = 1002;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savePasBtnAction:)];
    [cancelBtnLb addGestureRecognizer:cancelTap];
}
-(void)savePasBtnAction:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 1001){
        [self.navigationController popViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    else if (tap.view.tag == 1002){
        UITextField *paswd = (UITextField *)[newpasView viewWithTag:1];
        UITextField *paswdagn = (UITextField *)[newpasView viewWithTag:2];
        if (![paswd.text isEqualToString:@""]) {
            if ([paswd.text isEqualToString:paswdagn.text]) {
                NSString *mdPasd = [md5_password encryptionPassword:@"-1" userTel:userName_tel];
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":user_id,@"yuanmima":mdPasd,@"xinmima":paswd.text}];
                [HTTPTool getWithUrl:@"loginpwd1.action" params:pram success:^(id json) {
                    NSDictionary *dic = (NSDictionary *)json;
                    if ([[dic valueForKey:@"message"]integerValue]==1) {
                        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        mbHud.mode = MBProgressHUDModeText;
                        mbHud.labelText = @"密码修改成功";
                        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setInteger:2 forKey:@"isLogin"];
                        [def setValue:paswd.text forKey:@"userPass"];
                        [self performSelector:@selector(lognAction) withObject:self afterDelay:1.5];
                    }
                    else if ([[dic valueForKey:@"massage"]integerValue]==2){
                        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        mbHud.mode = MBProgressHUDModeText;
                        mbHud.labelText = @"原密码有误重新填写";
                        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"密码修改失败!请稍后再试";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else{
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeText;
                mbHud.labelText = @"两次密码不一致";
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"不能为空";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    }
}
//切换模式  验证码/邀请码
-(void)changeRegisterStyle
{
    if ([telNumber.text isEqualToString:@""]) {
        if (!_isInvite) {
            if (isCode) {
                isCode = 0;
                UIButton *codeBtn = (UIButton *)[self.view viewWithTag:1002];
                [codeBtn setTitle:@"使用邀请码" forState:UIControlStateNormal];
                codeFiled.placeholder = @"请输入邀请码";
            }
            else{
                isCode = 1;
                UIButton *codeBtn = (UIButton *)[self.view viewWithTag:1002];
                [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                codeFiled.placeholder = @"请输入短信验证码";
            }
        }
    }
    else{
        _userPhone = telNumber.text;
        if(userShequ_id){
            NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[7,5])|(17[0,3,6,7,8]))\\d{8}$";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            BOOL isMatch = [phoneTest evaluateWithObject:_userPhone];
            if(isMatch){
                NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"user.tel":_userPhone}];
                [HTTPTool getWithUrl:@"findbyhaoma.action" params:pram success:^(id json) {
                    NSString *massage =[NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
                    if ([massage isEqualToString:@"0"]) {
                        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        bud.mode = MBProgressHUDModeCustomView;
                        bud.labelText = @"该手机号已注册过!";
                        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }
                    else if ([massage isEqualToString:@"1"]){
                        if (isCode) {
                            if (!isShow) {
                                [self.view addSubview:codeView];
                                regBtnView.frame = CGRectMake(0, codeView.bottom+15*MCscale, kDeviceWidth, 80*MCscale);
                            }
                            codeFiled.placeholder = @"请输入短信验证码";
                            [self sendCodeAction];
                        }
                        else{
                            if (!isShow) {
                                [self.view addSubview:codeView];
                                regBtnView.frame = CGRectMake(0, codeView.bottom+15*MCscale, kDeviceWidth, 80*MCscale);
                            }
                            codeFiled.placeholder = @"请输入邀请码";
                        }
                    }
                    else{
                        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        bud.mode = MBProgressHUDModeCustomView;
                        bud.labelText = @"手机号格式错误!";
                        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"网络连接错误!";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else{
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"手机号格式错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"未授权定位，请选择合适的默认社区";
            [bud showWhileExecuting:@selector(jumpTask) onTarget:self withObject:nil animated:YES];
            [self performSelector:@selector(jumpLocation) withObject:self afterDelay:3];
        }
    }
}
//没有社区id3秒跳转
-(void)jumpLocation
{
    locationViewController *loc = [[locationViewController alloc]init];
    [self.navigationController pushViewController:loc animated:YES];
}
//发送验证码
-(void)sendCodeAction
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:_userPhone forKey:@"user.tel"];
    [HTTPTool getWithUrl:@"showCode.action" params:jsonDict success:^(id json) {
        NSDictionary * dic = (NSDictionary * )json;
        
        [Hud hide:YES];
        if ([[dic objectForKey:@"massage"]intValue]==0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"该手机号已经注册过!请重新填写" preferredStyle:1];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:suerAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if ([[dic objectForKey:@"massage"]intValue]==1) {
            [self timImngAction];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"手机号有误!请重新填写" preferredStyle:1];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:suerAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"短信发送失败!请稍后再试";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//
//注册
-(void)regisAction
{
    if(isCode){
        if(!isAgree){
            MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            Hud.mode = MBProgressHUDModeIndeterminate;
            Hud.delegate = self;
            Hud.labelText = @"请稍等...";
            [Hud show:YES];
            _userCode = codeFiled.text;
            _userPhone = telNumber.text;
            NSString *strSysName;
            if (_isInvite) {
                strSysName = @"0";
            }
            else
            {
                strSysName = [[UIDevice currentDevice].identifierForVendor UUIDString];
            }
            NSString *code = _userCode;
            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
            [jsonDict setObject:_userPhone forKey:@"user.tel"];
            [jsonDict setObject:strSysName forKey:@"user.shebeiId"];
            [jsonDict setObject:userShequ_id forKey:@"user.defaultShequ"];
            [jsonDict setObject:code forKey:@"code"];
            [HTTPTool getWithUrl:@"userReg3.action" params:jsonDict success:^(id json) {
                [Hud hide:YES];
                NSDictionary * dic = (NSDictionary * )json;
                if ([[dic objectForKey:@"massage"]intValue]==3){
                    if (_isInvite) {
                        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shequname":userShequ_Name,@"shequid":userShequ_id,@"userid":user_id,@"jieshouzhe":telNumber.text}];
                        [HTTPTool getWithUrl:@"faceToFace.action" params:pram success:^(id json) {
                        } failure:^(NSError *error) {
                        }];
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"您的初始密码为123456" preferredStyle:1];
                        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:suerAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setInteger:2 forKey:@"isLogin"];
                    [def setValue:_userPhone forKey:@"userTel"];
                    [def setValue:@"123456" forKey:@"userPass"];
                    [def setValue:[dic valueForKey:@"userid"] forKey:@"userId"];
                    [def setValue:@"0" forKey:@"userShequCity"];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"您的初始密码为123456是否重置" preferredStyle:1];
                    UIButton *btn = (UIButton *)[self.view viewWithTag:1002];
                    NSString *title = @"发送验证码";
                    btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
                    [btn setTitle:title forState:UIControlStateNormal];
                    btn.backgroundColor = txtColors(248, 53, 74, 1);
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    timeSec =120;
                    btn.enabled = YES;
                    telNumber.text = @"";
                    codeFiled.text = @"";
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self lognAction];
                    }];
                    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        newpasView.alpha = 0.95;
                        [self.view addSubview:newpasView];
                    }];
                    [alert addAction:suerAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                else if([[dic objectForKey:@"massage"]intValue]==2){
                    [Hud hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"验证码错误";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else if([[dic objectForKey:@"massage"]intValue]==0){
                    [Hud hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"该手机号已注册过";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else if([[dic objectForKey:@"massage"]intValue]==4){
                    [Hud hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"手机号格式有误";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else if([[dic objectForKey:@"massage"]intValue]==1){
                    [Hud hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"手机号或验证码为空";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
            } failure:^(NSError *error) {
                
                [Hud hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
    }
    else{
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        _userCode = codeFiled.text;
        _userPhone = telNumber.text;
        NSString *strSysName = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSString *code = _userCode;
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
        [jsonDict setObject:_userPhone forKey:@"user.tel"];
        [jsonDict setObject:strSysName forKey:@"user.shebeiId"];
        [jsonDict setObject:userShequ_id forKey:@"user.defaultShequ"];
        [jsonDict setObject:code forKey:@"code"];
        [HTTPTool getWithUrl:@"yaoqingmazuce.action" params:jsonDict success:^(id json) {
            [Hud hide:YES];
            NSDictionary * dic = (NSDictionary * )json;
            if ([[dic objectForKey:@"massage"]intValue]==3){
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setInteger:2 forKey:@"isLogin"];
                [def setValue:_userPhone forKey:@"userTel"];
                [def setValue:@"123456" forKey:@"userPass"];
                [def setValue:[dic valueForKey:@"userid"] forKey:@"userId"];
                [def setValue:@"0" forKey:@"userShequCity"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"您的初始密码为123456是否重置" preferredStyle:1];
                UIButton *btn = (UIButton *)[self.view viewWithTag:1002];
                NSString *title = @"发送验证码";
                btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
                [btn setTitle:title forState:UIControlStateNormal];
                btn.backgroundColor = txtColors(248, 53, 74, 1);
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                timeSec =120;
                btn.enabled = YES;
                telNumber.text = @"";
                codeFiled.text = @"";
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self lognAction];
                }];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    newpasView.alpha = 0.95;
                    [self.view addSubview:newpasView];
                }];
                [alert addAction:suerAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if([[dic objectForKey:@"massage"]intValue]==2){
                [Hud hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"邀请码错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else if([[dic objectForKey:@"massage"]intValue]==0){
                [Hud hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"该手机号已注册过";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else if([[dic objectForKey:@"massage"]intValue]==4){
                [Hud hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"手机号格式有误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else if([[dic objectForKey:@"massage"]intValue]==1){
                [Hud hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"手机号或验证码为空";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
//登录
-(void)lognAction
{
    [UIView animateWithDuration:0.3 animations:^{
        newpasView.alpha = 0;
        [newpasView removeFromSuperview];
    }];
    NSString *pasdStr = [md5_password encryptionPassword:@"123456" userTel:_userPhone];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:_userPhone forKey:@"user.tel"];
    [jsonDict setObject:pasdStr forKey:@"user.password"];
    [jsonDict setObject:userSheBei_id forKey:@"user.shebeiId"];
    [jsonDict setObject:userShequ_id forKey:@"user.defaultShequ"];
    [HTTPTool getWithUrl:@"login4.action" params:jsonDict success:^(id json) {
        NSDictionary * dic = (NSDictionary * )json;
        if ([[dic objectForKey:@"massage"]intValue]==2) {
            
            NSString *usid = [NSString stringWithFormat:@"%@",[json valueForKey:@"userid"]];
            [[NSUserDefaults standardUserDefaults] setValue:usid forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"xinrenli"] forKey:@"xinrenli"];
            
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"登录成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            NSNotification *userLoginNotification = [NSNotification notificationWithName:@"userLoginNotification" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginNotification" object:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(btnAction) withObject:self afterDelay:1.5];
            
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
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"账号或密码错误";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//定时器
-(void)timImngAction
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:1002];
    btn.backgroundColor = [UIColor grayColor];
    NSString *title = [NSString stringWithFormat:@"%lds后可再次发送",(long)timeSec];
    if (timeSec>=0) {
        timeSec--;
        [self performSelector:@selector(timImngAction) withObject:self afterDelay:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        btn.enabled = NO;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
    }
    else{
        UIButton *btn = (UIButton *)[self.view viewWithTag:1002];
        NSString *title = @"发送验证码";
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.backgroundColor = txtColors(248, 53, 74, 1);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        timeSec =120;
        btn.enabled = YES;
    }
}
//同意协议
-(void)agreeAction
{
    UIImageView *image =(UIImageView *)[self.view viewWithTag:1001];
    UIButton *btn = (UIButton *)[self.view viewWithTag:110011];
    if (isAgree == 0) {
        image.image = [UIImage imageNamed:@"选择"];
        isAgree = 1;
        btn.enabled = NO;
        btn.backgroundColor = txtColors(150, 150, 150, 1);
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        isAgree = 0;
        btn.enabled = YES;
        btn.backgroundColor = txtColors(248, 53, 74, 1);
    }
}
#pragma mark -- UITextFilerDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 11001){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
-(void)userAgreement
{
    UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
    agr.pageUrl = [NSString stringWithFormat:@"%@gonggao/yonghuxieyi.jsp",HTTPHEADER];
    agr.titStr = @"妙生活城平台用户协议";
    [self.navigationController pushViewController:agr animated:YES];
}
#pragma mark --BtnAction
-(void)btnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
-(void)jumpTask
{
    sleep(3);
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


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [telNumber resignFirstResponder];
    [codeFiled resignFirstResponder];
}

@end
