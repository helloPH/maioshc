//
//  PopView.m
//  LifeForMM
//
//  Created by HUI on 15/7/29.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "PopView.h"
#import "Header.h"
@implementation PopView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _popBtn.backgroundColor = redTextColor;
    [_popBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _popBtn.layer.cornerRadius = 3.0;
    _popBtn.layer.masksToBounds = YES;
    _popBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
}
-(void)layoutSubviews
{
    _popBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    _popBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
    [_popBtn setTitle:_btnTitle forState:UIControlStateNormal];
    [_popBtn addTarget:self action:@selector(popBtnAction:atIndex:btnTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_popBtn];
    
}
#pragma mark -- Target Action
-(void)popBtnAction:(PopView *)pop atIndex:(NSInteger)index btnTag:(NSInteger)btag
{
    if ([self.delegate respondsToSelector:@selector(popBtnAction:atIndex:btnTag:)]) {
        [self.delegate popBtnAction:self atIndex:self.tag btnTag:self.popBtn.tag];
    }
}
@end
