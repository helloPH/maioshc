//
//  userMessModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/7.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "userMessModel.h"

@implementation userMessModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"anquanjibie":@"anquanjibie",
                             @"headImg":@"headImg",
                             @"jianglicount":@"jianglicount",
                             @"renzheng":@"renzheng",
                             @"totalmoney":@"totalmoney",
                             @"username":@"username",
                             @"youhuiquancount":@"youhuiquancount",
                             @"yue":@"yue"};
    return mapDic;
    
}// 建一个映射关系表
@end
