//
//  OrderExceptionPrompt.m
//  LifeForMM
//
//  Created by MIAO on 16/7/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OrderExceptionPrompt.h"
#import "Header.h"
@implementation OrderExceptionPrompt
{
    UILabel *titleLabel;
    UIButton *sureBtn;
    UIView *lineTop;
    UIView *lineBottom;
    UITextView *contentLabel;

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
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //    label.tag = 101;
    titleLabel.text = @"提示信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self addSubview:titleLabel];
    
    lineTop = [[UIView alloc]initWithFrame:CGRectZero];
    lineTop.backgroundColor= lineColor;
    [self addSubview:lineTop];
    
    contentLabel = [[UITextView alloc]initWithFrame:CGRectZero];
    //    label.tag = 101;
//    connentLabel.text = @"提示信息";
//    contentLabel.numberOfLines = 0;
     contentLabel.editable = NO;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = textBlackColor;
    contentLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
//    contentLabel.backgroundColor = redTextColor;
    [self addSubview:contentLabel];
    
    lineBottom = [[UIView alloc]initWithFrame:CGRectZero];
    lineBottom.backgroundColor= lineColor;
    [self addSubview:lineBottom];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [sureBtn setTitleColor:txtColors(255, 79, 90, 1) forState:UIControlStateNormal];
    //    self.sureBtn.layer.cornerRadius = 3.0;
    //    self.sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(orderPrompt:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}

-(void)orderPrompt:(UIButton *)button
{
    if ([self.orderDelegate respondsToSelector:@selector(titleViewHidden)]) {
        [self.orderDelegate titleViewHidden];
    }
}

-(void)getOrderPromptContentWithString:(NSString *)string
{
    contentLabel.text = string;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    titleLabel.frame = CGRectMake(8*MCscale,15*MCscale, self.width - 16*MCscale, 20*MCscale);
    lineTop.frame = CGRectMake(0, 50*MCscale, self.width, 1);
    contentLabel.frame = CGRectMake(10*MCscale, lineTop.bottom , self.width-20*MCscale, self.height - 20*MCscale - 60*MCscale);
    lineBottom.frame = CGRectMake(0, self.height - 50*MCscale, self.width, 1);
    sureBtn.frame = CGRectMake(8, self.height-46*MCscale, self.width-16, 40*MCscale);
}


@end
