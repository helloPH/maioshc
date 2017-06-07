//
//  shopListModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "shopListModel.h"

@implementation shopListModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"dianpulogo" : @"dianpulogo",
                             @"lianxidizi" : @"lianxidizi",
                             @"shequPaixu" : @"shequPaixu",
                             @"yingyeType" : @"yingyeType",
                             @"dianpuname" : @"dianpuname",
                             @"imagesurl": @"imagesurl",
                             @"shopId":@"dianpuid",
                             @"yuyueshuomin":@"yuyueshuomin",
                             @"zhuangtaipaihu":@"zhuangtaipaihu",
                             @"renzheng":@"renzheng",
                             @"isHuodong":@"massages"};
    return mapDic;
    
}// 建一个映射关系表
@end
