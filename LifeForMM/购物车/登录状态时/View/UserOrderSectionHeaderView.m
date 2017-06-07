//
//  UserOrderSectionHeaderView.m
//  LifeForMM
//
//  Created by MIAO on 16/7/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "UserOrderSectionHeaderView.h"
#import "Header.h"
@implementation UserOrderSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str AndStr:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIWithString:str AndYouhui:string];
    }
    return self;
}
-(void)createUIWithString:(NSString *)shopName AndYouhui:(NSString *)youh
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 4)];
    line.backgroundColor = txtColors(231, 232, 234, 0.8);
    [self addSubview:line];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, 160*MCscale, 20*MCscale)];
    title.text = shopName;
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = textColors;
    title.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self addSubview:title];
    
    UILabel *youhui = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-142*MCscale, 10*MCscale, 40*MCscale, 20*MCscale)];
    youhui.textColor = textColors;
    youhui.text = @"优惠";
    youhui.textAlignment = NSTextAlignmentRight;
    youhui.font = [UIFont boldSystemFontOfSize:MLwordFont_4];
    [self addSubview:youhui];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(youhui.right+2, 15*MCscale, 15*MCscale, 15*MCscale)];
    image.image = [UIImage imageNamed:@"减1"];
    image.backgroundColor = [UIColor clearColor];
    [self addSubview:image];
    
    UILabel *cutMoney = [[UILabel alloc]initWithFrame:CGRectMake(image.right, 10, 60*MCscale, 20*MCscale)];
    cutMoney.textAlignment= NSTextAlignmentRight;
    cutMoney.text = [NSString stringWithFormat:@"-¥%@",youh];
    cutMoney.font = [UIFont systemFontOfSize:MLwordFont_7];
    cutMoney.textColor = textColors;
    cutMoney.backgroundColor = [UIColor clearColor];
    [self addSubview:cutMoney];
}

@end
