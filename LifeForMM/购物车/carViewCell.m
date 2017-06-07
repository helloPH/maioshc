//
//  carViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "carViewCell.h"
#import "Header.h"
@implementation carViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isFirst = 0;
        [self SubView];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walkVCClick:) name:@"buttonLoseResponse" object:nil];
    }
    return self;
}
-(void)SubView
{
    _selectImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _selectImageView.backgroundColor = [UIColor clearColor];
    _selectImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_selectImageView addGestureRecognizer:tap];
    
    _goodImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _goodImageView.backgroundColor = [UIColor clearColor];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _goodTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodTitle.textColor = [UIColor blackColor];
    _goodTitle.backgroundColor = [UIColor clearColor];
    _goodTitle.textAlignment = NSTextAlignmentLeft;
    _goodTitle.font = [UIFont systemFontOfSize:MLwordFont_8];
    
    _goodColor = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodColor.backgroundColor = [UIColor clearColor];
    _goodColor.textColor = textBlackColor;
    _goodColor.textAlignment = NSTextAlignmentLeft;
    _goodColor.font = [UIFont systemFontOfSize:MLwordFont_9];
    
    _goodStyle = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodStyle.backgroundColor = [UIColor clearColor];
    _goodStyle.textColor = textBlackColor;
    _goodStyle.textAlignment = NSTextAlignmentLeft;
    _goodStyle.font = [UIFont systemFontOfSize:MLwordFont_9];
    
    _moneyNum = [[UILabel alloc]initWithFrame:CGRectZero];
    _moneyNum.backgroundColor = [UIColor clearColor];
    _moneyNum.textAlignment = NSTextAlignmentLeft;
    _moneyNum.textColor = txtColors(252, 53, 77, 1);
    _moneyNum.font = [UIFont systemFontOfSize:MLwordFont_4];
    
    _changeNumImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _changeNumImageView.backgroundColor = [UIColor clearColor];
    _goodNum = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodNum.backgroundColor = [UIColor clearColor];
    _goodNum.tintColor = [UIColor blackColor];
    _goodNum.textAlignment = NSTextAlignmentCenter;
    _goodNum.font = [UIFont systemFontOfSize:MLwordFont_4];
    
    _subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subtractBtn.tag = 102;
    
    [_subtractBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
    _subtractBtn.backgroundColor = [UIColor clearColor];
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.tag = 101;
    
    [_addBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100*SCscale, kDeviceWidth, 1)];
    line.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line];
    [self.contentView addSubview:_selectImageView];
    [self.contentView addSubview:_goodImageView];
    [self.contentView addSubview:_goodTitle];
    [self.contentView addSubview:_moneyNum];
    [self.contentView addSubview:_changeNumImageView];
    [self.contentView addSubview:_goodNum];
    [self.contentView addSubview:_subtractBtn];
    [self.contentView addSubview:_addBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _goodCount = [_carModel.shuliang integerValue];
    //选中图片
    _selectImageView.frame = CGRectMake(20*MCscale, 36*SCscale, SCselectImgWidth, SCselectImgWidth);
    
    NSString *selectState = [NSString stringWithFormat:@"%@",_carModel.xuangzhongzhuangtai];
    if (_selectBool) {
        if ([selectState isEqualToString:@"0"]) {
            _selectImageView.image = [UIImage imageNamed:@"选择"];
        }
        else
            _selectImageView.image = [UIImage imageNamed:@"选中"];
    }
    else
        _selectImageView.image = [UIImage imageNamed:@"选择"];
    
    //商品图片
    _goodImageView.frame = CGRectMake(_selectImageView.right+10, 5,SCgoodImgWidth, SCgoodImgWidth);
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:_carModel.shopImg] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    //商品名
    NSString *godName = _carModel.shopName;
    CGSize size = [godName boundingRectWithSize:CGSizeMake(SCtitleWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_8],NSFontAttributeName, nil] context:nil].size;
    _goodTitle.frame = CGRectMake(_goodImageView.right+5, 10, size.width, 20);
    _goodTitle.text = _carModel.shopName;
    //颜色
    CGFloat conX;
    NSString *yanseStr =[NSString stringWithFormat:@"%@",_carModel.yanse];
    CGSize yanSzie = [yanseStr boundingRectWithSize:CGSizeMake(55*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    _goodColor.frame = CGRectMake(_goodImageView.right+5, _goodTitle.bottom+2, yanSzie.width, 20);
    if (![_carModel.yanse isEqualToString:@"0"] && ![_carModel.yanse isEqualToString:@""]) {
        _goodColor.text = yanseStr;
        [self.contentView addSubview:_goodColor];
        conX = yanSzie.width+5;
    }
    else{
        [_goodColor removeFromSuperview];
        conX = 0.0;
    }
    //型号
    NSString *xingStr =[NSString stringWithFormat:@"%@",_carModel.xinghao];
    CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(55*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    _goodStyle.frame = CGRectMake(_goodImageView.right+5+conX, _goodTitle.bottom+2, xinSzie.width, 20);
    if (![_carModel.xinghao isEqualToString:@""] && ![_carModel.xinghao isEqualToString:@"0"]) {
        _goodStyle.text = xingStr;
        [self.contentView addSubview:_goodStyle];
    }
    else
        [_goodStyle removeFromSuperview];
    //单价
    _moneyNum.frame = CGRectMake(_goodImageView.right+5, _goodTitle.bottom+25*SCscale, 100*MCscale, 25*MCscale);
    _moneyNum.text =[NSString stringWithFormat:@"¥%.2f",[_carModel.jiage floatValue]];
    //加减框图片
    NSString *goodProperty = [NSString stringWithFormat:@"%@",_carModel.shopshuxing];
    _changeNumImageView.frame = CGRectMake(kDeviceWidth-110*SCscale, 38*MCscale, 95*SCscale, 30*SCscale);
    //数量
    _goodNum.frame = CGRectMake(_changeNumImageView.left+32*SCscale, _changeNumImageView.top, 30*SCscale, 30*SCscale);
    _goodNum.text = [NSString stringWithFormat:@"%@",_carModel.shuliang];
    //减
    _subtractBtn.frame = CGRectMake(_changeNumImageView.left, _changeNumImageView.top, 30*SCscale, 30*SCscale);
    //加
    _addBtn.frame =  CGRectMake(_goodNum.right+2, _changeNumImageView.top, 30*SCscale, 30*SCscale) ;
    if ([goodProperty isEqualToString:@"5"]) {
        _subtractBtn.enabled = NO;
        _addBtn.enabled = NO;
        _changeNumImageView.image = [UIImage imageNamed:@"框"];
    }
    else{
        _subtractBtn.enabled = YES;
        _addBtn.enabled = YES;
        _changeNumImageView.image = [UIImage imageNamed:@"加减框"];
    }
    _isFirst = 1;
}
-(void)addOrSbutractAction:(UIButton *)btn
{
    NSString *dainpState = [NSString stringWithFormat:@"%@",_carModel.dianpuzhuangtai];
    if (![dainpState isEqualToString:@"3"]){
        if (btn.tag == 101) {
            //加
            _goodCount ++;
            _addOrCutBol = 1;
            _countMoney =[_carModel.jiage floatValue];
            [self changeAction:_selectBool];
        }
        else{
            //减
            if (_goodCount > 1) {
                _goodCount--;
                _addOrCutBol = 0;
                _countMoney =[_carModel.jiage floatValue];
                [self changeAction:_selectBool];
            }
        }
        _selOrAdd = 0;
        NSString *gNumber = [NSString stringWithFormat:@"%ld",(long)_goodCount];
        _goodNum.text = gNumber;
    }
    else{
        _selectBool = 2;
        [self changeAction:_selectBool];
    }
}
-(void)tap
{
    NSString *dainpState = [NSString stringWithFormat:@"%@",_carModel.dianpuzhuangtai];
    if (![dainpState isEqualToString:@"3"]) {
        if (_selectBool == 0) {
            _selectImageView.image = [UIImage imageNamed:@"选中"];
            _selectBool = 1;
            _addOrCutBol = 2;
            _selOrAdd = 1;
        }
        else{
            _selectImageView.image = [UIImage imageNamed:@"选择"];
            _selectBool = 0;
            _addOrCutBol = 2;
            _selOrAdd = 1;
        }
        _countMoney = _goodCount*[_carModel.jiage floatValue];
    }
    else{
        _selectBool = 2;
    }
    [self chooseGood:_selectBool];
}
-(void)changeAction:(NSInteger)selBol
{
    if ([self.delegate respondsToSelector:@selector(carViewCell:atIndex:addoOrCut:numCount:cellSelect:)]) {
        [self.delegate carViewCell:self atIndex:self.tag addoOrCut:_addOrCutBol numCount:_goodCount cellSelect:selBol];
    }
}
-(void)chooseGood:(NSInteger)chbol
{
    if ([self.delegate respondsToSelector:@selector(carViewcell:shooseGood:)]) {
        [self.delegate carViewcell:self shooseGood:_selectBool];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)walkVCClick:(NSNotification *)noti
{
    _goodCount = _carModel.shuliang.integerValue;
    _goodNum.text  = [NSString stringWithFormat:@"%ld",_goodCount];
}

@end
