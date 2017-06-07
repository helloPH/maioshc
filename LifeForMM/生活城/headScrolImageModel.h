//
//  headScrolImageModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/17.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface headScrolImageModel : BaseModel
@property(nonatomic,copy)NSString *imageurl;//图片地址
@property(nonatomic,copy)NSString *shuxing;//图片对应属性 1商品 2店铺 3专题 0无属性不做处理
@property(nonatomic,copy)NSString *pipeiid;//跳转属性 1商品 2店铺 3店铺
@end
