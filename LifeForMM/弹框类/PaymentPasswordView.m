//
//  PaymentPasswordView.m
//  LifeForMM
//
//  Created by MIAO on 16/5/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "PaymentPasswordView.h"
#import "Header.h"
@implementation PaymentPasswordView
{
    NSMutableArray *passArray;//密码
    NSArray *numBtnTitleAry;//按钮数字
    NSMutableArray *labelAry;//密码输入框
    NSMutableArray *btnArray;//数字键
    NSInteger tapNumber;//点击次数
    MBProgressHUD *allBub;
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
        
        tapNumber = 0;
        passArray = [[NSMutableArray alloc]initWithCapacity:6];
        
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.width, 30*MCscale)];
    label.text = @"请输入支付密码";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:MLwordFont_4];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, self.width, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    labelAry = [[NSMutableArray alloc]initWithCapacity:6];
    for (int i=0; i<6; i++) {
        UILabel *pasLabel = [[UILabel alloc]initWithFrame:CGRectMake(0+self.width/6.0*i, line1.bottom, (self.width-5)/6.0, 45*MCscale)];
        pasLabel.textColor = txtColors(248, 53, 74, 1);
        pasLabel.textAlignment = NSTextAlignmentCenter;
        pasLabel.font = [UIFont systemFontOfSize:50*MCscale];
        pasLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:pasLabel];
        [labelAry addObject:pasLabel];
        if (i<5) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(pasLabel.right+1, line1.bottom+2, 1, 41*MCscale)];
            line.backgroundColor = lineColor;
            [self addSubview:line];
        }
    }
    for (int j= 0; j<4; j++) {
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, line1.bottom+45*MCscale+70*MCscale*j, self.width, 1)];
        line2.backgroundColor = lineColor;
        [self addSubview:line2];
    }
    for (int k = 0; k<2; k++) {
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(1+self.width/3.0+self.width/3.0*k, 81*MCscale, 1, self.height-81*MCscale)];
        line3.backgroundColor = lineColor;
        [self addSubview:line3];
    }
    CGFloat btnDistance = self.width/3.0;
    NSInteger btnCount = 0;
    numBtnTitleAry = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    btnArray = [[NSMutableArray alloc]initWithCapacity:11];
    for (int m = 0; m<4; m++) {
        for (int n = 0; n<3; n++) {
            if (m<3) {
                UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                numBtn.frame = CGRectMake(btnDistance*n, (81+70*m)*MCscale, btnDistance, 70*MCscale);
                [numBtn setBackgroundColor:[UIColor clearColor]];
                [numBtn setTitle:numBtnTitleAry[btnCount] forState:UIControlStateNormal];
                [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                numBtn.titleLabel.font = [UIFont systemFontOfSize:35*SCscale];
                numBtn.tag = btnCount+1;
                [numBtn addTarget:self action:@selector(inputPassAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:numBtn];
                [btnArray addObject:numBtn];
            }
            else{
                if (n==1) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(btnDistance, self.height-70*MCscale, btnDistance, 70*MCscale);
                    btn.backgroundColor = [UIColor clearColor];
                    btn.titleLabel.font = [UIFont systemFontOfSize:35*SCscale];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn setTitle:@"0" forState:UIControlStateNormal];
                    btn.tag = 0;
                    [btn addTarget:self action:@selector(inputPassAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:btn];
                    [btnArray addObject:btn];
                }
                if (n==2) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(2*btnDistance+2, self.height-68*MCscale, btnDistance-4, 68*MCscale);
                    btn.layer.cornerRadius = 15.0;
                    btn.layer.masksToBounds =YES;
                    [btn setBackgroundImage:[UIImage imageNamed:@"删除png"] forState:UIControlStateNormal];
                    btn.backgroundColor = [UIColor clearColor];
                    btn.tag = 10;
                    [btn addTarget:self action:@selector(deleatInput) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:btn];
                    [btnArray addObject:btn];
                }
            }
            btnCount++;
        }
    }
}


//输入密码按钮Action
-(void)inputPassAction:(UIButton *)btn
{
    if (tapNumber<6) {
        tapNumber++;
        [btn setTitleColor:redTextColor forState:UIControlStateNormal];
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        [passArray addObject:numStr];
        UILabel *pass = labelAry[tapNumber-1];
        pass.text = @"•";
        if(tapNumber == 6){
            NSMutableString *mutStr = [[NSMutableString alloc]initWithCapacity:6];
            for(NSString *str in passArray){
                [mutStr appendString:str];
            }
            for (int j=0; j<10; j++) {
                if (j<6) {
                    UILabel *pas = labelAry[j];
                    pas.text = @"";
                }
                UIButton *button = btnArray[j];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            tapNumber = 0;
            [self yuezhifuAction:mutStr];
            [passArray removeAllObjects];
        }
    }
}
//删除按钮
-(void)deleatInput
{
    if (tapNumber>0) {
        tapNumber--;
        [passArray removeObjectAtIndex:tapNumber];
        UILabel *pass = labelAry[tapNumber];
        pass.text = @"";
    }
}
//余额支付
-(void)yuezhifuAction:(NSString *)zhfimm
{
    NSString *pas = [md5_password encryptionPassword:zhfimm userId:user_id];
    NSMutableDictionary *mimaDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"zhifuMima":pas}];
    [HTTPTool getWithUrl:@"findbyuserid1.action" params:mimaDic success:^(id json) {
        if ([[json valueForKey:@"massages"]integerValue] ==1) {
            if ([self.paymentPasswordDelegate respondsToSelector:@selector(PaymentSuccess)]) {
                [self.paymentPasswordDelegate PaymentSuccess];
            }
        }
        else{
            [allBub hide:YES];
            MBProgressHUD *mghud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            mghud.mode = MBProgressHUDModeCustomView;
            mghud.labelText = @"密码验证失败,请重新输入";
            [mghud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误11";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
- (void)myTask {
    sleep(2);
}

@end
