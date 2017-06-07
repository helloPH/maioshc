//
//  OrderPromptView.m
//  LifeForMM
//
//  Created by MIAO on 16/5/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OrderPromptView.h"
#import "Header.h"
@implementation OrderPromptView

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
    }
    return self;
}

-(void)initSubViews
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //    label.tag = 101;
    self.titleLabel.text = @"购物车有不符合活动条件的商品";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectZero];
    line1.tag = 103;
    line1.backgroundColor= lineColor;
    [self addSubview:line1];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.backgroundColor = [UIColor whiteColor];
    [self.sureBtn setTitleColor:redTextColor forState:UIControlStateNormal];
    //    self.sureBtn.layer.cornerRadius = 3.0;
    //    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.sureBtn setTitle:@"放弃稍后再说" forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(orderPrompt:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureBtn];
    
    self.line2 = [[UIView alloc]initWithFrame:CGRectZero];
    self.line2.tag = 106;
    self.line2.backgroundColor = lineColor;
    [self addSubview:self.line2];
    
    self.cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancalBtn.backgroundColor = [UIColor whiteColor];
    [self.cancalBtn setTitleColor:redTextColor forState:UIControlStateNormal];
    //    self.sureBtn.layer.cornerRadius = 3.0;
    //    self.sureBtn.layer.masksToBounds = YES;
    self.cancalBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.cancalBtn setTitle:@"只下单符合条件的商品" forState:UIControlStateNormal];
    [self.cancalBtn addTarget:self action:@selector(orderPrompt:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancalBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.width*MCscale, 30*MCscale);
    self.titleLabel.center = CGPointMake(self.width/2.0, 40*MCscale);
    
    UIView *line1 = [self viewWithTag:103];
    line1.frame = CGRectMake(0,  self.titleLabel.bottom+30*MCscale, self.width, 1);
    
    self.sureBtn.frame = CGRectMake(0, 0, self.width*MCscale, 50*MCscale);
    self.sureBtn.center = CGPointMake(self.width/2.0, line1.bottom+30*MCscale);
    
    
//    UIView *line2 = [self viewWithTag:106];
    self.line2.frame = CGRectMake(30*MCscale, self.sureBtn.bottom+10*MCscale, self.width-60, 1);
    
    self.cancalBtn.frame = CGRectMake(0, 0, self.width*MCscale, 50*MCscale);
    self.cancalBtn.center = CGPointMake(self.width/2.0, self.line2.bottom+30*MCscale);
    
}

-(void)orderPrompt:(UIButton *)button
{
    if ([self.orderPromptViewDelegate respondsToSelector:@selector(OrderPromptView:AndButton:)]) {
        [self.orderPromptViewDelegate OrderPromptView:self AndButton:button];
    }
}
@end
