//
//  recentOrderModel.h
//  LifeForMM
//
//  Created by HUI on 15/9/5.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface recentOrderModel : BaseModel
//@property(nonatomic,copy)NSString *danhao;//id
@property(nonatomic,copy)NSString *shuliang;//数量
@property(nonatomic,copy)NSString *yingfujine;//金额
@property(nonatomic,copy)NSString *dindanzhuangtai;//订单状态（0：已收货1：订单提交 2：处理中3：配送中4：已送达5：取消订单）
@property(nonatomic,copy)NSString *guanjiantel;//管家电话
@property(nonatomic,copy)NSString *guanjia;//管家
@property(nonatomic,copy)NSString *dianpulogo;//店铺logo
@property(nonatomic,copy)NSString *danhao;//单号
@property(nonatomic,copy)NSString *cretdate;//创建时间
@property(nonatomic,copy)NSString *dindanzhuangtaidate;//订单状态时间
@property(nonatomic,copy)NSString *chajia;//差价
@property(nonatomic,copy)NSString *zhifuleixing;//支付方式 0不显示 2在线支付 3余额支付
@end
