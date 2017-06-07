//
//  ActivityCell.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityModel.h"
#import "Header.h"
#define smImageHigh 57
#define smImageLength 15
@implementation ActivityCell
{
    UIImageView *storeImage,*actionState,*renzhengImg;
    UILabel *storeName,*addresstitle;
    NSString *addressDetail,*storeNameString;
    NSMutableArray *imageViewAry,*huodongArray;
    UIView *line,*lineView;//底部线
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageViewAry = [[NSMutableArray alloc]initWithCapacity:8];
        huodongArray = [[NSMutableArray alloc]initWithCapacity:8];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    storeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    storeImage.backgroundColor = [UIColor clearColor];
    storeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:storeImage];
    
    storeName = [[UILabel alloc]initWithFrame:CGRectZero];
    storeName.backgroundColor = [UIColor clearColor];
    storeName.font = [UIFont systemFontOfSize:MLwordFont_6];
    storeName.textColor = txtColors(25, 26, 27, 1);
    storeName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:storeName];
    
    renzhengImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    renzhengImg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:renzhengImg];
    
    for (int i = 0; i<8; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
        image.backgroundColor = [UIColor clearColor];
        [imageViewAry addObject:image];
    }
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
    
    for (int i = 0; i<5; i++) {
        UIView *huodongView = [[UIView alloc]initWithFrame:CGRectZero];
        huodongView.backgroundColor = [UIColor clearColor];
        [huodongArray addObject:huodongView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 20*MCscale, 20*MCscale)];
        [huodongView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale,0,kDeviceWidth-140*MCscale, 20*MCscale)];
        label.textColor = textColors;
        label.font = [UIFont systemFontOfSize:MLwordFont_7];
        [huodongView addSubview:label];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 25*MCscale, kDeviceWidth-120*MCscale, 0.5)];
        line1.backgroundColor = lineColor;
        [huodongView addSubview:line1];
    }
    
    line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    [self.contentView addSubview:line];
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexPath AndArray:(NSArray *)array
{
    ActivityModel *model = array[indexPath.row];
    [storeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.dianpulogo]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    storeNameString = model.dianpuname;
    storeName.text = storeNameString;
    CGSize storeNameSize = [storeNameString boundingRectWithSize:CGSizeMake(175*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    storeName.frame = CGRectMake(90*MCscale,7*MCscale, storeNameSize.width, 20*MCscale);
    
    renzhengImg.frame = CGRectMake(storeName.right+3, storeName.top+4, 14*MCscale, 14*MCscale);
    [renzhengImg sd_setImageWithURL:[NSURL URLWithString:model.renzheng] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    
    NSMutableArray *imagAry = [[NSMutableArray alloc]init];
    for(NSString *str in model.imagesurl){
        if (![str isEqual:[NSNull null]] && ![str isEqualToString:@""]) {
            [imagAry addObject:str];
        }
    }
    for(int i = 0 ;i<8 ;i++){
        UIImageView *image = imageViewAry[i];
        image.frame = CGRectMake(90*MCscale+17*i*MCscale,storeName.bottom +5*MCscale, smImageLength*MCscale, smImageLength*MCscale);
        if (i<imagAry.count) {
            [image sd_setImageWithURL:[NSURL URLWithString:imagAry[i]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            [self.contentView addSubview:image];
        }
        else{
            [image removeFromSuperview];
        }
    }
    
    NSMutableArray *huodongAry = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in model.huodngs){
            [huodongAry addObject:dict];
    }
    
    for(int i = 0 ;i<5 ;i++){
        UIView *huodongView = huodongArray[i];
        huodongView.frame = CGRectMake(90*MCscale,30*i+60*MCscale,kDeviceWidth-100*MCscale,25*MCscale);
        if (i<huodongAry.count) {
            UIImageView *image = huodongView.subviews[0];
            [image sd_setImageWithURL:[NSURL URLWithString:huodongAry[i][@"image"]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            UILabel *label = huodongView.subviews[1];
            label.text = [NSString stringWithFormat:@"%@",huodongAry[i][@"shuoming"]];
            UIView *line1 = huodongView.subviews[2];
            if (i +1 == huodongAry.count) {
                line1.hidden = YES;
            }
            [self.contentView addSubview:huodongView];
        }
        else{
            [huodongView removeFromSuperview];
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    storeImage.frame = CGRectMake(0,0, 70*MCscale, 70*MCscale);
    storeImage.center = CGPointMake(45*MCscale, self.height /2.0);
    lineView.frame = CGRectMake(90*MCscale,55*MCscale, self.width  -120 *MCscale, 0.5);

    line.frame = CGRectMake(0,self.height - 1, self.width,1);

}
@end
