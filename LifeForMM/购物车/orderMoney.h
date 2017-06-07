//
//  orderMoney.h
//  LifeForMM
//
//  Created by HUI on 15/11/27.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface orderMoney : BaseModel
@property(nonatomic,copy)NSString *fujiamoney;//附加配
@property(nonatomic,copy)NSString *peisongmoney;//配送费
@property(nonatomic,copy)NSString *youhui;//店铺优惠
@property(nonatomic,copy)NSString *totalPrice;//店铺总价
@property(nonatomic,copy)NSString *totalPrices;//订单金额
@property(nonatomic,copy)NSString *youhuis;//订单优惠
@property(nonatomic,copy)NSString *caiguomoney;//采购费
@property(nonatomic,copy)NSString *juli; //距离

@end
