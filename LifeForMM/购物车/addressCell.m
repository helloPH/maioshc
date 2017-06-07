//
//  addressCell.m
//  LifeForMM
//
//  Created by HUI on 16/1/12.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "addressCell.h"
#import "Header.h"
@implementation addressCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self SubView];
    }
    return self;
}
-(void)SubView
{
    //姓名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    //电话
    _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _numLabel.textAlignment = NSTextAlignmentLeft;
    _numLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_numLabel];
    //选择按钮
    _choseImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _choseImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_choseImage];
    //电话号码
    _delImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _delImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_delImage];
    //地址
    _adresslabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _adresslabel.backgroundColor = [UIColor clearColor];
    _adresslabel.textAlignment = NSTextAlignmentLeft;
    _adresslabel.textColor = [UIColor blackColor];
    _adresslabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:_adresslabel];
    //删除按钮
    _delImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _delImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_delImage];
    _delImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_delImage addGestureRecognizer:tap];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 84*MCscale, self.width-20, 1)];
    line.backgroundColor = lineColor;
    [self.contentView addSubview:line];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _choseImage.frame = CGRectMake(15*MCscale, 30*MCscale, 22*MCscale, 22*MCscale);
    
    _nameLabel.frame = CGRectMake(_choseImage.right+10*MCscale, _choseImage.top-10*MCscale, 70*MCscale, 20*MCscale);
    
    NSString *receiverName =[NSString stringWithFormat:@"%@",_modl.name];
    NSRange range = [receiverName rangeOfString:@"("];
    if (range.location == NSNotFound) {
        _nameLabel.text = receiverName;
    }
    else{
        NSString *name = [receiverName substringWithRange:NSMakeRange(0, range.location)];
        _nameLabel.text = name;
    }
    
    _adresslabel.frame = CGRectMake(_choseImage.right+10*MCscale, _nameLabel.bottom+5*MCscale, self.width-88*MCscale, 20*MCscale);
    _adresslabel.text = _modl.address;
    
    _numLabel.frame = CGRectMake(_nameLabel.right+20*MCscale, _nameLabel.top, 120*MCscale, 20*MCscale);
    _numLabel.text = _modl.haoma;
    
    _delImage.frame = CGRectMake(self.width-40*MCscale, 25*MCscale, 22*MCscale, 25*MCscale);
    _delImage.image = [UIImage imageNamed:@"灰色删除"];
}
-(void)tapAction
{
    if ([self.delegate respondsToSelector:@selector(addressCell:tapIndex:)]) {
        [self.delegate addressCell:self tapIndex:_delImage.tag];
    }
}
@end
