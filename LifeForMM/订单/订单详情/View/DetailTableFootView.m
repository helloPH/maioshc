//
//  DetailTableFootView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "DetailTableFootView.h"
#import "Header.h"
@implementation DetailTableFootView

- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUIWithString:str];
    }
    return self;
}
-(void)createUIWithString:(NSString *)dingdanbeizhu
{
    if (![dingdanbeizhu isEqualToString:@""] && ![dingdanbeizhu isEqualToString:@"0"]) {
        UILabel *bj = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, 80*MCscale, 20*MCscale)];
        bj.text = @"订单备注:";
        bj.textAlignment = NSTextAlignmentLeft;
        bj.textColor = textColors;
        bj.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        bj.backgroundColor = [UIColor clearColor];
        [self addSubview:bj];
        NSString *content =[NSString stringWithFormat:@"%@",dingdanbeizhu];
        CGSize size = [content boundingRectWithSize:CGSizeMake(kDeviceWidth-50*MCscale, 140*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        UILabel *bjContent = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, bj.bottom+10, kDeviceWidth-50*MCscale, size.height)];
        bjContent.textColor = textColors;
        bjContent.numberOfLines = 0;
        bjContent.backgroundColor = [UIColor clearColor];
        bjContent.textAlignment = NSTextAlignmentLeft;
        bjContent.text = content;
        bjContent.font = [UIFont systemFontOfSize:MLwordFont_5];
        [self addSubview:bjContent];
    }
}
@end
