//
//  oldOrderViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "oldOrderViewCell.h"
#import "Header.h"
@implementation oldOrderViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    _orderGoodImag = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale ,12*MCscale, 56*MCscale, 56*MCscale)];
    _orderGoodImag.backgroundColor = [UIColor clearColor];
    
    UILabel *danHao = [[UILabel alloc]initWithFrame:CGRectMake(_orderGoodImag.right+20, 14*MCscale, 30, 20*MCscale)];
    danHao.text = @"单号:";
    danHao.textAlignment = NSTextAlignmentLeft;
    danHao.backgroundColor = [UIColor blackColor];
    danHao.font = [UIFont systemFontOfSize:MLwordFont_8];
    danHao.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:danHao];
    //单号
    _orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(danHao.right, danHao.top, 130*MCscale, 20*MCscale)];
    _orderNumber.textAlignment = NSTextAlignmentLeft;
    _orderNumber.textColor = [UIColor blackColor];
    _orderNumber.font = [UIFont systemFontOfSize:MLwordFont_8];
    _orderNumber.backgroundColor = [UIColor clearColor];
    //时间
    _orderTime = [[UILabel alloc]initWithFrame:CGRectMake(danHao.left, danHao.bottom, 160*MCscale, 20*MCscale)];
    _orderTime.textColor = textBlackColor;
    _orderTime.textAlignment = NSTextAlignmentLeft;
    _orderTime.font = [UIFont systemFontOfSize:MLwordFont_8];
    _orderTime.backgroundColor = [UIColor clearColor];
    //评价
    _pingjia = [[UILabel alloc]initWithFrame:CGRectMake(danHao.left, _orderTime.bottom, 35*MCscale, 20*MCscale)];
    _pingjia.textColor = textBlackColor;
    _pingjia.text = @"评价:";
    _pingjia.alpha = 0;
    _pingjia.textAlignment = NSTextAlignmentLeft;
    _pingjia.font = [UIFont systemFontOfSize:MLwordFont_8];
    _pingjia.backgroundColor = [UIColor clearColor];
    
    //物品评价
    _goodEl = [[UILabel alloc]initWithFrame:CGRectMake(_pingjia.right, _orderTime.bottom, 70*MCscale, 20*MCscale)];
    _goodEl.textColor = textBlackColor;
    _goodEl.alpha = 0;
    _goodEl.textAlignment = NSTextAlignmentLeft;
    _goodEl.font = [UIFont systemFontOfSize:MLwordFont_8];
    _goodEl.backgroundColor = [UIColor clearColor];
    
    
    //服务评价
    _ServiceEl = [[UILabel alloc]initWithFrame:CGRectMake(_goodEl.right, _orderTime.bottom, 70*MCscale, 20*MCscale)];
    _ServiceEl.textColor = textBlackColor;
    _ServiceEl.alpha = 0;
    _ServiceEl.textAlignment = NSTextAlignmentLeft;
    _ServiceEl.font = [UIFont systemFontOfSize:MLwordFont_8];
    _ServiceEl.backgroundColor = [UIColor clearColor];
    
    
    _orderState = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-110*MCscale, 30*MCscale, 60*MCscale, 20*MCscale)];
    _orderState.backgroundColor = txtColors(249, 54, 73, 1);
    _orderState.textColor = [UIColor whiteColor];
    _orderState.textAlignment = NSTextAlignmentCenter;
    _orderState.layer.cornerRadius = 3.0;
    _orderState.layer.masksToBounds = YES;
    _orderState.font = [UIFont systemFontOfSize:MLwordFont_7];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, 88*MCscale, kDeviceWidth-20*MCscale, 0.5)];
    bottomLine.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:bottomLine];
    [self.contentView addSubview:_orderGoodImag];
    [self.contentView addSubview:_orderNumber];
    [self.contentView addSubview:_orderTime];
    [self.contentView addSubview:_pingjia];
    [self.contentView addSubview:_goodEl];
    [self.contentView addSubview:_ServiceEl];
    [self.contentView addSubview:_orderState];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //店铺logo
    [_orderGoodImag sd_setImageWithURL:[NSURL URLWithString:_model.dianpulogo] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    //订单号
    _orderNumber.text =_model.danhao;
    
    //已收货 / 取消订单
//    if([_model.dindanzhuangtai integerValue]==0){
//        _orderState.text = @"已收货";
//    }
    if([_model.dindanzhuangtai integerValue]==5){
        _orderState.text = @"取消订单";
        NSString *tim = [NSString stringWithFormat:@"%@",_model.cretdate];
        if (![tim isEqualToString:@"0"]) {
            //创建时间
            _orderTime.text = _model.cretdate;
            _goodEl.alpha = 0;
            _ServiceEl.alpha = 0;
            _pingjia.alpha = 0;
        }
    }
    else if ([_model.dindanzhuangtai integerValue]==7){
        _orderState.text = @"未接超时";
        NSString *tim = [NSString stringWithFormat:@"%@",_model.cretdate];
        if (![tim isEqualToString:@"0"]) {
            //创建时间
            _orderTime.text = _model.cretdate;
            _goodEl.alpha = 0;
            _ServiceEl.alpha = 0;
            _pingjia.alpha = 0;
        }
    }
    else{
        _orderState.text = @"已收货";
        _pingjia.alpha = 1;
        NSString *tim = [NSString stringWithFormat:@"%@",_model.time];
        NSString *godel = [NSString stringWithFormat:@"%@",_model.pingfeng];
        NSString *serv = [NSString stringWithFormat:@"%@",_model.pingjianame];
        if (![tim isEqualToString:@"0"]) {
            _orderTime.text = [NSString stringWithFormat:@"用时: %@",tim];
        }
        if (![godel isEqualToString:@"0"]) {
            _goodEl.alpha = 1;
            _goodEl.text = [NSString stringWithFormat:@"物品 %@",godel];
        }
        else{
            _goodEl.alpha = 0;
        }
        if (![serv isEqualToString:@"0"]) {
            _ServiceEl.alpha = 1;
            _ServiceEl.text = [NSString stringWithFormat:@"服务 %@",serv];
        }
        else{
            _ServiceEl.alpha = 0;
        }
        if ([godel isEqualToString:@"0"] && [serv isEqualToString:@"0"]) {
            _pingjia.alpha = 0;
        }
    }
}
@end
