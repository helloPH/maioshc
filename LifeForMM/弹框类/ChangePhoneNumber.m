//
//  ChangePhoneNumber.m
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ChangePhoneNumber.h"

@implementation ChangePhoneNumber
{
    UIButton *sureBtn;
    UIButton *sendCode;
    NSInteger timeSec;//倒计时
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        timeSec = 60;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MCscale, 40*MCscale, 22*MCscale, 22*MCscale)];
    phoneImage.backgroundColor = [UIColor clearColor];
    phoneImage.image = [UIImage imageNamed:@"输入手机号"];
    [self addSubview:phoneImage];
    
    UITextField *telNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneImage.right,35*MCscale, 180*MCscale, 35*MCscale)];
    telNumber.placeholder = @"请输入登录手机号";
    telNumber.textColor = [UIColor blackColor];
    telNumber.tag = 1101;
    telNumber.font = [UIFont systemFontOfSize:MLwordFont_11];
    telNumber.textAlignment = NSTextAlignmentLeft;
    telNumber.backgroundColor = [UIColor clearColor];
    telNumber.keyboardType  = UIKeyboardTypeNumberPad;
    [self addSubview:telNumber];
    
    sendCode = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCode.frame = CGRectMake(telNumber.right+2, 35*MCscale, self.width-telNumber.width-40*MCscale, 40*MCscale);
    sendCode.backgroundColor = txtColors(248, 53, 74, 1);
    [sendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendCode.titleLabel.font =[UIFont systemFontOfSize:MLwordFont_2];
    sendCode.layer.cornerRadius = 3.0;
    sendCode.layer.masksToBounds = YES;
    sendCode.tag = 1002;
    [sendCode addTarget:self action:@selector(ChangePhoneNumberCkick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendCode];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15*MCscale,telNumber.bottom+10, telNumber.width+20*MCscale, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(17*MCscale, line1.bottom+23*MCscale, 20*MCscale, 22*MCscale)];
    codeImage.backgroundColor = [UIColor clearColor];
    codeImage.image = [UIImage imageNamed:@"输入验证码"];
    [self addSubview:codeImage];
    
    UITextField *codeFiled = [[UITextField alloc]initWithFrame:CGRectMake(codeImage.right+2, line1.bottom+20*MCscale, 180*MCscale, 30*MCscale)];
    codeFiled.placeholder = @"请输入短信验证码";
    codeFiled.tag = 1102;
    codeFiled.keyboardType = UIKeyboardTypeNumberPad;
    codeFiled.textColor = [UIColor blackColor];
    codeFiled.backgroundColor = [UIColor clearColor];
    codeFiled.textAlignment = NSTextAlignmentLeft;
    codeFiled.font = [UIFont systemFontOfSize:MLwordFont_11];
    [self addSubview:codeFiled];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(15*MCscale, codeFiled.bottom+10*MCscale, self.width-30*MCscale, 1)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = redTextColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [sureBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(ChangePhoneNumberCkick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}
-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}
-(void)ChangePhoneNumberCkick:(UIButton *)btn
{
    if (btn == sendCode) {//验证码
        UITextField *numPh = (UITextField *)[self viewWithTag:1101];
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        BOOL isMatch = [phoneTest evaluateWithObject:numPh.text];
        if(!isMatch){
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"您输入的手机号码不正确!请重新输入";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
            [jsonDict setObject:numPh.text forKey:@"user.tel"];
            
            [HTTPTool getWithUrl:@"showCode.action" params:jsonDict success:^(id json) {
                NSDictionary * dic = (NSDictionary * )json;
                
                if ([[dic objectForKey:@"massage"]intValue]==0) {
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"该手机号已经注册过";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else if ([[dic objectForKey:@"massage"]intValue]==1) {
                    [self timImngAction];
                }
                else{
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"该手机号有误!请重新填写";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
    }
    else if(btn == sureBtn)//确认更换
    {
        UITextField *numPh = (UITextField *)[self viewWithTag:1101];
        UITextField *codePh = (UITextField *)[self viewWithTag:1102];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"code":codePh.text,@"user.tel":numPh.text}];
        [HTTPTool getWithUrl:@"uqdatephone.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"massage"]integerValue]==4) {
                //成功
                NSNotification *changeNumberNotification = [NSNotification notificationWithName:@"changeNumberNotification" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:changeNumberNotification];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeNumberNotification" object:nil];
                
                UIButton *btn = (UIButton *)[self viewWithTag:1002];
                NSString *title = @"发送验证码";
                btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
                [btn setTitle:title forState:UIControlStateNormal];
                btn.backgroundColor = txtColors(248, 53, 74, 1);
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                timeSec =60;
                btn.enabled = YES;
                
                if ([self.changeDelegate respondsToSelector:@selector(ChangePhoneNumberWithString:AndIndex:)]) {
                    [self.changeDelegate ChangePhoneNumberWithString:numPh.text AndIndex:[[json valueForKey:@"massage"]integerValue]];
                }
                numPh.text = @"";
                codePh.text = @"";
            }
            else if ([[json valueForKey:@"massage"]integerValue]==3){
                if ([self.changeDelegate respondsToSelector:@selector(ChangePhoneNumberWithString:AndIndex:)]) {
                    [self.changeDelegate ChangePhoneNumberWithString:numPh.text AndIndex:[[json valueForKey:@"massage"]integerValue]];
                }
            }
            else{
                if ([self.changeDelegate respondsToSelector:@selector(ChangePhoneNumberWithString:AndIndex:)]) {
                    [self.changeDelegate ChangePhoneNumberWithString:numPh.text AndIndex:[[json valueForKey:@"massage"]integerValue]];
                }
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
//倒计时
-(void)timImngAction
{
    UIButton *btn = (UIButton *)[self viewWithTag:1002];
    btn.backgroundColor = [UIColor grayColor];
    NSString *title = [NSString stringWithFormat:@"%lds后可再次发送",(long)timeSec];
    if (timeSec>=0) {
        timeSec--;
        [self performSelector:@selector(timImngAction) withObject:self afterDelay:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        btn.enabled = NO;
        [btn setTitle:title forState:UIControlStateNormal];
    }
    else{
        UIButton *btn = (UIButton *)[self viewWithTag:1002];
        NSString *title = @"发送验证码";
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = txtColors(248, 53, 74, 1);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        timeSec =60;
        btn.enabled = YES;
    }
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
