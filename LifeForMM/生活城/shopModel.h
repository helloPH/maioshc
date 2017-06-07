//
//  shopModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/18.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface shopModel : BaseModel
@property(nonatomic,copy)NSString *biaoqian;
@property(nonatomic,copy)NSString *canpinpic;// 商品图片
@property(nonatomic,copy)NSString *shangpinname;//商品名称
@property(nonatomic,copy)NSString *shanpinid;//商品id
@property(nonatomic,copy)NSString *xianjia;//现价
@property(nonatomic,copy)NSString *yuanjia;//原价
@property(nonatomic,copy)NSString *rexiao;//热销
@property(nonatomic,copy)NSString *dinapuid;//店铺id
@property(nonatomic,strong)NSString *zhuangtai;

@end
