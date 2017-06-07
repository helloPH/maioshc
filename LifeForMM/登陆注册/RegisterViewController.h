//
//  RegisterViewController.h
//  LifeForMM
//
//  Created by HUI on 15/7/31.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (nonatomic,copy)NSString *userPhone;//用户手机号
@property (nonatomic,copy)NSString *userCode;//验证码
@property (nonatomic,assign) BOOL isInvite;//是否邀请
@end
