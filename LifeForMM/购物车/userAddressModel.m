//
//  userAddressModel.m
//  LifeForMM
//
//  Created by HUI on 15/9/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "userAddressModel.h"

@implementation userAddressModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"name":@"name",
                             @"haoma":@"haoma",
                             @"address":@"address",
                             @"shouhuodizhi":@"shouhuodizhi",
                             @"dizhiId":@"dizhiId"
                             };
    return mapDic;
    
}// 建一个映射关系表
@end
