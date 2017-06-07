//
//  recentOrderModel.m
//  LifeForMM
//
//  Created by HUI on 15/9/5.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "recentOrderModel.h"

@implementation recentOrderModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"guanjiantel" : @"guanjiantel",
                             @"shuliang" : @"shuliang",
                             @"guanjia" : @"guanjia",
                             @"yingfujine" : @"yingfujine",
                             @"dindanzhuangtai" : @"dindanzhuangtai",
                             @"guanjiaTel":@"guanjiaTel",
                             @"dianpuLogo":@"dianpuLogo",
                             @"danhao":@"danhao",
                             @"dindanzhuangtaidate":@"dindanzhuangtaidate",
                             @"cretdate":@"cretdate",
                             @"dianpulogo":@"dianpulogo",
                             @"chajia":@"chajia",
                             @"zhifuleixing":@"zhifuleixing"
                             };
    return mapDic;
    
}// 建一个映射关系表
@end
