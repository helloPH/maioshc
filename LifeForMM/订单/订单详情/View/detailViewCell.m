//
//  detailViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "detailViewCell.h"
#import "Header.h"
@implementation detailViewCell
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
    //商品图片
    _goodImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _goodImage.backgroundColor = [UIColor clearColor];
    //商品名称
    _goodTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodTitle.textAlignment = NSTextAlignmentLeft;
    _goodTitle.textColor = txtColors(90, 91, 92, 1);
    _goodTitle.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    _goodTitle.backgroundColor = [UIColor clearColor];
    //价格
    _price = [[UILabel alloc]initWithFrame:CGRectZero];
    _price.textColor = txtColors(90, 91, 92, 1);
    _price.textAlignment = NSTextAlignmentLeft;
    _price.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    //数量
    _godNum = [[UILabel alloc]initWithFrame:CGRectZero];
    _godNum.textAlignment = NSTextAlignmentLeft;
    _godNum.textColor = txtColors(90, 91, 92, 1);
    _godNum.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    //颜色
    _yanseL = [[UILabel alloc]initWithFrame:CGRectZero];
    _yanseL.textAlignment = NSTextAlignmentCenter;
    _yanseL.textColor = txtColors(90, 91, 92, 1);
    _yanseL.font = [UIFont systemFontOfSize:MLwordFont_6];
    //型号
    _xianghaoLab = [[UILabel alloc]initWithFrame:CGRectZero];
    _xianghaoLab.textAlignment = NSTextAlignmentCenter;
    _xianghaoLab.textColor = txtColors(90, 91, 92, 1);
    _xianghaoLab.font = [UIFont systemFontOfSize:MLwordFont_6];
    //分割线
    self.line = [[UIView alloc]initWithFrame:CGRectMake(17*MCscale, 65*MCscale, kDeviceWidth-34*MCscale,0.5)];
    self.line.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:_goodImage];
    [self.contentView addSubview:_goodTitle];
    [self.contentView addSubview:_price];
    [self.contentView addSubview:_godNum];
    [self.contentView addSubview:_yanseL];
    [self.contentView addSubview:_xianghaoLab];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //商品图片
    _goodImage.frame = CGRectMake(30*MCscale, 5, 55*MCscale, 55*MCscale);
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:[self.detailDics valueForKey:@"shopimg"]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
//    商品名称
    NSString *titl = [NSString stringWithFormat:@"%@",[self.detailDics valueForKey:@"shopname"]];
    CGSize size = [titl boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil].size;
    _goodTitle.frame = CGRectMake(_goodImage.right+12*MCscale, 10*MCscale, size.width, 20*MCscale);
    _goodTitle.text = titl;
    //价格
    _price.frame = CGRectMake(_goodImage.right+12, _goodTitle.bottom+5, 60*MCscale, 20*MCscale);
    _price.text = [NSString stringWithFormat:@"¥%.2f",[[_detailDics valueForKey:@"jiage"] floatValue]];
    //数量
    _godNum.frame = CGRectMake(_price.right+2, _goodTitle.bottom+5, 30*MCscale, 20*MCscale);
    _godNum.text = [NSString stringWithFormat:@"X%@",[_detailDics valueForKey:@"shuliang"]];
    NSString *ysStr =[NSString stringWithFormat:@"%@",[self.detailDics valueForKey:@"yanse"]];
    NSString *xhStr = [NSString stringWithFormat:@"%@",[self.detailDics valueForKey:@"xinghao"]];
    if (![ysStr isEqualToString:@"0"]) {
        CGSize yssize = [[self.detailDics valueForKey:@"yanse"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
        _yanseL.frame = CGRectMake(_godNum.right+2, _goodTitle.bottom+5, yssize.width, 20);
        _yanseL.text = [self.detailDics valueForKey:@"yanse"];
        if (![xhStr isEqualToString:@"0"]) {
            CGSize xhsize = [[self.detailDics valueForKey:@"xinghao"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
            _xianghaoLab.frame = CGRectMake(_yanseL.right+5, _goodTitle.bottom+5, xhsize.width, 20);
            _xianghaoLab.text = [self.detailDics valueForKey:@"xinghao"];
        }
    }
    else{
        if (![xhStr isEqualToString:@"0"]) {
            CGSize xhsize = [[self.detailDics valueForKey:@"xinghao"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
            _xianghaoLab.frame = CGRectMake(_godNum.right+2, _goodTitle.bottom+5, xhsize.width, 20);
            _xianghaoLab.text = [self.detailDics valueForKey:@"xinghao"];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
