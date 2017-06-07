//
//  agnAdresModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/15.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "agnAdresModel.h"

@implementation agnAdresModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"dianpuid" : @"dianpuid",
                             @"dianpuname" : @"dianpuname",
                             @"fapiao" : @"fapiao",
                             @"shequid":@"shequid",
                             @"appointmentMessage":@"yuyueshuoming"
                             };
    return mapDic;
}// 建一个映射关系表
@end
