//
//  orderModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/31.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"dianpuid" : @"dianpuid",
                             @"dianpuname" : @"dianpuname",
                             @"goodId" : @"id",
                             @"jiage" : @"jiage",
                             @"shopId" : @"shopId",
                             @"shopimg":@"shopimg",
                             @"shopname":@"shopname",
                             @"shuliang":@"shuliang",
                             @"total":@"total",
                             @"youhui":@"youhui",
                             @"hongbaoCount":@"hongbaoCount",
                             @"tel":@"tel",
                             @"peisongfei":@"peisongfei",
                             @"fapiao":@"fapiao",
                             @"carid":@"carid",
                             @"dianpuLogo":@"dianpuLogo",
                             @"fujiafei":@"fujiafei",
                             @"appointmentMessage":@"yuyueshuoming"};
    return mapDic;
    
}// 建一个映射关系表
@end
