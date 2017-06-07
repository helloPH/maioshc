//
//  searchOldPrcLb.m
//  LifeForMM
//
//  Created by HUI on 15/12/29.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "searchOldPrcLb.h"

@implementation searchOldPrcLb

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.设置颜色
    [self.textColor setStroke];
    
    // 3.画线
    CGFloat y = rect.size.height * 0.5;
    CGContextMoveToPoint(ctx, -2, y);
    CGFloat endX = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]].width;
    CGContextAddLineToPoint(ctx, endX+5, y);
    
    // 4.渲染
    CGContextStrokePath(ctx);
}

@end
