//
//  orderArginModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/4.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "orderArginModel.h"

@implementation orderArginModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"dianpuid" : @"dianpuid",
                             @"dianpuname" : @"dianpuname",
                             @"fapiao" : @"fapiao",
                             @"shouhuodizhi":@"shouhuodizhi",
                             @"shouhuoren":@"shouhuoren",
                             @"tel":@"tel",
                             @"shequid":@"shequid"};
    return mapDic;
}// 建一个映射关系表
@end
