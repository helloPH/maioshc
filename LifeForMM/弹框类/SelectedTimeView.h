//
//  SelectedTimeView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
// //选择时间视图

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol SelectedTimeViewDelegate <NSObject>

-(void)selectedTimeWithTag:(NSInteger)tag AndDate:(NSString *)datestr;

@end
@interface SelectedTimeView : UIView

@property(nonatomic,strong)UIButton *saveBtn;//dataPick 保存按钮
@property(nonatomic,strong)UIDatePicker *pickDate;//时间pickView
@property(nonatomic,strong)UIButton *cancleBtn;//取消按钮
@property(nonatomic,strong)id<SelectedTimeViewDelegate>selectedTimeDelegate;

@end
