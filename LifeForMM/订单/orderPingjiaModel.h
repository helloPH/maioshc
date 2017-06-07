//
//  orderPingjiaModel.h
//  LifeForMM
//
//  Created by HUI on 16/1/5.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface orderPingjiaModel : BaseModel
@property(nonatomic,copy)NSString *guanjia;//评价
@property(nonatomic,copy)NSString *pingj_id; //id
@property(nonatomic,copy)NSString *logo; //评价选择logo
@property(nonatomic,copy)NSString *name; //评价名
@property(nonatomic,copy)NSString *shequ;//评价对应的社区
@end
