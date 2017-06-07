//
//  FuliCollectionViewCell.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "FuliCollectionViewCell.h"
#import "FuliDisplayModel.h"
#import "Header.h"
@implementation FuliCollectionViewCell
{
    UIImageView *goodImage;
    UILabel *nameLabel;
    UILabel *tiaojianLabel;
    UIView *line;
    UIView *line1;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        goodImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        goodImage.backgroundColor = [UIColor clearColor];
        [self addSubview:goodImage];
        
        //提示label
        tiaojianLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tiaojianLabel.alpha = 1;
        tiaojianLabel.backgroundColor = txtColors(166, 41,39, 1);
        tiaojianLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        tiaojianLabel.textColor = [UIColor whiteColor];
        tiaojianLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tiaojianLabel];
        
        //提示label
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.alpha = 0.5;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        nameLabel.textColor = textColors;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
        
        //        line = [[UIView alloc]initWithFrame:CGRectZero];
        //        line.backgroundColor = lineColor;
        //        [self addSubview:line];
        //
        //        line1 = [[UIView alloc]initWithFrame:CGRectZero];
        //        line1.backgroundColor = lineColor;
        //        [self addSubview:line1];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    goodImage.frame = CGRectMake(0, 0,self.contentView.width, SCLimageHeigh+20*MCscale);
    tiaojianLabel.frame = CGRectMake(0, goodImage.bottom , self.width, 20*MCscale);

    nameLabel.frame = CGRectMake(0, tiaojianLabel.bottom +5*MCscale, self.width , 20*MCscale);
    //    line.frame = CGRectMake(0, self.height-1, kDeviceWidth/2.0+4, 1);
    //    line1.frame = CGRectMake(self.width+4.5, goodImage.top, 1, self.height-4);
}

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexPath AndArray:(NSArray *)array
{
    FuliDisplayModel *model = array[indexPath.row];
    [goodImage sd_setImageWithURL:[NSURL URLWithString:model.fuliimage] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    tiaojianLabel.text = [NSString stringWithFormat:@"满%@元可免费领取",model.money];
    nameLabel.text = model.dianpuname;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
}

@end
