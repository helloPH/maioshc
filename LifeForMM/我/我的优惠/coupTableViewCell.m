//
//  coupTableViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "coupTableViewCell.h"
#import "Header.h"
@implementation coupTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    _validity =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 140*MCscale, 20*MCscale)];
    _validity.textAlignment = NSTextAlignmentLeft;
    _validity.textColor = txtColors(25, 182, 133, 1);
    _validity.font  = [UIFont systemFontOfSize:MLwordFont_4];
    [self.contentView addSubview:_validity];
    
    UILabel *yxqz = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-170, 10*MCscale, 68*MCscale, 20*MCscale)];
    yxqz.textColor = textBlackColor;
    yxqz.text = @"有效期至:";
    yxqz.textAlignment = NSTextAlignmentLeft;
    yxqz.backgroundColor = [UIColor clearColor];
    yxqz.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:yxqz];
    
    _dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(yxqz.right, 10*MCscale, 90*MCscale, 20*MCscale)];
    _dataLabel.backgroundColor = [UIColor clearColor];
    _dataLabel.textColor = textBlackColor;
    _dataLabel.textAlignment = NSTextAlignmentLeft;
    _dataLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 40*MCscale, kDeviceWidth-20, 1)];
    line2.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line2];
    
    _titImage = [[UIImageView alloc]initWithFrame:CGRectMake(34, 45*MCscale, 78*MCscale, 78*MCscale)];
    _titImage.backgroundColor = [UIColor clearColor];
    
    _limitLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 23*MCscale, 37*MCscale, 32*MCscale)];
    _limitLabel.textColor = txtColors(129, 89, 10, 0.9);
    _limitLabel.backgroundColor = [UIColor clearColor];
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    _limitLabel.font = [UIFont systemFontOfSize:34];
    [_titImage addSubview:_limitLabel];
    
    UILabel *usPlace = [[UILabel alloc]initWithFrame:CGRectMake(_titImage.right+30, 55*MCscale, 35*MCscale, 20*MCscale)];
    usPlace.textColor = textBlackColor;
    usPlace.text = @"类型:";
    usPlace.textAlignment = NSTextAlignmentLeft;
    usPlace.backgroundColor = [UIColor clearColor];
    usPlace.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:usPlace];
    
    _placelLbel = [[UILabel alloc]initWithFrame:CGRectMake(usPlace.right, 55*MCscale, 100*MCscale, 20*MCscale)];
    _placelLbel.textAlignment = NSTextAlignmentLeft;
    _placelLbel.textColor = textBlackColor;
    _placelLbel.font = [UIFont systemFontOfSize:MLwordFont_7];
    _placelLbel.backgroundColor = [UIColor clearColor];
    
    UILabel *usPhone = [[UILabel alloc]initWithFrame:CGRectMake(_titImage.right+30, _placelLbel.bottom, 35*MCscale, 20*MCscale)];
    usPhone.textColor = textBlackColor;
    usPhone.text = @"适用:";
    usPhone.textAlignment = NSTextAlignmentLeft;
    usPhone.backgroundColor = [UIColor clearColor];
    usPhone.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:usPhone];
    
    _telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(usPhone.right, _placelLbel.bottom, 100*MCscale, 20*MCscale)];
    _telephoneLabel.textColor = textBlackColor;
    _telephoneLabel.textAlignment = NSTextAlignmentLeft;
    _telephoneLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    _telephoneLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *xianz = [[UILabel alloc]initWithFrame:CGRectMake(_titImage.right+30, _telephoneLabel.bottom, 180*MCscale, 35*MCscale)];
    xianz.textColor = textBlackColor;
    xianz.numberOfLines = 0;
    xianz.text = @"限制:不限购物金额和支付方式;可与活动同事使用";
    xianz.textAlignment = NSTextAlignmentLeft;
    xianz.font = [UIFont systemFontOfSize:MLwordFont_7];
    xianz.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:xianz];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 140*MCscale, kDeviceWidth, 1)];
    line3.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line3];
    [self.contentView addSubview:_dataLabel];
    [self.contentView addSubview:_titImage];
    [self.contentView addSubview:_placelLbel];
    [self.contentView addSubview:_telephoneLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _validity.text = [NSString stringWithFormat:@"还有%@天过期",_model.day];
    _dataLabel.text = _model.youxiaoqi;
    _titImage.image = [UIImage imageNamed:@"我的优惠券"];
    _limitLabel.text = [NSString stringWithFormat:@"%@",_model.money];
    _placelLbel.text = _model.type;
    _telephoneLabel.text = _model.shiyongyu;
}
@end
