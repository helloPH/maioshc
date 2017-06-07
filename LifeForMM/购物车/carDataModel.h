//
//  carDataModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface carDataModel : BaseModel
@property(nonatomic,copy)NSString *goodId;//商品id
@property(nonatomic,copy)NSString *jiage;//商品单价
@property(nonatomic,copy)NSString *shopImg;//商品图像
@property(nonatomic,copy)NSString *shopName;//商品名称
@property(nonatomic,copy)NSString *shuliang;//数量
@property(nonatomic,copy)NSString *xinghao;//型号
@property(nonatomic,copy)NSString *yanse;//颜色
@property(nonatomic,copy)NSString *shequname;//社区名
@property(nonatomic,copy)NSString *shequid;//社区id
@property(nonatomic,copy)NSString *dianpuid;//店铺id
@property(nonatomic,copy)NSString *shopshuxing;//商品属性
@property(nonatomic,copy)NSString *dianpuzhuangtai;//（1营业中,2可预约,3休息中）
@property(nonatomic,copy)NSString *xuangzhongzhuangtai;//选中状态（1：选中，0：未选中）
@end
