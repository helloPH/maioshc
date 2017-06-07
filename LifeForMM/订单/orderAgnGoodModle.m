//
//  orderAgnGoodModle.m
//  LifeForMM
//
//  Created by HUI on 15/12/4.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "orderAgnGoodModle.h"

@implementation orderAgnGoodModle
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"fujiafei" : @"fujiafei",
                             @"jiage" : @"jiage",
                             @"shopimg" : @"shopimg",
                             @"shopname" : @"shopname",
                             @"shuliang":@"shuliang"
                             };
    return mapDic;
}// 建一个映射关系表
@end
