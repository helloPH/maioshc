//
//  startView.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/24.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "startView.h"
#import "Header.h"
@implementation startView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    //灰星星
    _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170*MCscale, 30*MCscale)];
    _grayView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<5; i++) {
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(35*i*MCscale, 0, 30*MCscale, 30*MCscale)];
        star.backgroundColor = [UIColor clearColor];
        star.image = [UIImage imageNamed:@"未评价"];
        [self addSubview:star];
    }
    [self addSubview:_grayView];
    //红星星
    _redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170*MCscale, 30*MCscale)];
    _redView.clipsToBounds = YES;
    [_redView sizeToFit];
    _redView.backgroundColor = [UIColor clearColor];
    for (int j = 0; j<5; j++) {
        UIImageView *redStart = [[UIImageView alloc]initWithFrame:CGRectMake(35*j*MCscale, 0, 30*MCscale, 30*MCscale)];
        redStart.backgroundColor = [UIColor clearColor];
        redStart.image = [UIImage imageNamed:@"评价"];
        [_redView addSubview:redStart];
    }
    [self addSubview:_redView];
}
@end
