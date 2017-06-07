//
//  BindMailboxView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "BindMailboxView.h"

@implementation BindMailboxView
{
    UIButton *sureBtn;
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
    UITextField *filed = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, 55*MCscale,self.width-20*MCscale , 40*MCscale)];
    filed.placeholder = @"请输入常用邮箱方便找回密码";
    filed.textAlignment = NSTextAlignmentCenter;
    filed.textColor = [UIColor blackColor];
    filed.font = [UIFont systemFontOfSize:MLwordFont_2];
    filed.keyboardType = UIKeyboardTypeEmailAddress;
    filed.tag = 1001;
    [self addSubview:filed];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, filed.bottom+10*MCscale, self.width-20*MCscale, 1)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    
    sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = redTextColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [sureBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(bangDingEmail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}
-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}


//绑定邮箱
-(void)bangDingEmail
{
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    UITextField *fild = (UITextField *)[self viewWithTag:1001];
    BOOL isEmail = [emailTest evaluateWithObject:fild.text];
    if (isEmail) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"email":fild.text}];
        [HTTPTool getWithUrl:@"boundEmail.action" params:pram success:^(id json) {
            [Hmud hide:YES];
            NSDictionary *dic = (NSDictionary *)json;
            if ([[dic valueForKey:@"message"] integerValue]==1) {
                 fild.text = @"";
                if ([self.bingMailDelegate respondsToSelector:@selector(BindMailboxSuccessWithIndex:)]) {
                    [self.bingMailDelegate BindMailboxSuccessWithIndex:[[dic valueForKey:@"message"] integerValue]];
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
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"邮箱格式错误!";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end

