//
//  blanceModel.m
//  LifeForMM
//
//  Created by HUI on 15/12/21.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "blanceModel.h"

@implementation blanceModel
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{@"adddate":@"adddate",
                             @"cost":@"cost",
                             @"danhao":@"danhao",
                             @"money":@"money",
                             @"title":@"title"
                             };
    return mapDic;
}
@end
