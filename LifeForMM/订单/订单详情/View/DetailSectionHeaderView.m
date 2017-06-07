//
//  DetailSectionHeaderView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "DetailSectionHeaderView.h"
#import "Header.h"
@implementation DetailSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIWithString:str];
    }
    return self;
}
-(void)createUIWithString:(NSString *)dinapuname
{
    UIImageView *shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(45*MCscale, 5*MCscale, 24*MCscale, 24*MCscale)];
    shopImage.image = [UIImage imageNamed:@"店铺图标"];
    [self addSubview:shopImage];
    CGSize size = [dinapuname boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    //店名
    UILabel *shopTitle = [[UILabel alloc]initWithFrame:CGRectMake(shopImage.right+5, 5*MCscale, size.width, 25*MCscale)];
    shopTitle.text = dinapuname;
    shopTitle.textAlignment = NSTextAlignmentCenter;
    shopTitle.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
    shopTitle.textColor = textColors;
    [self addSubview:shopTitle];
    //方向箭头 点击进入店铺
    UIImageView *locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-30*MCscale, 10*MCscale, 15*MCscale, 15*MCscale)];
    locationImage.image = [UIImage imageNamed:@"下拉键"];
    locationImage.backgroundColor = [UIColor clearColor];
    [self addSubview:locationImage];
    locationImage.userInteractionEnabled = YES;
    //进入店铺
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goShop)];
    [self addGestureRecognizer:tap];
}

-(void)goShop
{
    if ([self.headerDelegate respondsToSelector:@selector(gotoDianpuFirst)]) {
        [self.headerDelegate gotoDianpuFirst];
    }
}
@end
