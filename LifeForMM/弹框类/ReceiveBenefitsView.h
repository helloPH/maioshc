//
//  ReceiveBenefitsView.h
//  LifeForMM
//
//  Created by MIAO on 16/5/25.
//  Copyright © 2016年 时元尚品. All rights reserved.
//领取福利

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol ReceiveBenefitsViewDelegate <NSObject>

-(void)reloadDataWithFuliName;

@end
@interface ReceiveBenefitsView : UIView <MBProgressHUDDelegate>
@property (nonatomic,strong)UILabel *titleContentLabel;//提示信息
@property (nonatomic,strong)UIButton *abandonBtn;//放弃按钮
@property (nonatomic,strong)UIButton *receiveBtn;//领取按钮
@property (nonatomic,strong)UIView *horizontalLine;//横线
@property (nonatomic,strong)UIView *verticalLine;//竖线
@property (nonatomic,strong)id<ReceiveBenefitsViewDelegate>receiveBenefitsdelegate;

-(void)reloadDataFromArray:(NSArray *)array AndDanhao:(NSString *)string;

@end
