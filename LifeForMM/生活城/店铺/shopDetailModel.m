//
//  shopDetailModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/28.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "shopDetailModel.h"

@implementation shopDetailModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"amtime" : @"amtime",
                             @"dianpudizhi" : @"dianpudizhi",
                             @"dianpumingcheng" : @"dianpumingcheng",
                             @"dianputupian" : @"dianputupian",
                             @"pingja" : @"pingja",
                             @"pmtime":@"pmtime"};
    return mapDic;
    
}// 建一个映射关系表
@end
