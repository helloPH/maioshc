//
//  LoginPasswordView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "LoginPasswordView.h"

@implementation LoginPasswordView
{
    UIButton *sureBtn;
    UITextField *filed;
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
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    filed = [[UITextField alloc]initWithFrame:CGRectMake(10, 55,self.width-20 , 40)];
    filed.tag = 101;
    filed.placeholder = @"请输入登录密码";
    [filed setSecureTextEntry:YES];
    filed.textAlignment = NSTextAlignmentCenter;
    filed.textColor = [UIColor blackColor];
    filed.font = [UIFont systemFontOfSize:MLwordFont_2];
    filed.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:filed];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, filed.bottom+10, self.width-20, 1)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    
    sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = redTextColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [sureBtn setTitle:@"登录密码验证" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}
-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}
-(void)sureBtnClick:(UIButton *)btn
{
    NSString *pas = [md5_password encryptionPassword:filed.text userTel:userName_tel];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"user.tel":user_id,@"user.password":pas}];
    [HTTPTool getWithUrl:@"findbydenglu1.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"] integerValue]==2) {
            NSDictionary * dic = @{@"fieldText":filed.text};
             filed.text = @"";
            NSNotification *fieldText = [NSNotification notificationWithName:@"fieldText" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:fieldText];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fieldText" object:nil];
            
            if ([self.loginPasswordDelegate respondsToSelector:@selector(LoginPasswordViewSuccessWithIndex:)]){
                [self.loginPasswordDelegate LoginPasswordViewSuccessWithIndex:self.indexPath];
            }
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"登录密码错误!请重新输入";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}


@end
