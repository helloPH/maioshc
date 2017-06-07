//
//  shopCollectionViewCell.m
//  LifeForMM
//
//  Created by HUI on 15/7/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "shopCollectionViewCell.h"
#import "Header.h"
@implementation shopCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), SCLimageHeigh)];
        _goodImage.contentMode = UIViewContentModeScaleAspectFit;
        _goodImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_goodImage];
        
        //提示label
        _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale, _goodImage.bottom - 20*MCscale, self.width - 40*MCscale, 20*MCscale)];
        _tishiLabel.alpha = 0.5;
//        _tishiLabel.backgroundColor = [UIColor grayColor];
        _tishiLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        _tishiLabel.textColor = [UIColor whiteColor];
        _tishiLabel.textAlignment = NSTextAlignmentCenter;
        [_goodImage addSubview:_tishiLabel];
        
        _shangbiao = [[UIImageView alloc]initWithFrame:CGRectMake(15*MCscale, 15*MCscale, 26*MCscale, 26*MCscale)];
        _shangbiao.contentMode = UIViewContentModeScaleAspectFit;
        _shangbiao.backgroundColor = [UIColor clearColor];
        [_goodImage addSubview:_shangbiao];
        
        _goodTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodImage.frame)+5*MCscale, CGRectGetWidth(self.frame), 20*MCscale)];
        _goodTitle.backgroundColor = [UIColor clearColor];
        _goodTitle.textAlignment = NSTextAlignmentCenter;
        _goodTitle.font = [UIFont systemFontOfSize:MLwordFont_5];
        _goodTitle.textColor = textBlackColor;
        [self addSubview:_goodTitle];
        _nowPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodTitle.frame)+10*MCscale, kDeviceWidth/5.0, 20*MCscale)];
        _nowPrice.textColor = txtColors(248, 53, 74, 1);
        _nowPrice.textAlignment = NSTextAlignmentRight;
        _nowPrice.font = [UIFont systemFontOfSize:MLwordFont_12];
        _nowPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:_nowPrice];
        
        _oldPrice = [[TGCenterLineLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nowPrice.frame), CGRectGetMaxY(_goodTitle.frame)+10, 70*MCscale, 20*MCscale)];
        _oldPrice.textColor = textColors;
        _oldPrice.alpha = 0;
        _oldPrice.textAlignment = NSTextAlignmentCenter;
        _oldPrice.font = [UIFont systemFontOfSize:MLwordFont_9];
        _oldPrice.backgroundColor = [UIColor clearColor];
        _oldPrice.center = CGPointMake(CGRectGetMaxX(_nowPrice.frame)+37*MCscale, CGRectGetMaxY(_goodTitle.frame)+20*MCscale);
        [self addSubview:_oldPrice];
        
        _goinShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
        _goinShopCar.frame = CGRectMake(CGRectGetMaxX(_nowPrice.frame)+SCLgoinCarSpace, CGRectGetMaxY(_goodTitle.frame), SCLgoinCarHeight +10, SCLgoinCarHeight);
        _goinShopCar.backgroundColor = [UIColor clearColor];
        
        [_goinShopCar setImage:[UIImage imageNamed:@"加入购物车"] forState:UIControlStateNormal];
        
        [_goinShopCar setImageEdgeInsets: UIEdgeInsetsMake(7,12,7,12)];

        [self addSubview:_goinShopCar];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _nowPrice.bottom+10*MCscale, kDeviceWidth/2.0+4, 1)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(self.width+4.5, _goodImage.top, 1, self.height-4)];
        line1.backgroundColor = lineColor;
        [self addSubview:line1];
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
    self.shangbiao.image = nil;
    
    self.tishiLabel.text = nil;
    
    self.tishiLabel.backgroundColor = nil;
    //更新位置
//    self.shangbiao.frame = self.contentView.bounds;
    
    self.goinShopCar.hidden = NO;
}
@end
