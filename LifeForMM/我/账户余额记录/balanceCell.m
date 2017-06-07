//
//  balanceCell.m
//  LifeForMM
//
//  Created by HUI on 15/12/21.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "balanceCell.h"
#import "Header.h"
@implementation balanceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    _titleLab =[[UILabel alloc]initWithFrame:CGRectZero];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.tag = 101;
    _titleLab.font = [UIFont systemFontOfSize:MLwordFont_4];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLab];
    
    _enabelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _enabelLabel.textAlignment= NSTextAlignmentLeft;
    _enabelLabel.tag = 102;
    _enabelLabel.textColor = txtColors(67, 205, 166, 1);
    _enabelLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    _enabelLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_enabelLabel];
    _dingdanhao = [[UILabel alloc]initWithFrame:CGRectZero];
    _dingdanhao.textAlignment= NSTextAlignmentLeft;
    _dingdanhao.tag = 105;
    _dingdanhao.alpha = 0;
    _dingdanhao.textColor = lineColor;
    _dingdanhao.font = [UIFont systemFontOfSize:MLwordFont_7];
    _dingdanhao.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_dingdanhao];

    _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _timeLabel.textColor = textColors;
    _timeLabel.tag = 103;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _spendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _spendLabel.tag = 104;
    _spendLabel.textColor = txtColors(249, 57, 73, 1);
    _spendLabel.textAlignment = NSTextAlignmentRight;
    _spendLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    _spendLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_spendLabel];
    
    _line = [[UIView alloc]initWithFrame:CGRectZero];
    _line.backgroundColor = lineColor;
    [self.contentView addSubview:_line];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //收支
    _titleLab.frame = CGRectMake(20*MCscale, 15*MCscale, 80*MCscale, 20*MCscale);
    _titleLab.text = _bModel.title;
    //可用余额
    _enabelLabel.frame = CGRectMake(20*MCscale, _titleLab.bottom+2, 100*MCscale, 20*MCscale);
    NSString *yeStr = [NSString stringWithFormat:@"%@",_bModel.money];
    _enabelLabel.text = [NSString stringWithFormat:@"余额:%.2f",[yeStr floatValue]];
    //订单号
    _dingdanhao.frame = CGRectMake(_enabelLabel.right+10, _titleLab.bottom+2, 200*MCscale, 20*MCscale);
    if (![_bModel.danhao isEqual:[NSNull null]]) {
        NSString *dh = [NSString stringWithFormat:@"%@",_bModel.danhao];
        if (![dh isEqualToString:@"0"]) {
            _dingdanhao.text = [NSString stringWithFormat:@"%@",_bModel.danhao];
            _dingdanhao.alpha = 1;
        }
        else
            _dingdanhao.alpha = 0;
    }
    else
        _dingdanhao.text = @"";
    //收支时间
    _timeLabel.frame = CGRectMake(kDeviceWidth-140*MCscale, 13*MCscale, 130*MCscale, 20*MCscale);
    _timeLabel.text = [NSString stringWithFormat:@"%@",_bModel.adddate];
    //收支金额
    _spendLabel.frame = CGRectMake(kDeviceWidth - 110*MCscale, _timeLabel.bottom, 90*MCscale, 20*MCscale);
    NSString *tpe = @"+";
    if ([_bModel.cost integerValue]<0) {
        tpe = @"";
    }
    NSString *cutMoney = [NSString stringWithFormat:@"%@",_bModel.cost];
    _spendLabel.text = [NSString stringWithFormat:@"%@%.2f",tpe,[cutMoney floatValue]];
    
    _line .frame = CGRectMake(10*MCscale, self.height- 0.5 , kDeviceWidth - 20*MCscale, 0.5);

}
@end
