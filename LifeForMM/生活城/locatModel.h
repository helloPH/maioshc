//
//  locatModel.h
//  LifeForMM
//
//  Created by HUI on 15/11/17.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface locatModel : BaseModel
@property (nonatomic,copy)NSString *diqu_name;//地区
@property (nonatomic,copy)NSString *shequ_name;//社区
@property (nonatomic,copy)NSString *suoshu_shensi;//城市
@property (nonatomic,copy)NSString *shequ_id;//社区id
@property (nonatomic,copy)NSString *distance; //距离
@property (nonatomic,copy)NSString *isXinrenli;//
@end
