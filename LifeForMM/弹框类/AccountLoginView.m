//
//  AccountLoginView.m
//  LifeForMM
//
//  Created by MIAO on 16/8/3.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "AccountLoginView.h"
#import "Header.h"
@implementation AccountLoginView
{
    UILabel *title;
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
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 20*MCscale, 80*MCscale, 80*MCscale)];
    image.backgroundColor = [UIColor clearColor];
    image.image = [UIImage imageNamed:@"app_icon"];
    [self addSubview:image];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(image.right + 15*MCscale, 20*MCscale, self.width - 20*MCscale -80*MCscale -20 *MCscale-20*MCscale, 80*MCscale)];
    title.textColor = textColors;
    title.tag = 10110;
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self addSubview:title];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, title.bottom +  20*MCscale, self.width, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(self.width/2.0, line1.bottom, 1, self.height-line1.bottom)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(1+self.width/2.0*i, line1.bottom, self.width/2.0-2, 60*MCscale);
        btn.backgroundColor = [UIColor clearColor];
        if (i==0) {
            [btn setTitle:@"知道了" forState:UIControlStateNormal];
            [btn setTitleColor:textColors forState:UIControlStateNormal];
        }
        else{
            [btn setTitle:@"重新登录" forState:UIControlStateNormal];
            [btn setTitleColor:redTextColor forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
        btn.tag = i+200;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)loadLabelTextContentWithLoginTime:(NSString *)loginTime
{
    title.text = loginTime;
}
//分享红包
-(void)buttonAction:(UIButton *)btn
{
    NSInteger index = btn.tag - 200;
    if ([self.accountDelegate respondsToSelector:@selector(AccountLoginViewButtonClickWithIndex:)]) {
        [self.accountDelegate AccountLoginViewButtonClickWithIndex:index];
    }
}


@end
