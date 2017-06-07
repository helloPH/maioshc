//
//  headScrolImageModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/17.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "headScrolImageModel.h"

@implementation headScrolImageModel
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"imageurl":@"imageurl",
                             @"pipeiid":@"pipeiid",
                             @"shuxing":@"shuxing"};
    return mapDic;
    
}// 建一个映射关系表
@end
