//
//  collectionModel.m
//  LifeForMM
//
//  Created by HUI on 15/11/18.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "collectionModel.h"

@implementation collectionModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"dianpuid":@"dianpuid",
                             @"dianpuname":@"dianpuname",
                             @"dianpulogo":@"dianpulogo",
                             @"shopid":@"shopid",
                             @"shopname":@"shopname",
                             @"canpinpic":@"canpinpic",
                             @"shequid":@"shequid",
                             @"xianjia":@"xianjia",
                             @"yuanjia":@"yuanjia"};
    return mapDic;
    
}// 建一个映射关系表
@end
