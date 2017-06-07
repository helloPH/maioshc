//
//  searchCell.m
//  LifeForMM
//
//  Created by HUI on 15/12/29.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "searchCell.h"
#import "Header.h"
@implementation searchCell
{
    UIView *lineView;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self subViews];
    }
    return self;
}
-(void)subViews
{
    //商品图片
    _goodLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
    _goodLogo.backgroundColor = [UIColor clearColor];
    _goodLogo.contentMode = UIViewContentModeScaleAspectFit;
    //商品名
    _goodName = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodName.backgroundColor = [UIColor clearColor];
    _goodName.textAlignment = NSTextAlignmentLeft;
    _goodName.textColor = txtColors(25, 26, 27, 1);
    _goodName.font = [UIFont systemFontOfSize:MLwordFont_6];
    //现价
    _goodPric = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodPric.backgroundColor = [UIColor clearColor];
    _goodPric.textAlignment = NSTextAlignmentLeft ;
    _goodPric.textColor = txtColors(248, 53, 74, 1);
    _goodPric.font = [UIFont systemFontOfSize:MLwordFont_12];
    //原价
    _goodOldPrice = [[searchOldPrcLb alloc]initWithFrame:CGRectZero];
    _goodOldPrice.backgroundColor = [UIColor clearColor];
    _goodOldPrice.textAlignment = NSTextAlignmentCenter;
    _goodOldPrice.textColor = textColors;
    _goodOldPrice.alpha = 0;
    _goodOldPrice.font = [UIFont systemFontOfSize:MLwordFont_12];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //商品logo
    _goodLogo.frame = CGRectMake(30*MCscale, 5, 70*MCscale, 70*MCscale);
    [_goodLogo sd_setImageWithURL:[NSURL URLWithString:_secmodel.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    //商品名
    NSString *godName = _secmodel.shangpinname;
    CGSize size = [godName boundingRectWithSize:CGSizeMake(220*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6], NSFontAttributeName,nil] context:nil].size;
    _goodName.frame = CGRectMake(_goodLogo.right+10, _goodLogo.top+5, size.width*MCscale+20, 20);
    _goodName.text = _secmodel.shangpinname;
    //现价
    NSString *godPic = [NSString stringWithFormat:@"¥%@",_secmodel.xianjia];
    CGSize picSize = [godPic boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_12], NSFontAttributeName,nil] context:nil].size;
    _goodPric.frame = CGRectMake(_goodLogo.right+10, _goodName.bottom+10, picSize.width, 20);
    _goodPric.text = godPic;
    //原价
    NSString *oldPric = [NSString stringWithFormat:@"¥%@",_secmodel.yuanjia];
    CGSize oldPicSize = [oldPric boundingRectWithSize:CGSizeMake(80, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_12], NSFontAttributeName,nil] context:nil].size;
    _goodOldPrice.frame = CGRectMake(_goodPric.right+15, _goodName.bottom+10, oldPicSize.width+5, 20);
    _goodOldPrice.text = oldPric;
    NSString *yuanjia = [NSString stringWithFormat:@"%@",_secmodel.yuanjia];
    if ([yuanjia isEqualToString:@"0.0"]) {
        _goodOldPrice.alpha = 0;
    }
    else if ([yuanjia isEqualToString:@"0"])
    {
        _goodOldPrice.alpha = 0;
    }
    else
        _goodOldPrice.alpha = 1;
    
    
    [self.contentView addSubview:_goodLogo];
    [self.contentView addSubview:_goodName];
    [self.contentView addSubview:_goodPric];
    [self.contentView addSubview:_goodOldPrice];
    
    lineView.frame = CGRectMake(10*MCscale, self.height - 1, self.width - 20*MCscale, 1);
}
@end
