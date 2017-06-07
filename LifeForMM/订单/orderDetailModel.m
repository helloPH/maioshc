//
//  orderDetailModel.m
//  LifeForMM
//
//  Created by HUI on 15/9/7.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderDetailModel.h"

@implementation orderDetailModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"shouhuoren" : @"shouhuoren",
                             @"dingdanhao" : @"dingdanhao",
                             @"tel" : @"tel",
                             @"shouhuodizhi" : @"shouhuodizhi",
                             @"zhifufangshi" : @"zhifufangshi",
                             @"cretdate" : @"cretdate",
                             @"dindanbeizhu" : @"dindanbeizhu",
                             @"yingfujines" : @"yingfujines",
                             @"youhuis" : @"youhuis",
                             @"dianpustate":@"dianpustate",
                             @"dianpuid" : @"dianpuid",
                             @"dinapuname" : @"dinapuname",
                             @"dindanzhuangtai" : @"dindanzhuangtai",
                             @"shopname" : @"shopname",
                             @"shopimg":@"shopimg",
                             @"shuliang":@"shuliang",
                             @"yanse":@"yanse",
                             @"xinghao":@"xinghao",
                             @"jiage":@"jiage",
                             @"shoplist":@"shoplist",
                             @"shequid":@"shequid",
                             @"yuyuesongda":@"yuyuesongda",
                             @"fapiaotaitou":@"fapiaotaitou",
                             @"peisongshishou":@"peisongshishou",
                             @"fujiafei":@"fujiafei",
                             @"fujiafeiname":@"fujiafeiname",
                             @"shopshuxing":@"shopshuxing"};
    return mapDic;
}// 建一个映射关系表
@end
