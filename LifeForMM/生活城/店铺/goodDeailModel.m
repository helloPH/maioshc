//
//  goodDeailModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "goodDeailModel.h"

@implementation goodDeailModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"canpinpic" : @"canpinpic",
                             @"guanxishangpin" : @"guanxishangpin",
                             @"guanlianpic" : @"guanlianpic",
                             @"shangpinjianjie" : @"shangpinjianjie",
                             @"shangpinid" : @"shangpinid",
                             @"kexuanyanse" : @"kexuanyanse",
                             @"kexuanyansepic" : @"kexuanyansepic",
                             @"shangpinname" : @"shangpinname",
                             @"xianjia" : @"xianjia",
                             @"yuanjia" : @"yuanjia",
                             @"xinghao" : @"xinghao",
                             @"jiage":@"jiage"};
    return mapDic;
    
}// 建一个映射关系表
@end
