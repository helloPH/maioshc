//
//  topActivityModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/18.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "topActivityModel.h"

@implementation topActivityModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"biaoti":@"biaoti",
                             @"jianjie":@"jianjie",
                             @"tupian":@"tupian"};
    return mapDic;
    
}// 建一个映射关系表
@end
