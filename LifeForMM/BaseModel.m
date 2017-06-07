//
//  BaseModel.m
//  LifeForMM
//
//  Created by HUI on 15/8/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (id)initWithContent:(NSDictionary *)json
{
    self = [self init];
    
    if (self) {
        
        [self setModelData:json];
    }
    
    return self;
}

- (id)mapAttributes
{
    return nil;
}
//选择器
- (SEL)setterMethod:(NSString *)key
{
    // 生成setter方法
    NSString *first = [[key substringToIndex:1] capitalizedString];
    
    NSString *end = [key substringFromIndex:1];
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, end];
    //  例如： setterName = setBox
    return NSSelectorFromString(setterName); //NSSelectorFromString方法可以根据 setterName 生成一个对应的set方法  例如：setName
} // 生成setter方法

- (void)setModelData:(NSDictionary *)json
{
    // 建立映射关系
    NSDictionary *mapDic = [self mapAttributes];
    
    for (id key in mapDic) {
        
        // setter 方法
        SEL sel = [self setterMethod:key];
        
        if ([self respondsToSelector:sel]) {
            
            // 得到JSON key
            id jsonKey = [mapDic objectForKey:key];
            
            // 得到JSON value
            id jsonValue = [json objectForKey:jsonKey];
            
            // [self setTitle:@"title"];
            // [self setDic:dic];
            [self performSelector:sel withObject:jsonValue];
            
        }
    }
} // 属性赋值
@end
