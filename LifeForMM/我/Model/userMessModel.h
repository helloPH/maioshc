//
//  userMessModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/7.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface userMessModel : BaseModel
@property(nonatomic,copy)NSString *anquanjibie; //安全级别
@property(nonatomic,copy)NSString *headImg; //头像
@property(nonatomic,copy)NSString *jianglicount; //推荐奖励红包个数
@property(nonatomic,copy)NSString *renzheng; //认证
@property(nonatomic,copy)NSString *totalmoney; //推荐奖励总金额
@property(nonatomic,copy)NSString *username; //用户名
@property(nonatomic,copy)NSString *youhuiquancount; //优惠券个数
@property(nonatomic,copy)NSString *yue; //余额
@end
