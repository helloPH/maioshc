//
//  MyInvitationCell.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MyInvitationCell.h"
#import "MyInviteModel.h"
#import "Header.h"
@implementation MyInvitationCell
{
    UIImageView *headImageView;
    UILabel *telLabel;
    UILabel *timeLabel;
    UILabel *moneyLabel;
    UIView *lineView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageView.layer.cornerRadius = 30*MCscale;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    
    telLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    telLabel.textColor = textColors;
    telLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:telLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.textColor = textColors;
    timeLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:timeLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = redTextColor;
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:moneyLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
    
}

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexPath AndArray:(NSArray *)array
{
    MyInviteModel *model = array[indexPath.row];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headimage]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    telLabel.text = model.tel;
    timeLabel.text = model.time;
    moneyLabel.text = [NSString stringWithFormat:@"%@元",model.jine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    headImageView.frame = CGRectMake(5*MCscale, 5*MCscale, 60*MCscale, 60*MCscale);
    telLabel.frame = CGRectMake(headImageView.right +5*MCscale, 10*MCscale, self.width - 130*MCscale, 20*MCscale);
    timeLabel.frame = CGRectMake(headImageView.right +5*MCscale, telLabel.bottom +5*MCscale, self.width - 130*MCscale, 20*MCscale);
    moneyLabel.frame = CGRectMake(self.contentView.width - 60*MCscale, 25*MCscale,60*MCscale, 20*MCscale);
    lineView.frame = CGRectMake(10*MCscale, self.height - 1, self.width - 20*MCscale, 1);
}
@end
