//
//  DetailTableHeadView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "DetailTableHeadView.h"
#import "Header.h"
@implementation DetailTableHeadView

- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIWithString:str];
    }
    return self;
}
-(void)createUIWithString:(NSString *)zhuangtai
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, 20*MCscale, 30*MCscale, 30*MCscale)];
    image.backgroundColor = [UIColor clearColor];
    [self addSubview:image];
    
    UILabel *receive = [[UILabel alloc]initWithFrame:CGRectMake(image.right,20*MCscale, 120*MCscale, 30*MCscale)];
    receive.backgroundColor = [UIColor clearColor];
    receive.textColor = [UIColor blackColor];
    receive.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    receive.textAlignment = NSTextAlignmentCenter;
    [self addSubview:receive];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(image.left, image.bottom+10*MCscale, 200*MCscale, 20*MCscale)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_8];
    [self addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottom, kDeviceWidth, 1)];
    line.backgroundColor = txtColors(193, 194, 196, 1);
    [self addSubview:line];
    if ([zhuangtai isEqualToString:@"6"]) {
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"已收货";
        label.text = @"感谢捧场,订单已完成";
    }
    else if ([zhuangtai isEqualToString:@"1"]){
        receive.text = @"订单已提交";
        image.image = [UIImage imageNamed:@"订单提交-绿"];
        label.text = @"订单已提交,请耐心等待";
    }
    else if ([zhuangtai isEqualToString:@"2"]){
        image.image = [UIImage imageNamed:@"处理中-绿"];
        receive.text = @"处理中";
        label.text = @"已接订单,店家准备中";
    }
    else if ([zhuangtai isEqualToString:@"3"]){
        image.image = [UIImage imageNamed:@"配送中-绿"];
        receive.text = @"配送中";
        label.text = @"管家正在火速奔跑中";
    }
    else if ([zhuangtai isEqualToString:@"4"]){
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"已送达";
        label.text = @"期待下次会面,欢迎评价";
    }
    else if([zhuangtai isEqualToString:@"7"]){
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"未接超时";
        label.text = @"给您带来的不便,敬请谅解";
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"订单已取消";
        label.text = @"给您带来的不便,敬请谅解";
    }
}


@end
