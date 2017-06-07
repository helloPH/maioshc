//
//  shopListModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface shopListModel : BaseModel
@property(nonatomic,copy)NSString *dianpuname;//店铺名称
@property(nonatomic,copy)NSString *shequPaixu;// 排序标准
@property(nonatomic,copy)NSString *lianxidizi; //联系地址
@property(nonatomic,copy)NSString *yingyeType;//营业状态
@property(nonatomic,copy)NSString *dianpulogo;//店铺图片
@property(nonatomic,retain)NSMutableArray *imagesurl;//店铺活动图标
@property(nonatomic,copy)NSString *shopId;//店铺id
@property(nonatomic,retain)NSString *yuyueshuomin;//预约说明
@property(nonatomic,retain)NSString *zhuangtaipaihu;
@property(nonatomic,copy)NSString *renzheng;//认证
@property(nonatomic,copy)NSString *isHuodong;// 是否有活动
@end
