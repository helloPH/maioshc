//
//  shopTypeModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/19.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "shopTypeModel.h"

@implementation shopTypeModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"leibie" : @"leibie",
                             @"rexiaoShezhi" : @"rexiaoShezhi"};
    return mapDic;
    
}// 建一个映射关系表
@end
