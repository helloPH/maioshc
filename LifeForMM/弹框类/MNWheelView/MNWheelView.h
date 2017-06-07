//
//  MNWheelView.h
//  Tab学习
//
//  Created by qsit on 15-1-6.
//  Copyright (c) 2015年 abc. All rights reserved.
//
//  齿轮滚动视图
//  可以手势滑动
//  单击上下边滑动
//       97259412@qq.com   黄美宁 制作 
//

#import <UIKit/UIKit.h>
#import "Header.h"
typedef void (^click) (int i);

@interface MNWheelView : UIView
//图片数组
@property(nonatomic,weak)NSArray *images;
//回调单击方法
@property(nonatomic,strong)click click;

@end


