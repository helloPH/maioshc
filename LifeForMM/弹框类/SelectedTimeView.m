//
//  SelectedTimeView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SelectedTimeView.h"

@implementation SelectedTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(kDeviceWidth/2.0+1, 8, kDeviceWidth/2.0-4, 25*MCscale);
    self.saveBtn.backgroundColor = [UIColor clearColor];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:redTextColor forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(chooseSendTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2.0+1, 1, 1, 38*MCscale)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(2, 8, kDeviceWidth/2.0-4, 25*MCscale);
    self.cancleBtn.backgroundColor = [UIColor clearColor];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(chooseSendTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40*MCscale, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    self.pickDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30*MCscale, kDeviceWidth, 216)];
    self.pickDate.backgroundColor = [UIColor clearColor];
    self.pickDate.datePickerMode = UIDatePickerModeDateAndTime;
    NSDate *locationDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offSetComponets = [[NSDateComponents alloc]init];
    [offSetComponets setYear:0];
    [offSetComponets setMonth:12];
    [offSetComponets setDay:0];
    [offSetComponets setHour:24];
    [offSetComponets setMinute:0];
    [offSetComponets setSecond:0];
    NSDate *maxDate = [gregorian dateByAddingComponents:offSetComponets toDate:locationDate options:0];
    locationDate = [locationDate dateByAddingTimeInterval:+3600];
    self.pickDate.maximumDate = maxDate;
    self.pickDate.minimumDate = locationDate;
    [self addSubview:self.pickDate];
}

//选择时间
-(void)chooseSendTimeAction:(UIButton *)btn
{
    if (btn == self.saveBtn) {
        NSInteger btnTag = btn.tag;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:self.pickDate.date];
        if ([self.selectedTimeDelegate respondsToSelector:@selector(selectedTimeWithTag:AndDate:)]) {
            [self.selectedTimeDelegate selectedTimeWithTag:btnTag AndDate:dateStr];
        }
    }
    else if (btn == self.cancleBtn)
    {
        NSNotification *cancleBtnClick = [NSNotification notificationWithName:@"cancleBtnClick" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:cancleBtnClick];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancleBtnClick" object:nil];
    }
}

@end
