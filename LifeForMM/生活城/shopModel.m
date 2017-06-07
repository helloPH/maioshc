//
//  shopModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/18.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "shopModel.h"

@implementation shopModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"canpinpic" : @"canpinpic",
                             @"shanpinid" : @"shanpinid",
                             @"shangpinname" : @"shangpinname",
                             @"xianjia" : @"xianjia",
                             @"yuanjia" : @"yuanjia",
                             @"rexiao":@"rexiao",
                             @"biaoqian":@"biaoqian",
                             @"zhuangtai":@"zhuangtai",
                             @"dinapuid":@"dinapuid"};
    return mapDic;
    
}// 建一个映射关系表
@end
