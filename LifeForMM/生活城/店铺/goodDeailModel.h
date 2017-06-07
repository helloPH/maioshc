//
//  goodDeailModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface goodDeailModel : BaseModel
@property(nonatomic,copy)NSString *canpinpic;//商品图片
@property(nonatomic,copy)NSArray *guanxishangpin;//关联id
@property(nonatomic,retain)NSArray  *guanlianpic;//亲密搭档
@property(nonatomic,retain)NSArray *shangpinjianjie;//商品简介
@property(nonatomic,copy)NSString *shangpinid;//商品id
@property(nonatomic,retain)NSArray *kexuanyanse;//可选颜色
@property(nonatomic,retain)NSArray *kexuanyansepic;//可选颜色图片
@property(nonatomic,copy)NSString *shangpinname;//商品名
@property(nonatomic,copy)NSString *xianjia;//现价
@property(nonatomic,copy)NSString *yuanjia;//原价
@property(nonatomic,copy)NSArray *xinghao;//型号
@property(nonatomic,retain)NSArray *jiage;//关联商品价格
@end
