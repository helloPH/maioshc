//
//  oldOrderModel.m
//  LifeForMM
//
//  Created by HUI on 15/9/7.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "oldOrderModel.h"

@implementation oldOrderModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"dindanzhuangtai" : @"dindanzhuangtai",
                             @"dianpulogo" : @"dianpulogo",
                             @"danhao" : @"danhao",
                             @"cretdate" : @"cretdate",
                             @"time":@"time",
                             @"pingfeng":@"pingfeng",
                             @"pingjianame":@"pingjianame"};
    return mapDic;
}// 建一个映射关系表
@end
