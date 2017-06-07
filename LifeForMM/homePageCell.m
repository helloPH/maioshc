//
//  homePageCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "homePageCell.h"
#import "Header.h"
#define smImageHigh 57
#define smImageLength 15
@implementation homePageCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageViewAry = [[NSMutableArray alloc]initWithCapacity:8];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    _storeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _storeImage.backgroundColor = [UIColor clearColor];
    _storeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_storeImage];

    _storeName = [[UILabel alloc]initWithFrame:CGRectZero];
    _storeName.backgroundColor = [UIColor clearColor];
    _storeName.font = [UIFont systemFontOfSize:MLwordFont_6];
    _storeName.textColor = txtColors(25, 26, 27, 1);
    _storeName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_storeName];

    _renzhengImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    _renzhengImg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_renzhengImg];

    _address = [[UILabel alloc]initWithFrame:CGRectZero];
    _address.backgroundColor = [UIColor clearColor];
    _address.font = [UIFont systemFontOfSize:MLwordFont_9];
    _address.textColor = txtColors(126, 127, 129, 1);
    _address.textAlignment = NSTextAlignmentLeft;

    for (int i = 0; i<8; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
        image.backgroundColor = [UIColor clearColor];
        [_imageViewAry addObject:image];
    }
    _actionState = [[UIImageView alloc]initWithFrame:CGRectZero];
    _actionState.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_actionState];

    _yuyueMessage = [[UILabel alloc]initWithFrame:CGRectZero];
    _yuyueMessage.backgroundColor = [UIColor clearColor];
    _yuyueMessage.textAlignment = NSTextAlignmentRight;
    _yuyueMessage.textColor = txtColors(126, 127, 129, 1);
    _yuyueMessage.font = [UIFont systemFontOfSize:MLwordFont_9];
    [self.contentView addSubview:_yuyueMessage];
    
    _line = [[UIView alloc]initWithFrame:CGRectZero];
    _line.backgroundColor = lineColor;
    [self.contentView addSubview:_line];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _storeImage.frame = CGRectMake(30*MCscale, 5, 70*MCscale, 70*MCscale);
    _storeImage.contentMode = UIViewContentModeScaleAspectFit;
    [_storeImage sd_setImageWithURL:[NSURL URLWithString:_shopModel.dianpulogo] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    _storeNameString = _shopModel.dianpuname;
    _storeName.text = _storeNameString;
    CGSize storeNameSize = [_storeNameString boundingRectWithSize:CGSizeMake(175*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    _storeName.frame = CGRectMake(105*MCscale, 5, storeNameSize.width, 30*MCscale);
    
    _renzhengImg.frame = CGRectMake(_storeName.right+3, _storeName.top+8, 14*MCscale, 14*MCscale);
    if ([_shopModel.renzheng isEqual:[NSNull null]]) {
//        [_renzhengImg sd_setImageWithURL:[NSURL URLWithString:_shopModel.renzheng] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    }
    else
    {
        [_renzhengImg sd_setImageWithURL:[NSURL URLWithString:_shopModel.renzheng] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    }
    _addressDetail = _shopModel.lianxidizi;
    _address.text = _addressDetail;
    CGSize addressSize = [_addressDetail boundingRectWithSize:CGSizeMake(150*MCscale, 18*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil].size;
//    _addresstitle.frame = CGRectMake(105*MCscale, 30*MCscale, 30*MCscale, 20*MCscale);
//    _addresstitle.text = @"地址:";
    
    _address.frame = CGRectMake(105*MCscale, 30*MCscale, addressSize.width, 18*MCscale);
    [self.contentView addSubview:_address];
    NSMutableArray *imagAry = [[NSMutableArray alloc]init];
    for(NSString *str in _shopModel.imagesurl){
        if (![str isEqual:[NSNull null]] && ![str isEqualToString:@""]) {
            [imagAry addObject:str];
        }
    }
    for(int i = 0 ;i<8 ;i++){
        UIImageView *image = _imageViewAry[i];
        image.frame = CGRectMake(105*MCscale+17*i*MCscale, smImageHigh*MCscale, smImageLength*MCscale, smImageLength*MCscale);
        if (i<imagAry.count) {
            [image sd_setImageWithURL:[NSURL URLWithString:imagAry[i]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            [self.contentView addSubview:image];
        }
        else{
            [image removeFromSuperview];
        }
    }
    _line.frame = CGRectMake(10*MCscale,self.height - 0.5, self.width  -20 *MCscale, 0.5);
    _actionState.frame = CGRectMake(self.frame.size.width-65*MCscale, 10*MCscale, 50*MCscale, 17*MCscale);
    NSString *stateStr = @"";
    if([[NSString stringWithFormat:@"%@",_shopModel.zhuangtaipaihu] isEqualToString:@"1"]){
        stateStr = @"营业中";
        _yuyueMessage.alpha = 0;
    }
    else if ([[NSString stringWithFormat:@"%@",_shopModel.zhuangtaipaihu] isEqualToString:@"3"]){
        stateStr = @"休息中";
        _yuyueMessage.alpha = 0;
    }
    else{
        stateStr = @"可预约";
        _yuyueMessage.frame = CGRectMake(self.frame.size.width-115*MCscale, 30*MCscale, 100*MCscale, 20*MCscale);
        if (![_shopModel.yuyueshuomin isEqual:[NSNull null]]) {
            _yuyueMessage.text = _shopModel.yuyueshuomin;
        }
        _yuyueMessage.alpha = 1;
    }
    _actionState.image = [UIImage imageNamed:stateStr];
    
}
@end
