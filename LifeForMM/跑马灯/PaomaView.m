//
//  PaomaView.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "PaomaView.h"
#import "Header.h"
@implementation PaomaView
{
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//第二个位置
    NSMutableArray *labelArray;
    NSTimeInterval timeInterval;//时间
    BOOL isStop;//停止
    CGRect framess;
}
- (instancetype)initWithFrame:(CGRect)frame AndText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        text = [NSString stringWithFormat:@"  %@  ",text];
        timeInterval = [self displayDurationForString:text];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        textLabel.textColor = redTextColor;
        textLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
        textLabel.text = text;
        
        //计算textLabel的大小
        CGSize sizeofText = [textLabel sizeThatFits:CGSizeZero];
        rectMark1 = CGRectMake(0, 0, sizeofText.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x +rectMark1.size.width, 0, sizeofText.width, self.bounds.size.height);
        textLabel.frame = rectMark1;
        [self addSubview:textLabel];
        labelArray = [NSMutableArray arrayWithObject:textLabel];
        
        //判断是否需要reserveTextLebel;
        BOOL useReserve = sizeofText.width>framess.size.width ? YES : NO;
        
        if ((useReserve)) {
            UILabel *reserveTextLabel = [[UILabel alloc]initWithFrame:rectMark2];
            reserveTextLabel.textColor = redTextColor;
            reserveTextLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
            reserveTextLabel.text = text;
            [self addSubview:reserveTextLabel];
            [labelArray addObject:reserveTextLabel];
            [self paomaAnimate];
        }

            }
    return self;
}
-(void)paomaAnimate
{
    if (!isStop) {
        
        UILabel *label1 = labelArray[0];
        UILabel *label2 = labelArray[1];
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            label1.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            label2.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width, 0, label1.frame.size.width, label1.frame.size.height);
        } completion:^(BOOL finished) {
            label1.frame = rectMark2;
            label2.frame = rectMark1;
            
            [labelArray replaceObjectAtIndex:0 withObject:label2];
            [labelArray replaceObjectAtIndex:1 withObject:label1];
            [self paomaAnimate];
        }];
    }
}
-(void)start
{
    isStop = NO;
    UILabel *label1 = labelArray[0];
    UILabel *label2 = labelArray[1];
    label1.frame = rectMark2;
    label1.frame = rectMark1;
    [labelArray replaceObjectAtIndex:0 withObject:label2];
    [labelArray replaceObjectAtIndex:1 withObject:label1];
    [self paomaAnimate];
}
-(void)stop
{
    isStop  = YES;
}

-(NSTimeInterval)displayDurationForString:(NSString *)string
{
    return string.length/3;
}
@end
