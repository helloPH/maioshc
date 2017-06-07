//
//  SetPaymentPasswordView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 设置支付密码

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol SetPaymentPasswordViewDelegate <NSObject>

-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index;
-(void)rengzhengSuccessWithIndex:(NSInteger)index;


@end
@interface SetPaymentPasswordView : UIView<UITextFieldDelegate,MBProgressHUDDelegate>

@property(nonatomic,assign)NSInteger isFrom;
@property(nonatomic,strong)id<SetPaymentPasswordViewDelegate>setPaymentDelegate;
@property(nonatomic,strong)NSString *oldPas;//原密码


-(void)getTextFieldPlaceholderWithArray:(NSArray *)array;
@end
