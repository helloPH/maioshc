//
//  MNWheelView.m
//  Tab学习
//
//  Created by qsit on 15-1-6.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MNWheelView.h"
#import "FuliModel.h"

//快速生成颜色
#define MNRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface MNWheelView()
{
    UIView *_baseView;
    BOOL anibool;
    int _index;
}

@end
@implementation MNWheelView

-(instancetype)init
{
    if (self=[super init]) {
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height>0) {
        if( _baseView==nil){
            [self viewDidLoad];
        }
    }
}
- (void)viewDidLoad
{
    _click=^(int i)
    {
//        NSLog(@"单击了第%d项",i);
    };
    _baseView=[[UIView alloc]init];
    _baseView.frame=self.bounds;
//    NSLog(@"_%f",_baseView.frame.size.height);
    [self addSubview:_baseView];
    //  [self createView];
    
    anibool=YES;
    UISwipeGestureRecognizer *rec=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    rec.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:rec];
    UISwipeGestureRecognizer *recdown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    recdown.direction=UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:recdown];
    
}
-(void)setImages:(NSArray *)images
{
    _images=[NSArray arrayWithArray:images];
    int count=(int)images.count;
    int mid = count/2-1;
    if (count > 3) {
        CGFloat smallH =50*MCscale;
        for (int i=0; i<count; i++) {
            FuliModel *model = images[i];
            UIImageView *view1=[[UIImageView alloc]init];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            _click(i);
            //mid == 2
            if (i<mid) {
                view1.frame=CGRectMake(3*MCscale,25*MCscale,smallH,150*MCscale-10*MCscale*2);
                btn.frame = view1.frame;
                btn.tag = 0;
            }else if(i>mid)
            {
                 view1.frame=CGRectMake(3*MCscale+smallH + 3*MCscale+150*MCscale + 3*MCscale+(smallH + 3*MCscale)*(i-2),25*MCscale,smallH,150*MCscale-10*MCscale*2);
                btn.frame = view1.frame;
                btn.tag = 0;
            }else
            {
                view1.frame=CGRectMake((smallH + 3*MCscale)*mid+ 3*MCscale,15*MCscale, 150*MCscale, 150*MCscale-4*MCscale);
                btn.frame = view1.frame;
                btn.frame = view1.frame;
                [btn setImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
                btn.imageEdgeInsets  = UIEdgeInsetsMake(23, 23, 22, 22);
                btn.tag = 3;
            }
            [view1 sd_setImageWithURL:[NSURL URLWithString:model.shopimage] placeholderImage:[UIImage imageNamed:@"placeholder"]];            
            view1.backgroundColor=[UIColor clearColor];
            view1.tag=i+1;
            //添加四个边阴影
            view1.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
            view1.layer.cornerRadius = 15.0;
            view1.layer.shadowRadius = 5.0;
            view1.layer.shadowOpacity = 0.5;
            view1.layer.shadowOffset = CGSizeMake(0, 0);
            [_baseView addSubview:view1];
        }
    }
    else
    {
        int mid=count/2;
        CGFloat smallH =70*MCscale;
        for (int i=0; i<count; i++) {
            FuliModel *model = images[i];
            UIImageView *view1=[[UIImageView alloc]init];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            _click(i);
            if (i<mid) {
                view1.frame=CGRectMake(0,0,smallH , 150*MCscale-10*MCscale*2);
                view1.center = CGPointMake(40*MCscale, _baseView.height/2);
                btn.frame = view1.frame;
                btn.tag = 1;
            }else if(i>mid)
            {
                view1.frame=CGRectMake(0,0,smallH,150*MCscale-10*MCscale*2);
                view1.center = CGPointMake(_baseView.width-40*MCscale, _baseView.height/2);
                btn.frame = view1.frame;
                btn.tag = 2;
            }else
            {
                view1.frame=CGRectMake( 0,0, 150*MCscale, 150*MCscale-4);
                view1.center = CGPointMake(_baseView.width/2, _baseView.height/2);
                btn.frame = view1.frame;
                [btn setImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
                btn.imageEdgeInsets  = UIEdgeInsetsMake(23, 23, 22, 22);
                btn.tag = 3;
            }
            [view1 sd_setImageWithURL:[NSURL URLWithString:model.shopimage] placeholderImage:[UIImage imageNamed:@"placeholder"]];

            view1.backgroundColor=[UIColor clearColor];
            view1.tag=i+1;
            //添加四个边阴影
            view1.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
            view1.layer.cornerRadius = 15.0;
            view1.layer.shadowRadius = 5.0;
            view1.layer.shadowOpacity = 0.5;
            view1.layer.shadowOffset = CGSizeMake(0, 0);
            [_baseView addSubview:view1];
        }
      }
    [self bigtop];
}
-(void)swipeUp:(UISwipeGestureRecognizer *)zer
{
    if (zer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self setAllFramge:0];
    }else if(zer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        [self setAllFramge:1];
    }
}
-(void)chick:(UIButton *)btn
{
    if (btn.tag==3) {
        _click(_index);
    }else
    {
        [self setAllFramge:(int)btn.tag];
    }
}
-(void)setAllFramge:(int)tag
{
    if (anibool==NO) {
        return;
    }
    anibool=NO;
    unsigned long count=_baseView.subviews.count;
    
    if (tag==1) {
        CGFloat minH=0;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMaxY(view1.frame);
            if (min>minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
        }
        if (minH>0) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
        }
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:1] frame];
            for (int i=1; i<count+1; i++)
            {
                if (i==count) {
                    [[_baseView viewWithTag:i] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:i] setFrame:[[_baseView viewWithTag:i+1] frame]];
                }
            }
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
        }];
    }else
    {
        CGFloat minH=10000;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMinY(view1.frame);
            if (min<minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
        }
        if (minH<10000) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
        }
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:count] frame];
            for (int i=1; i<count+1; i++)
            {
                if (i==count) {
                    [[_baseView viewWithTag:1] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:count-i+1] setFrame:[[_baseView viewWithTag:count-i] frame]];
                }
            }
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
        }];
    }
}

-(void)bigtop
{
    unsigned long count=_baseView.subviews.count;
    CGFloat maxW=0;
    UIView *maxHiew;
    for (int i=1; i<count+1; i++)
    {
        UIView *view1=[_baseView viewWithTag:i];
        if (view1.frame.size.width>maxW) {
            maxW=view1.frame.size.width;
            maxHiew=[_baseView viewWithTag:i];
            _index=i-1;
            _click(_index);
        }
    }
    if (maxW>0) {
        for (int j=0; j<count; j++)[_baseView bringSubviewToFront:maxHiew];
    }
}
@end


