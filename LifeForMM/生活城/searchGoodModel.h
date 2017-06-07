//
//  searchGoodModel.h
//  LifeForMM
//
//  Created by HUI on 15/11/12.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface searchGoodModel : BaseModel
@property(nonatomic,copy)NSString *canpinpic; //商品图片
@property(nonatomic,copy)NSString *shangpinname; // 商品名称
@property(nonatomic,copy)NSString *xianjia; //现价
@property(nonatomic,copy)NSString *yuanjia; // 原价
@property(nonatomic,copy)NSString *god_id;//商品id
@property(nonatomic,copy)NSString *dianpuid;//店铺id

@end
