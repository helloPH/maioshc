//
//  OrderExceptionPrompt.h
//  LifeForMM
//
//  Created by MIAO on 16/7/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 订单异常提示

#import <UIKit/UIKit.h>

@protocol OrderExceptionPromptDelegate <NSObject>

-(void)titleViewHidden;

@end

@interface OrderExceptionPrompt : UIView

@property(nonatomic,strong)id<OrderExceptionPromptDelegate>orderDelegate;

-(void)getOrderPromptContentWithString:(NSString *)string;
@end
