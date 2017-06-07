//
//  carDataModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "carDataModel.h"

@implementation carDataModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"goodId" : @"shangpiid",
                             @"jiage" : @"jiage",
                             @"shopImg" : @"shopimg",
                             @"shopName" : @"shopname",
                             @"shuliang" : @"shuliang",
                             @"xinghao":@"xinghao",
                             @"yanse":@"yanse",
                             @"shequname":@"shequname",
                             @"shequid":@"shequid",
                             @"dianpuid":@"dianpuid",
                             @"shopshuxing":@"shopshuxing",
                             @"dianpuzhuangtai":@"dianpuzhuangtai",
                             @"xuangzhongzhuangtai":@"xuangzhongzhuangtai"};
    return mapDic;
    
}// 建一个映射关系表
@end
