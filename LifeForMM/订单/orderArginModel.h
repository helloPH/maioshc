//
//  orderArginModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/4.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface orderArginModel : BaseModel
@property (nonatomic,copy)NSString *dianpuid;//店铺id
@property (nonatomic,copy)NSString *dianpuname; // 店铺名
@property (nonatomic,copy)NSString *fapiao;// 是否发票
@property (nonatomic,copy)NSString *shouhuodizhi;//收货地址
@property (nonatomic,copy)NSString *shouhuoren;//收货人
@property (nonatomic,copy)NSString *tel;// 电话
@property (nonatomic,copy)NSString *shequid;//社区id
//@property (nonatomic,copy)NSString *zhuanghuyue;//账户余额
//@property (nonatomic,retain)NSArray *shangpi;// 商品信息
@end
