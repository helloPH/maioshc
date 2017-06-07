//
//  ReceiveBenefitsView.m
//  LifeForMM
//
//  Created by MIAO on 16/5/25.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ReceiveBenefitsView.h"
#import "FuliModel.h"
#import "MNWheelView.h"
@implementation ReceiveBenefitsView
{
    MNWheelView *view;
    NSString *danhaoStr;
    NSString *fulishopid;
    NSString *fuliname;
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
    self.titleContentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleContentLabel.text = @"恭喜免费选福利喽";
    self.titleContentLabel.textColor = redTextColor;
    self.titleContentLabel.textAlignment = NSTextAlignmentLeft;
    self.titleContentLabel.font = [UIFont systemFontOfSize:MLwordFont_12];
    [self addSubview:self.titleContentLabel];
    
    self.horizontalLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.horizontalLine.backgroundColor = lineColor;
    [self addSubview:self.horizontalLine];
    
    self.verticalLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.verticalLine.backgroundColor = lineColor;
    [self addSubview:self.verticalLine];
    
    self.abandonBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.abandonBtn setTitle:@"放弃" forState:UIControlStateNormal];
    [self.abandonBtn setTitleColor:textColors forState:UIControlStateNormal];
    [self.abandonBtn.titleLabel setFont:[UIFont systemFontOfSize:MLwordFont_2]];
    [self.abandonBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.abandonBtn];
    
    self.receiveBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
    [self.receiveBtn setTitleColor:redTextColor forState:UIControlStateNormal];
    [self.receiveBtn.titleLabel setFont:[UIFont systemFontOfSize:MLwordFont_2]];
    [self.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.receiveBtn];
    
    
    //self.titleContentLabel
    [self.titleContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //上
        make.top.equalTo(self.mas_top).offset(10*MCscale);
        //左
        make.left.equalTo(self.mas_left).offset(10*MCscale);
    }];
    
    //self.horizontalLine
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //上
        make.top.equalTo(self.mas_bottom).offset(-60*MCscale);
        //左
        make.left.equalTo(self.mas_left).offset(0);
        //右
        make.right.equalTo(self.mas_right).offset(0);
        //高
        make.height.equalTo(@(1));
        
        //与self.verticalLine之间的间距
        make.bottom.equalTo(self.verticalLine.mas_top).offset(0);
        
        //与self.abandonBtn之间的间距
        make.bottom.equalTo(self.abandonBtn.mas_top).offset(0);
        
        //与self.receiveBtn之间的间隙
        make.bottom.equalTo(self.receiveBtn.mas_top).offset(0);
    }];
    
    //self.verticalLine
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //居中
        make.centerX.equalTo(self.mas_centerX);
        //下
        make.bottom.equalTo(self.mas_bottom).offset(0);
        //宽
        make.width.equalTo(@(1));
        
        //与self.abandonBtn之间的间隙
        make.left.equalTo(self.abandonBtn.mas_right).offset(0);
        
        //与self.receiveBtn之间的间隙
        make.right.equalTo(self.receiveBtn.mas_left).offset(0);
        
    }];
    
    //self.abandonBtn
    [self.abandonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //左
        make.left.equalTo(self.mas_left).offset(0);
        
        //下
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    //    self.receiveBtn
    
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //右
        make.right.equalTo(self.mas_right).offset(0);
        //下
        make.bottom.equalTo(self.mas_bottom).offset(0);
        
    }];
}

-(void)reloadDataFromArray:(NSArray *)array AndDanhao:(NSString *)string
{
    view=[[MNWheelView alloc]initWithFrame:CGRectMake(0, 50*MCscale, self.width, 180*MCscale)];
    view.backgroundColor= [UIColor whiteColor];
    view.click=^(int i)
    {
        FuliModel *model = array[i];
        fulishopid = model.shopid;
    };
    
    view.images = [NSArray arrayWithArray:array];
    [self addSubview:view];
    
    danhaoStr  = string;
}

//按钮点击事件
-(void)receiveBtnClick:(UIButton *)button
{
    NSMutableDictionary *pram;
    if (button == self.abandonBtn) {
        pram = [NSMutableDictionary dictionaryWithDictionary:@{@"fulishopid":@0,@"dindan.danhao":danhaoStr}];
        
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        
        [HTTPTool getWithUrl:@"manageFuliShop.action" params:pram success:^(id json) {
            [Hud hide:YES];
            MyLog(@"---%@",json);
            
            if ([json valueForKey:@"message"] == 0) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"无可领取福利商品";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else
            {
                if ([self.receiveBenefitsdelegate respondsToSelector:@selector(reloadDataWithFuliName)]) {
                    [self.receiveBenefitsdelegate reloadDataWithFuliName];
                }
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    else
    {
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        pram = [NSMutableDictionary dictionaryWithDictionary:@{@"fulishopid":fulishopid,@"dindan.danhao":danhaoStr}];
        [HTTPTool getWithUrl:@"manageFuliShop.action" params:pram success:^(id json) {
            [Hud hide:YES];
            MyLog(@"---%@",json);
            
            if ([json valueForKey:@"message"] == 0) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"无可领取福利商品";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else
            {
                if ([self.receiveBenefitsdelegate respondsToSelector:@selector(reloadDataWithFuliName)]) {
                    [self.receiveBenefitsdelegate reloadDataWithFuliName];
                }
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];

    }
   }

- (void)myTask {
    sleep(1.5);
}
@end
