//
//  orderMoney.m
//  LifeForMM
//
//  Created by HUI on 15/11/27.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "orderMoney.h"

@implementation orderMoney
// key : property  value : JSON key
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"fujiamoney" : @"fujiamoney",
                             @"peisongmoney" : @"peisongmoney",
                             @"totalPrice" : @"totalPrice",
                             @"youhui" : @"youhui",
                             @"totalPrices" : @"totalPrices",
                             @"youhuis": @"youhuis",
                             @"caiguomoney":@"caiguomoney",
                             @"juli":@"juli"};
    return mapDic;
    
}// 建一个映射关系表
@end
