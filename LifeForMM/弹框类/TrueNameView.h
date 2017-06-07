//
//  TrueNameView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 实名认证

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol TrueNameViewDelegate <NSObject>
-(void)rengzhengSuccessWithIndex:(NSInteger)index;
@end

@interface TrueNameView : UIView<MBProgressHUDDelegate>
@property(nonatomic,strong)id<TrueNameViewDelegate>trueNameDelegate;
@end
