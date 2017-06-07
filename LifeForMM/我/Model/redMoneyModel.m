//
//  redMoneyModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/6.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "redMoneyModel.h"

@implementation redMoneyModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"hongbaoid":@"hongbaoid",
                             @"jieshouzhe":@"jieshouzhe",
                             @"money":@"money",
                             @"status":@"status"};
    return mapDic;
    
}// 建一个映射关系表
@end
