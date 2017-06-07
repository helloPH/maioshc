//
//  OrderPromptView.h
//  LifeForMM
//
//  Created by MIAO on 16/5/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderPromptView;
@protocol OrderPromptViewDelegate <NSObject>

@optional
-(void)OrderPromptView:(OrderPromptView *)orderView AndButton:(UIButton *)button;

@end
@interface OrderPromptView : UIView
@property(nonatomic , strong)UIColor *shadowColor;
@property (nonatomic,retain)UILabel *titleLabel;//提示信息
@property (nonatomic,retain)UIButton *sureBtn;//确定按钮
@property (nonatomic,retain)UIButton *cancalBtn;//取消按钮
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)id<OrderPromptViewDelegate>orderPromptViewDelegate;
@end
