//
//  LognPopView.m
//  LifeForMM
//
//  Created by HUI on 16/3/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "LognPopView.h"
#import "AFNetworking.h"
@implementation LognPopView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self initSubViews];
        
        [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timerStop) name:@"timerStop" object:nil];
    }
    return self;
}

-(void)timerStop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.seconds = 5;
}
-(void)initSubViews
{    UIImageView *userNameImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    userNameImage.image = [UIImage imageNamed:@"账户"];
    userNameImage.tag = 101;
    userNameImage.backgroundColor = [UIColor clearColor];
    [self addSubview:userNameImage];
    UIImageView *passdImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    passdImage.image = [UIImage imageNamed:@"输入密码"];
    passdImage.tag = 102;
    passdImage.backgroundColor = [UIColor clearColor];
    [self addSubview:passdImage];
    
    _tleTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
    _tleTextFile.tag = 11001;
    _tleTextFile.backgroundColor = [UIColor clearColor];
    _tleTextFile.textAlignment = NSTextAlignmentLeft;
    _tleTextFile.font = [UIFont systemFontOfSize:MLwordFont_2];
    _tleTextFile.placeholder = @"请输入登录手机号";
    _tleTextFile.text = userName_tel;
    _tleTextFile.delegate = self;
    _tleTextFile.textColor = [UIColor blackColor];
    _tleTextFile.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_tleTextFile];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"账号删除"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = 103;
    [btn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectZero];
    line1.tag =104;
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    _pasTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
    _pasTextFile.tag = 11002;
    _pasTextFile.placeholder = @"请输入密码";
    _pasTextFile.text = userPass_pas;
    [_pasTextFile setSecureTextEntry:YES];
    _pasTextFile.delegate = self;
    _pasTextFile.textAlignment = NSTextAlignmentLeft;
    _pasTextFile.textColor = [UIColor blackColor];
    _pasTextFile.font = [UIFont systemFontOfSize:MLwordFont_2];
    _pasTextFile.backgroundColor = [UIColor clearColor];
    [self addSubview:_pasTextFile];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectZero];
    line2.tag =105;
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    _isAutoImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]) {
        _isAutoImage.image = [UIImage imageNamed:@"选中"];
    }
    else
        _isAutoImage.image = [UIImage imageNamed:@"选择"];
    _isAutoImage.backgroundColor = [UIColor clearColor];
    _isAutoImage.tag = 106;
    _isAutoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_isAutoImage addGestureRecognizer:tap];
    [self addSubview:_isAutoImage];
    
    UILabel *autoLoginLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    autoLoginLabel.textColor = textBlackColor;
    autoLoginLabel.tag = 107;
    autoLoginLabel.text = @"自动登录";
    autoLoginLabel.textAlignment = NSTextAlignmentLeft;
    autoLoginLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    autoLoginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:autoLoginLabel];
    autoLoginLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *lbTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [autoLoginLabel addGestureRecognizer:lbTap];
    
    UILabel *disPassdLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    disPassdLabel.text = @"忘记密码";
    disPassdLabel.tag = 108;
    disPassdLabel.textAlignment = NSTextAlignmentLeft;
    disPassdLabel.textColor = txtColors(25, 182, 133, 1);
    disPassdLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    disPassdLabel.backgroundColor = [UIColor clearColor];
    disPassdLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *disPassTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [disPassdLabel addGestureRecognizer:disPassTap];
    [self addSubview:disPassdLabel];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.tag = 109;
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
    [loginBtn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    _remainLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]){
        _remainLabel.text = @"5";
    }
    else
        _remainLabel.text = @"";
    _remainLabel.alpha = 0;
    _remainLabel.textAlignment = NSTextAlignmentCenter;
    _remainLabel.textColor = [UIColor whiteColor];
    _remainLabel.backgroundColor = [UIColor clearColor];
    _remainLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self addSubview:_remainLabel];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    alertLabel.numberOfLines = 0;
    alertLabel.tag = 110;
    alertLabel.textAlignment = NSTextAlignmentLeft;
    alertLabel.textColor = textBlackColor;
    alertLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    alertLabel.text = @"温馨提示：未注册妙生活城账号的手机号，登录时将自动注册妙生活城账号，且代表您已同意";
    [self addSubview:alertLabel];
    
    UILabel *xieyi = [[UILabel alloc]initWithFrame:CGRectZero];
    xieyi.text = @"《妙生活城平台用户协议》";
    xieyi.tag = 111;
    xieyi.textColor = txtColors(25, 182, 133, 1);
    xieyi.textAlignment = NSTextAlignmentLeft;
    xieyi.backgroundColor = [UIColor clearColor];
    xieyi.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyi.userInteractionEnabled = YES;
    [self addSubview:xieyi];
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [xieyi addGestureRecognizer:agreeTap];
    
    UIView *line3 =[[UIView alloc]initWithFrame:CGRectZero];
    line3.tag = 112;
    line3.backgroundColor = txtColors(25, 182, 133, 1);
    [self addSubview:line3];
    alertLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.backgroundColor = [UIColor clearColor];
    regBtn.tag = 113;
    [regBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [regBtn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:regBtn];
    _seconds = 5;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *userNameImage = [self viewWithTag:101]; // 账户
    userNameImage.frame = CGRectMake(20*MCscale, 25*MCscale, 30*MCscale, 30*MCscale);
    UIImageView *passdImage = [self viewWithTag:102]; //密码
    passdImage.frame = CGRectMake(20*MCscale, userNameImage.bottom+25*MCscale, 30*MCscale, 30*MCscale);
    _tleTextFile.frame = CGRectMake(userNameImage.right+5, 25*MCscale, self.width-120*MCscale, 30*MCscale);
    _pasTextFile.frame = CGRectMake(passdImage.right+5, passdImage.top, self.width-70*MCscale, 30*MCscale);
    UIButton *btn = (UIButton *)[self viewWithTag:103]; //账号删除
    btn.frame = CGRectMake(_tleTextFile.right+10*MCscale, 27, 25, 25);
    UIView *line1 = [self viewWithTag:104];//灰色分割线
    line1.frame = CGRectMake(10, _tleTextFile.bottom+12*MCscale, self.width-20, 1);
    UIView *line2 = [self viewWithTag:105];// 灰色分割线
    line2.frame = CGRectMake(10, _pasTextFile.bottom+12*MCscale, self.width-20, 1);
    _isAutoImage.frame = CGRectMake(45*MCscale, line2.bottom+18*MCscale, 22*MCscale, 22*MCscale);
    UILabel *autoLoginLabel = (UILabel *)[self viewWithTag:107]; //自动登录 label
    autoLoginLabel.frame = CGRectMake(_isAutoImage.right+5, _isAutoImage.top-4, 100*MCscale, 30*MCscale);
    
    UILabel *disPassdLabel = (UILabel *)[self viewWithTag:108];//忘记密码
    disPassdLabel.frame = CGRectMake(self.width-120*MCscale, autoLoginLabel.top, 100*MCscale, 30*MCscale);
    UIButton *loginBtn = (UIButton *)[self viewWithTag:109];//登录按钮
    loginBtn.frame = CGRectMake(20*MCscale, _isAutoImage.bottom+15*MCscale, self.width-40*MCscale, 45*MCscale);
    UILabel *alertLabel = (UILabel *)[self viewWithTag:110];
    alertLabel.frame = CGRectMake(15*MCscale, loginBtn.bottom+15*MCscale, self.width-30*MCscale, 60*MCscale);
    _remainLabel.frame = CGRectMake(loginBtn.left+30*MCscale, loginBtn.top+13*MCscale, 20*MCscale, 20*MCscale);//倒计时
    UILabel *xieyi = (UILabel *)[self viewWithTag:111];
    xieyi.frame = CGRectMake(18*MCscale, alertLabel.bottom-15*MCscale, 175*MCscale_1, 20*MCscale);
    UIView *line3 = [self viewWithTag:112];
    line3.frame = CGRectMake(xieyi.left+5, xieyi.bottom-2, xieyi.width-10, 1);
    UIButton *regBtn = (UIButton *)[self viewWithTag:113];//注册
    regBtn.frame = CGRectMake(kDeviceWidth*6/10.0, alertLabel.bottom+10*MCscale, 90*MCscale, 30*MCscale);
}
//btn事件
-(void)lognBtnAction:(UIButton *)btn
{
    NSInteger btnTag = btn.tag;
    if (btnTag == 103) {
        [self delAccount];//账号删除
    }
    else if (btnTag == 109){
        [self login]; //登录
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(lognPopView:btnIndex:)]) {
            [self.delegate lognPopView:self btnIndex:btnTag];
        }
    }
}
//tap事件
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapTag = tap.view.tag;
    if (tapTag == 106 || tapTag == 107){
        [self autoLoginAction]; //是否自动登录
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(lognPopView:btnIndex:)]) {
            [self.delegate lognPopView:self btnIndex:tapTag];
        }
    }
}
//清除账号
-(void)delAccount
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.remainLabel.alpha = 0;
    self.seconds = 5;
    self.tleTextFile.text = @"";
    self.pasTextFile.text = @"";
}
//自动登录选中
-(void)autoLoginAction
{
    UIImageView *image = (UIImageView *)[self viewWithTag:106];
    NSString *isAuto_bol = @"1";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"]) {
        isAuto_bol = [[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"];
    }
    else
    {
        isAuto_bol = @"1";
    }
    if ([isAuto_bol isEqualToString:@"1"]) {
        image.image = [UIImage imageNamed:@"选择"];
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"longCode_bol"];
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"longCode_bol"];
        [self countdownAction];
    }
}

//倒计时
-(void)countdownAction
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]){
        self.seconds--;
        if (self.seconds>0) {
            self.remainLabel.text = [NSString stringWithFormat:@"%ld",(long)self.seconds];
            [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
        }
        else{
            UIButton *btn = (UIButton *)[self viewWithTag:1101];
            [btn setTitle:@"登录中..." forState:UIControlStateNormal];
            self.remainLabel.text = @"";
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.seconds = 5;
            [self login];
        }
    }
    else{
        self.remainLabel.text = @"";
        self.seconds = 5;
    }
}
#pragma mark -- 登陆
-(void)login
{
    if ([_tleTextFile.text isEqualToString:@""] || [_pasTextFile.text isEqualToString:@""]) {
        [self requestNetworkWrong:@"账户或密码不能为空"];
    }
    else
    {
        UIButton *btn = (UIButton *)[self viewWithTag:109];
        [btn setTitle:@"登录中..." forState:UIControlStateNormal];
        self.remainLabel.text = @"";
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.seconds = 5;
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        NSString *logName = self.tleTextFile.text;
        NSString *mdPasd = [md5_password encryptionPassword:self.pasTextFile.text userTel:logName];
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
        [jsonDict setObject:logName forKey:@"user.tel"];
        [jsonDict setObject:mdPasd forKey:@"user.password"];
        [jsonDict setObject:userSheBei_id forKey:@"user.shebeiId"];
        [jsonDict setObject:userShequ_id forKey:@"user.defaultShequ"];
        [HTTPTool getWithUrl:@"login4.action" params:jsonDict success:^(id json) {
            NSDictionary * dic = (NSDictionary * )json;
            NSLog(@"--- ilsdagfhladsjl%@",json);
            
            [Hud hide:YES];
            if ([[dic objectForKey:@"massage"]intValue]==2) {
                if ([self.delegate respondsToSelector:@selector(loginSuccessWithDict:)]) {
                    [self.delegate loginSuccessWithDict:dic];
                }
                self.seconds = 5;
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setInteger:1 forKey:@"isLogin"];
                [def setValue:self.tleTextFile.text forKey:@"userTel"];
                [def setValue:self.pasTextFile.text forKey:@"userPass"];
                NSString *usid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"]];
                [def setValue:usid forKey:@"userId"];
                [def setValue:[dic valueForKey:@"xinrenli"] forKey:@"xinrenli"];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                NSNotification *userLoginNotification = [NSNotification notificationWithName:@"userLoginNotification" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginNotification" object:nil];
                
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
                [self requestNetworkWrong:@"账号或密码错误"];
                [btn setTitle:@"登录" forState:UIControlStateNormal];
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            [self requestNetworkWrong:@"网络连接错误"];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
}
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
#pragma mark -- UITextFilerDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.remainLabel.alpha = 0;
    if (textField.tag == 11002 || textField.tag == 11001) {
        UIButton *btn = (UIButton *)[self viewWithTag:1101];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
    }
}
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
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tleTextFile resignFirstResponder];
    [self.pasTextFile resignFirstResponder];
}

@end
