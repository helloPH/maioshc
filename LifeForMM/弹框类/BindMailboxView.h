//
//  BindMailboxView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 邮箱绑定

#import <UIKit/UIKit.h>
#import "Header.h"


@protocol BindMailboxViewDelegate <NSObject>
-(void)BindMailboxSuccessWithIndex:(NSInteger)index;
@end
@interface BindMailboxView : UIView<MBProgressHUDDelegate>

@property(nonatomic,strong)id<BindMailboxViewDelegate>bingMailDelegate;

@end
