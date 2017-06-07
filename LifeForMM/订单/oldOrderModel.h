//
//  oldOrderModel.h
//  LifeForMM
//
//  Created by HUI on 15/9/7.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface oldOrderModel : BaseModel
@property(nonatomic,copy)NSString *dindanzhuangtai;//订单状态
@property(nonatomic,copy)NSString *dianpulogo; // 店铺logo
@property(nonatomic,copy)NSString *danhao; // 单号
@property(nonatomic,copy)NSString *cretdate; // 下单日期
@property(nonatomic,copy)NSString *time;//用时
@property(nonatomic,copy)NSString *pingfeng;//评分
@property(nonatomic,copy)NSString *pingjianame;//评价名
@end
