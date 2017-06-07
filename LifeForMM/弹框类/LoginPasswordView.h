//
//  LoginPasswordView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 登录密码验证

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol LoginPasswordViewDelegate <NSObject>
-(void)LoginPasswordViewSuccessWithIndex:(NSInteger)index;
@end
@interface LoginPasswordView : UIView<UITextFieldDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)id<LoginPasswordViewDelegate>loginPasswordDelegate;

@property(nonatomic,assign)NSInteger indexPath;

@end
