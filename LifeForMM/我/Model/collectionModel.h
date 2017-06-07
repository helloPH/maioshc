//
//  collectionModel.h
//  LifeForMM
//
//  Created by HUI on 15/11/18.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface collectionModel : BaseModel
@property(nonatomic,copy)NSString *dianpuid;//店铺id
@property(nonatomic,copy)NSString *dianpuname; //店铺名
@property(nonatomic,copy)NSString *dianpulogo; //店铺logo
@property(nonatomic,copy)NSString *shopid; //商品id
@property(nonatomic,copy)NSString *shopname; // 商品名
@property(nonatomic,copy)NSString *canpinpic; // 商品logo
@property(nonatomic,copy)NSString *shequid;//社区id
@property(nonatomic,copy)NSString *xianjia;//现价
@property(nonatomic,copy)NSString *yuanjia;//原价
@end
