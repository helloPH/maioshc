//
//  SetPaymentPasswordView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SetPaymentPasswordView.h"
@implementation SetPaymentPasswordView
{
    UIButton *sureBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldText:) name:@"fieldText" object:nil];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    for (int i=0; i<2; i++) {
        UITextField *textfiled = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, 20*MCscale+60*i*MCscale, self.width-20*MCscale, 40*MCscale)];
        textfiled.textAlignment = NSTextAlignmentCenter;
        [textfiled setSecureTextEntry:YES];
        textfiled.textColor = [UIColor blackColor];
        textfiled.backgroundColor = [UIColor clearColor];
        textfiled.font = [UIFont systemFontOfSize:MLwordFont_2];
        textfiled.tag = i+1;
        textfiled.delegate = self;
        textfiled.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:textfiled];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, textfiled.bottom+5*MCscale, self.width-20*MCscale, 1)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
    }
    
    sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = redTextColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}

-(void)getTextFieldPlaceholderWithArray:(NSArray *)array
{
    UITextField *newfile = (UITextField *)[self viewWithTag:1];
    newfile.placeholder = array[0];
    UITextField *newfileAgn = (UITextField *)[self viewWithTag:2];
    newfileAgn.placeholder = array[1];
}
-(void)fieldText:(NSNotification *)noti
{
    self.oldPas = noti.userInfo[@"fieldText"];
}

-(void)sureBtnClick:(UIButton *)btn
{
    UITextField *newfile = (UITextField *)[self viewWithTag:1];
    UITextField *newfileAgn = (UITextField *)[self viewWithTag:2];
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    
            if ([newfile.text isEqualToString:newfileAgn.text]) {
            if (self.isFrom == 1) {//登录密码
                //重置登陆密码
                NSString *newPas;
                newPas = newfile.text;
                if([self.oldPas isEqualToString:@"123456"]){
                    self.oldPas = @"-1";
                }
                NSString *mdPasd = [md5_password encryptionPassword:self.oldPas userTel:userName_tel];
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":user_id,@"yuanmima":mdPasd,@"xinmima":newPas}];
                [HTTPTool getWithUrl:@"loginpwd1.action" params:pram success:^(id json) {
                    NSDictionary *dic = (NSDictionary *)json;
                    [Hmud hide:YES];
                    if ([[dic valueForKey:@"message"]integerValue]==1) {
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setInteger:2 forKey:@"isLogin"];
                        [def setValue:newPas forKey:@"userPass"];
                        newfile.text = @"";
                        newfileAgn.text = @"";
                        if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                            [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                        }
                    }
                    else if ([[dic valueForKey:@"massage"]integerValue]==2){
                        if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                            [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                        }
                    }
                    else if ([[dic valueForKey:@"massage"]integerValue]==3) {
                        if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                            [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                        }
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"网络连接错误";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else
            {
                if (newfile.text.length == 6) {
                    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"xinmima":newfile.text}];
                    [HTTPTool getWithUrl:@"paypw.action" params:pram success:^(id json) {
                        [Hmud hide:YES];
                        if ([[json valueForKey:@"message"] integerValue] == 1) {
                            if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                                [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                                newfile.text = @"";
                                newfileAgn.text = @"";
                            }
                        }else{
                            if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                                [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                            }
                        }
                    } failure:^(NSError *error) {
                        [Hmud hide:YES];
                        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                        bud.mode = MBProgressHUDModeCustomView;
                        bud.labelText = @"网络连接错误";
                        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }];
                }
                else{
                    [Hmud hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"请输入6位长度密码";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
            }
        }
        else{
            [Hmud hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"两次密码不一致";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.isFrom == 2) {
        if (textField.tag == 1 || textField.tag == 2) {
            if (textField.text.length == 0) {
                return YES;
            }
            NSInteger exitLength = textField.text.length;
            NSInteger selectLength = range.length;
            NSInteger replaceLength = string.length;
            if (exitLength - selectLength +replaceLength>6) {
                return NO;
            }
        }
    }
        return YES;
}


-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}

@end
