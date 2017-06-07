//
//  MaskView.m
//  LifeForMM
//
//  Created by HUI on 15/7/29.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    }
    return self;
}
//-(void)addTapGesture
//{
//    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskMiss)];
//    [self addGestureRecognizer:tap];
//}
//-(void)maskMiss
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    self.alpha = 0;
//    [self removeFromSuperview];
//    [self endEditing:YES];
//    [UIView commitAnimations];
//}
@end
