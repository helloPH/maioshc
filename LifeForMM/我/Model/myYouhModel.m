//
//  myYouhModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/7.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "myYouhModel.h"

@implementation myYouhModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"day":@"day",
                             @"money":@"money",
                             @"shiyongyu":@"shiyongyu",
                             @"username":@"username",
                             @"youxiaoqi":@"youxiaoqi",
                             @"type":@"type"};
    return mapDic;
    
}// 建一个映射关系表
@end
