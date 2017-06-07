//
//  ActivityModel.h
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property(nonatomic,strong)NSString *dianpuid;//店铺id
@property(nonatomic,strong)NSString *dianpulogo;//店铺图标
@property(nonatomic,strong)NSString *dianpuname;//店铺名
@property(nonatomic,strong)NSString *renzheng;//认证
@property(nonatomic,strong)NSArray *huodngs;//活动
@property(nonatomic,strong)NSArray *imagesurl;//

@end
