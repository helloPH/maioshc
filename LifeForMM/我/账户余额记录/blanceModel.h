//
//  blanceModel.h
//  LifeForMM
//
//  Created by HUI on 15/12/21.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface blanceModel : BaseModel
@property (nonatomic,copy)NSString *title; //收支详情
@property (nonatomic,copy)NSString *money; //可用余额
@property (nonatomic,copy)NSString *adddate; //时间
@property (nonatomic,copy)NSString *cost; //收支金额
@property (nonatomic,copy)NSString *danhao;//单号
@end
