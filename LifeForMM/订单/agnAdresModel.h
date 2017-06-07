//
//  agnAdresModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/15.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface agnAdresModel : BaseModel //其中有店铺的相关信息
@property (nonatomic,copy)NSString *dianpuid; // 店铺id
@property (nonatomic,copy)NSString *dianpuname; //店铺名
@property (nonatomic,copy)NSString *fapiao; //是否有发票
@property (nonatomic,copy)NSString *shequid; //社区id
@property (nonatomic,copy)NSString *appointmentMessage;//预约说明
@end
