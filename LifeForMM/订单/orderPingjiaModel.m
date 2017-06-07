//
//  orderPingjiaModel.m
//  LifeForMM
//
//  Created by HUI on 16/1/5.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "orderPingjiaModel.h"

@implementation orderPingjiaModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"guanjia" : @"guanjia",
                             @"pingj_id" : @"id",
                             @"logo" : @"logo",
                             @"name":@"name",
                             @"shequ":@"shequ"
                             };
    return mapDic;
}// 建一个映射关系表
@end
