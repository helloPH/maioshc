//
//  safeSetingModel.h
//  LifeForMM
//
//  Created by HUI on 16/1/4.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface safeSetingModel : BaseModel
@property (nonatomic,copy)NSString *denglumima;//登录密码（1设置  2重置，设置和重置为右侧对应的显示文字
@property (nonatomic,copy)NSString *email;//邮箱（1设置  2重置，设置和重置为右侧对应的显示文字
@property (nonatomic,copy)NSString *realname; //真实姓名（用户无认证传0）
@property (nonatomic,copy)NSString *shenfenzhenghao;//真实姓名（用户无认证传0）
@property (nonatomic,copy)NSString *zhfumima; //支付密码（1设置  2重置）
@property (nonatomic,copy)NSString *emailnum;//邮箱号
@property (nonatomic,copy)NSString *chushishebei;//绑定设备号
@end
