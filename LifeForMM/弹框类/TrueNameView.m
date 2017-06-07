//
//  TrueNameView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "TrueNameView.h"

@implementation TrueNameView
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
    NSArray *ary = @[@"请输入真实姓名",@"请输入有效身份证号"];
    for (int i = 0 ; i<2; i++) {
        UITextField *textfiled = [[UITextField alloc]initWithFrame:CGRectMake(20, 30+60*i, self.width-20, 40)];
        textfiled.placeholder = ary[i];
        textfiled.tag = i+1;
        textfiled.textAlignment = NSTextAlignmentCenter;
        textfiled.textColor = [UIColor blackColor];
        textfiled.font = [UIFont systemFontOfSize:MLwordFont_2];
        textfiled.backgroundColor = [UIColor clearColor];
        if (i==1) {
            textfiled.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self addSubview:textfiled];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 79, self.width-20, 1)];
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
    [sureBtn addTarget:self action:@selector(shimingrenzheng) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}
-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}

//实名认证
-(void)shimingrenzheng
{
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    UITextField *fileName = (UITextField *)[self viewWithTag:1];
    UITextField *fileCard = (UITextField *)[self viewWithTag:2];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"realname":fileName.text,@"shenfenzhenghao":fileCard.text}];
    [HTTPTool postWithUrl:@"renzheng.action" params:pram success:^(id json) {
        [Hmud hide:YES];
        if ([[json valueForKey:@"message"]integerValue]==1) {
            fileName.text = @"";
            fileCard.text = @"";
            if ([self.trueNameDelegate respondsToSelector:@selector(rengzhengSuccessWithIndex:)]) {
                [self.trueNameDelegate rengzhengSuccessWithIndex:[[json valueForKey:@"message"]integerValue]];
            }
        }
        else
        {
            if ([self.trueNameDelegate respondsToSelector:@selector(rengzhengSuccessWithIndex:)]) {
                [self.trueNameDelegate rengzhengSuccessWithIndex:[[json valueForKey:@"message"]integerValue]];
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

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
