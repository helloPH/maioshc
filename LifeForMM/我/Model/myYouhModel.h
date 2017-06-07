//
//  myYouhModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/7.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface myYouhModel : BaseModel
@property(nonatomic,copy)NSString *day; //还有几天过期
@property(nonatomic,copy)NSString *money; //优惠金额
@property(nonatomic,copy)NSString *shiyongyu; //适用于
@property(nonatomic,copy)NSString *username; //可用手机
@property(nonatomic,copy)NSString *youxiaoqi; //有效期
@property(nonatomic,copy)NSString *type;//类型
@end
