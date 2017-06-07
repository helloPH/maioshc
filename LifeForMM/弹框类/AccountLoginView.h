//
//  AccountLoginView.h
//  LifeForMM
//
//  Created by MIAO on 16/8/3.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 账号异常提示

#import <UIKit/UIKit.h>

@protocol AccountLoginViewDelegate <NSObject>

-(void)AccountLoginViewButtonClickWithIndex:(NSInteger )index;
@end

@interface AccountLoginView : UIView

-(void)loadLabelTextContentWithLoginTime:(NSString *)loginTime;

@property (nonatomic,strong)id<AccountLoginViewDelegate>accountDelegate;
@end
