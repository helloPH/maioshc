//
//  searchGoodModel.m
//  LifeForMM
//
//  Created by HUI on 15/11/12.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "searchGoodModel.h"

@implementation searchGoodModel
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"canpinpic": @"canpinpic",
                             @"shangpinname":@"shangpinname",
                             @"xianjia":@"xianjia",
                             @"yuanjia":@"yuanjia",
                             @"god_id":@"id",
                             @"dianpuid":@"dianpuid"
                             };
    return mapDic;
    
}// 建一个映射关系表
@end
