//
//  youhuiModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/9.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "youhuiModel.h"

@implementation youhuiModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"hongbaoid" : @"hongbaoid",
                             @"hongbaotype" : @"hongbaotype",
                             @"jine" : @"jine",
                             };
    return mapDic;
    
}// 建一个映射关系表
@end
