//
//  orderViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderViewCell.h"
#import "Header.h"

@implementation orderViewCell
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
    //创建时间
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 6*MCscale, kDeviceWidth/4.0, 30*MCscale)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //相关提示
    _showLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _showLabel.backgroundColor = [UIColor clearColor];
    _showLabel.font = [UIFont systemFontOfSize:MLwordFont_8];
    _showLabel.textAlignment = NSTextAlignmentLeft;
    _showLabel.textColor = txtColors(109, 109, 109, 0.5);
    //订单评价
    _gotoeEvaluate = [UIButton buttonWithType:UIButtonTypeCustom];
    _gotoeEvaluate.frame = CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale);
    [_gotoeEvaluate setImage:[UIImage imageNamed:@"订单评价"] forState:UIControlStateNormal];
    _gotoeEvaluate.alpha =0;
    //支付
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale);
    [_payBtn setImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
    _payBtn.alpha =0;
    //取消订单
    _cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelOrderBtn.frame = CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale);
    [_cancelOrderBtn setImage:[UIImage imageNamed:@"取消订单"] forState:UIControlStateNormal];
    _cancelOrderBtn.alpha =0;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 40*MCscale, kDeviceWidth-30*MCscale, 0.5)];
    line1.backgroundColor = lineColor;
    [self.contentView addSubview:line1];
    //店铺logo
    _userheadImage = [[UIImageView alloc]initWithFrame:CGRectMake(25*MCscale, 50*MCscale, 60*MCscale, 60*MCscale)];
    _userheadImage.backgroundColor = [UIColor clearColor];
    UILabel *orderNumTitle = [[UILabel alloc]initWithFrame:CGRectMake(_userheadImage.right+10, 45*MCscale, 30, 20*MCscale)];
    orderNumTitle.text = @"单号:";
    orderNumTitle.textAlignment = NSTextAlignmentLeft;
    orderNumTitle.textColor = [UIColor blackColor];
    orderNumTitle.font = [UIFont systemFontOfSize:MLwordFont_8];
    orderNumTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:orderNumTitle];
    //订单号
    _orderNum = [[UILabel alloc]initWithFrame:CGRectMake(orderNumTitle.right+5, 45*MCscale, 125*MCscale, 20*MCscale)];
    _orderNum.textAlignment = NSTextAlignmentLeft;
    _orderNum.textColor = [UIColor blackColor];
    _orderNum.font = [UIFont systemFontOfSize:MLwordFont_8];
    _orderNum.backgroundColor = [UIColor clearColor];
    //已确认送达
    _delivery = [[UILabel alloc]initWithFrame:CGRectMake(_orderNum.right+5, 45*MCscale, 72, 18*MCscale)];
    _delivery.backgroundColor =txtColors(212, 213, 214, 1);
    _delivery.textColor = txtColors(162, 163, 164, 1);
    _delivery.font = [UIFont boldSystemFontOfSize:MLwordFont_8];
    _delivery.textAlignment = NSTextAlignmentCenter;
    _delivery.layer.cornerRadius = 9.0;
    _delivery.layer.masksToBounds = YES;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderNumTitle.left, orderNumTitle.bottom, 30, 20*MCscale)];
    numLabel.text = @"数量:";
    numLabel.textColor = textColors;
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_8];
    [self.contentView addSubview:numLabel];
    //数量
    _goodNum = [[UILabel alloc]initWithFrame:CGRectMake(numLabel.right+5, numLabel.top, 30, 20*MCscale)];
    _goodNum.textAlignment = NSTextAlignmentLeft;
    _goodNum.textColor = textColors;
    _goodNum.backgroundColor = [UIColor clearColor];
    _goodNum.font = [UIFont systemFontOfSize:MLwordFont_8];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goodNum.right, numLabel.top, 30*MCscale, 20*MCscale)];
    moneyLabel.textColor = textColors;
    moneyLabel.text = @"金额";
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_8];
    moneyLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:moneyLabel];
    //金额
    _money = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+5, numLabel.top, 100*MCscale, 20*MCscale)];
    _money.textColor = textColors;
    _money.backgroundColor = [UIColor clearColor];
    _money.textAlignment = NSTextAlignmentLeft;
    _money.font = [UIFont systemFontOfSize:MLwordFont_8];
    
    _payAgnNum = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-100*MCscale, numLabel.top, 80*MCscale, 20*MCscale)];
    _payAgnNum.textColor = txtColors(236, 27, 60, 0.9);
    _payAgnNum.backgroundColor = [UIColor clearColor];
    _payAgnNum.textAlignment = NSTextAlignmentRight;
    _payAgnNum.font = [UIFont systemFontOfSize:MLwordFont_10];
    //订单提交img
    _submitImage = [[UIImageView alloc]initWithFrame:CGRectMake(numLabel.left+5, numLabel.bottom, 26*MCscale, 26*MCscale)];
    _submitImage.backgroundColor = [UIColor clearColor];
    
    UILabel *orederSubmit = [[UILabel alloc]initWithFrame:CGRectMake(numLabel.left-7, _submitImage.bottom+2, _submitImage.width+25, 15*MCscale)];
    orederSubmit.text = @"订单提交";
    orederSubmit.textAlignment = NSTextAlignmentLeft;
    orederSubmit.textColor = textColors;
    orederSubmit.font = [UIFont systemFontOfSize:MLwordFont_9];
    orederSubmit.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:orederSubmit];
    _submitTime = [[UILabel alloc]initWithFrame:CGRectMake(_submitImage.right+3, _submitImage.top+6, 32*MCscale, 14*MCscale)];
    _submitTime.backgroundColor = [UIColor clearColor];
    _submitTime.textColor = textColors;
    _submitTime.textAlignment = NSTextAlignmentCenter;
    _submitTime.font = [UIFont systemFontOfSize:MLwordFont_13];
    _submitTime.alpha = 0;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_submitTime.left, _submitTime.bottom, _submitTime.width, 1)];
    line2.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line2];
    //处理中img
    _handleingImage = [[UIImageView alloc]initWithFrame:CGRectMake(_submitTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale)];
    _handleingImage.backgroundColor = [UIColor clearColor];
    
    UILabel *handingLabel = [[UILabel alloc]initWithFrame:CGRectMake(_handleingImage.left-10, _handleingImage.bottom+2, _handleingImage.width+20*MCscale, 15*MCscale)];
    handingLabel.text = @"处理中";
    handingLabel.textColor = textColors;
    handingLabel.textAlignment = NSTextAlignmentCenter;
    handingLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    handingLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:handingLabel];
    _sendTime = [[UILabel alloc]initWithFrame:CGRectMake(_handleingImage.right+3, _handleingImage.top+6, 32*MCscale, 14*MCscale)];
    _sendTime.backgroundColor = [UIColor clearColor];
    _sendTime.textAlignment = NSTextAlignmentCenter;
    _sendTime.alpha = 0;
    _sendTime.textColor = textColors;
    _sendTime.font = [UIFont systemFontOfSize:MLwordFont_13];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(_sendTime.left, _sendTime.bottom, _sendTime.width, 1)];
    line3.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line3];
    //配送中img
    _sendingImage  = [[UIImageView alloc]initWithFrame:CGRectMake(_sendTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale)];
    _sendingImage.backgroundColor = [UIColor clearColor];
    
    UILabel *sendingLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sendingImage.left-10, _sendingImage.bottom+2, _sendingImage.width+20*MCscale, 15*MCscale)];
    sendingLabel.text = @"配送中";
    sendingLabel.textAlignment = NSTextAlignmentCenter;
    sendingLabel.textColor = textColors;
    sendingLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    sendingLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sendingLabel];
    _receiveTime = [[UILabel alloc]initWithFrame:CGRectMake(_sendingImage.right+3, _sendingImage.top+6, 32*MCscale, 14*MCscale)];
    _receiveTime.alpha = 0;
    _receiveTime.backgroundColor = [UIColor clearColor];
    _receiveTime.textAlignment = NSTextAlignmentCenter;
    _receiveTime.font = [UIFont systemFontOfSize:MLwordFont_13];
    _receiveTime.textColor = textColors;
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(_receiveTime.left, _receiveTime.bottom+2, _receiveTime.width, 1)];
    line4.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line4];
    //送达img
    _receiveImage = [[UIImageView alloc]initWithFrame:CGRectMake(_receiveTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale)];
    _receiveImage.backgroundColor = [UIColor clearColor];
    
    UILabel *receiveLabel =[[UILabel alloc]initWithFrame:CGRectMake(_receiveImage.left-10, _receiveImage.bottom+2, _receiveImage.width+20*MCscale, 15*MCscale)];
    receiveLabel.text = @"已收货";
    receiveLabel.textAlignment = NSTextAlignmentCenter;
    receiveLabel.textColor = textColors;
    receiveLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    receiveLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:receiveLabel];
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(15*MCscale, _userheadImage.bottom+24*MCscale, kDeviceWidth-30, 0.5)];
    line5.backgroundColor = lineColor;
    line5.tag = 20011;
    line5.alpha = 0;
    [self.contentView addSubview:line5];
    
    _guanjia = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, line5.bottom+5, 40*MCscale, 30*MCscale)];
    _guanjia.text = @"管家:";
    _guanjia.backgroundColor = [UIColor clearColor];
    _guanjia.textAlignment = NSTextAlignmentLeft;
    _guanjia.textColor = textColors;
    _guanjia.font = [UIFont systemFontOfSize:MLwordFont_7];
    _guanjia.alpha = 0;
    
    _housekeeper = [[UILabel alloc]initWithFrame:CGRectMake(_guanjia.right+5, _guanjia.top, 80*MCscale, 30*MCscale)];
    _housekeeper.backgroundColor = [UIColor clearColor];
    _housekeeper.textAlignment = NSTextAlignmentLeft;
    _housekeeper.textColor = textColors;
    _housekeeper.font = [UIFont systemFontOfSize:MLwordFont_7];
    
    _tel = [[UILabel alloc]initWithFrame:CGRectMake(_housekeeper.right+5, line5.bottom+5, 50*MCscale, 30*MCscale)];
    _tel.text = @"手机号:";
    _tel.textAlignment = NSTextAlignmentLeft;
    _tel.textColor = textColors;
    _tel.font = [UIFont systemFontOfSize:MLwordFont_7];
    _tel.alpha = 0;
    _tel.backgroundColor = [UIColor clearColor];
    
    _telNumber = [[UILabel alloc]initWithFrame:CGRectMake(_tel.right+5, line5.bottom+5, 100*MCscale, 30*MCscale)];
    _telNumber.backgroundColor = [UIColor clearColor];
    _telNumber.textAlignment = NSTextAlignmentLeft;
    _telNumber.textColor = textColors;
    _telNumber.font = [UIFont systemFontOfSize: MLwordFont_7];
    
    _telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _telBtn.frame = CGRectMake(kDeviceWidth-45*MCscale, line5.bottom+5, 25*MCscale, 28*MCscale);
    _telBtn.alpha = 0;
    [_telBtn setImage:[UIImage imageNamed:@"手机"] forState:UIControlStateNormal];
    [_telBtn addTarget:self action:@selector(callGjAction) forControlEvents:UIControlEventTouchUpInside];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0,142*MCscale, kDeviceWidth, 2)];
    _lineView.tag = 20022;
    _lineView.backgroundColor = lineColor;
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_showLabel];
    [self.contentView addSubview:_delivery];
    [self.contentView addSubview:_gotoeEvaluate];
    [self.contentView addSubview:_userheadImage];
    [self.contentView addSubview:_submitImage];
    [self.contentView addSubview:_handleingImage];
    [self.contentView addSubview:_sendingImage];
    [self.contentView addSubview:_receiveImage];
    [self.contentView addSubview:_showLabel];
    [self.contentView addSubview:_orderNum];
    [self.contentView addSubview:_money];
    [self.contentView addSubview:_payAgnNum];
    [self.contentView addSubview:_goodNum];
    [self.contentView addSubview:_submitTime];
    [self.contentView addSubview:_sendTime];
    [self.contentView addSubview:_receiveTime];
    [self.contentView addSubview:_cancelOrderBtn];
    [self.contentView addSubview:_payBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _timeLabel.text = _model.cretdate;
    _delivery.text = @"已确认送达";
    [_userheadImage sd_setImageWithURL:[NSURL URLWithString:_model.dianpulogo] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    
    NSString *needPay = [NSString stringWithFormat:@"%@",_model.chajia];
    if ([needPay isEqualToString:@"0"] || [needPay isEqualToString:@""]) {
        _payAgnNum.text = @"";
        _payAgnNum.alpha = 0;
    }
    else{
        _payAgnNum.text = [NSString stringWithFormat:@"还需支付%@元",needPay];
        _payAgnNum.alpha = 1;
    }
    NSMutableArray *tmAry = [[NSMutableArray alloc]initWithCapacity:3];
    NSString *ddzhuangt = _model.dindanzhuangtaidate;
    if (![ddzhuangt isEqual:[NSNull null]]){
        tmAry = [NSMutableArray arrayWithArray:[ddzhuangt componentsSeparatedByString:@","]];
    }
    NSString *payStyle = [NSString stringWithFormat:@"%@",_model.zhifuleixing];
    
    if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"6"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货"];
        _showLabel.text= @"感谢捧场,订单已完成";
        _gotoeEvaluate.alpha =1;
        _cancelOrderBtn.alpha = 0;
        _payBtn.alpha = 0;
        _delivery.backgroundColor = txtColors(236, 27, 60, 0.9);
        _delivery.textColor = [UIColor whiteColor];
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 1;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _receiveTime.text = tmAry[2];
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"4"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货"];
        _showLabel.text= @"期待下次会面,欢迎评价";
        _gotoeEvaluate.alpha =1;
        _payBtn.alpha = 0;
        _cancelOrderBtn.alpha = 0;
        _delivery.backgroundColor = txtColors(236, 27, 60, 0.9);
        _delivery.textColor = [UIColor whiteColor];
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 1;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _receiveTime.text = tmAry[2];
        
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"3"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"管家正在火速奔跑";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 0;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _gotoeEvaluate.alpha =0;
        _cancelOrderBtn.alpha = 0;
        if([payStyle isEqualToString:@"0"]){
            _payBtn.alpha = 0;
        }
        else{
            _payBtn.alpha =1;
            [_payBtn setImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
        }
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"2"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中-绿"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"已接订单,店家准备中";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 1;
        _sendTime.alpha = 0;
        _receiveTime.alpha = 0;
        _submitTime.text = tmAry[0];
        _gotoeEvaluate.alpha =0;
        _cancelOrderBtn.alpha = 0;
        if([payStyle isEqualToString:@"0"]){
            _payBtn.alpha = 0;
        }
        else{
            _payBtn.alpha =1;
            [_payBtn setImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
        }
    }
    else if([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"1"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中-绿"];
        _sendingImage.image = [UIImage imageNamed:@"配送中-绿"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"订单已提交,请耐心等待";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 0;
        _sendTime.alpha = 0;
        _receiveTime.alpha = 0;
        _gotoeEvaluate.alpha =0;
        _payBtn.alpha = 0;
        _cancelOrderBtn.alpha = 1;
        [_cancelOrderBtn setImage:[UIImage imageNamed:@"取消订单"] forState:UIControlStateNormal];
    }
    CGSize showSize =[_showLabel.text boundingRectWithSize:CGSizeMake(150, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] context:nil].size;
    _showLabel.frame = CGRectMake(_timeLabel.right, _timeLabel.top, showSize.width, 30*MCscale);
    _orderNum.text = _model.danhao;
    _goodNum.text = _model.shuliang;
    _money.text = [NSString stringWithFormat:@"¥%.2f",[_model.yingfujine floatValue]];
    if ([_model.guanjiantel integerValue]!=0) {
        _housekeeper.text = _model.guanjia;
        _telNumber.text = [NSString stringWithFormat:@"%@",_model.guanjiantel];
        _lineView.frame = CGRectMake(0, _guanjia.bottom+3,kDeviceWidth , 2);
        UIView *line = [self viewWithTag:20011];
        line.alpha = 1;
        [self.contentView addSubview:_telBtn];
        [self.contentView addSubview:_guanjia];
        [self.contentView addSubview:_tel];
        [self.contentView addSubview:_housekeeper];
        [self.contentView addSubview:_telNumber];
        _guanjia.alpha = 1;
        _tel.alpha = 1;
        _telBtn.alpha = 1;
    }
    else{
        UIView *line = [self viewWithTag:20011];
        line.alpha = 0;
        _housekeeper.text = @"";
        _telNumber.text = @"";
        _lineView.frame = CGRectMake(0,143*MCscale, kDeviceWidth, 2);
        _guanjia.alpha = 0;
        _tel.alpha = 0;
        _telBtn.alpha = 0;
    }
//    _gotoeEvaluate.alpha =1;
}
-(void)callGjAction
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_model.guanjiantel]];
    UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
    [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    [self addSubview:phoneWeb];
}
@end
