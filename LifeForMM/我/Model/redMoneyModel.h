//
//  redMoneyModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/6.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface redMoneyModel : BaseModel
@property(nonatomic,copy)NSString *hongbaoid; //红包id
@property(nonatomic,copy)NSString *jieshouzhe; //红包接受者
@property(nonatomic,copy)NSString *money; //奖励金额
@property(nonatomic,copy)NSString *status; //接受状态
@end
