//
//  locatModel.m
//  LifeForMM
//
//  Created by HUI on 15/11/17.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "locatModel.h"

@implementation locatModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"diqu_name":@"diqu_name",
                             @"shequ_name":@"shequ_name",
                             @"suoshu_shensi":@"suoshu_shensi",
                             @"shequ_id":@"shequ_id",
                             @"distance":@"distance",
                             @"isXinrenli":@"xinrenli"
                             };
    return mapDic;
}
@end
