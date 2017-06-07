//
//  safeSetingModel.m
//  LifeForMM
//
//  Created by HUI on 16/1/4.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "safeSetingModel.h"

@implementation safeSetingModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"denglumima":@"denglumima",
                             @"email":@"email",
                             @"realname":@"realname",
                             @"shenfenzhenghao":@"shenfenzhenghao",
                             @"zhfumima":@"zhfumima",
                             @"emailnum":@"emailnum",
                             @"chushishebei":@"chushishebei"};
    return mapDic;
}// 建一个映射关系表
@end
