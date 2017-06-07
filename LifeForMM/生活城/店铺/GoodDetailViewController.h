//
//  GoodDetailViewController.h
//  LifeForMM
//
//  Created by MIAO on 16/11/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDetailViewController : UIViewController
@property(nonatomic,copy)NSString *goodId;//商品id
@property(nonatomic,copy)NSString *dianpuId;//店铺id
@property(nonatomic,copy)NSString *godShequid; //社区id
@property(nonatomic,copy)NSString *goodtag;//标签图片url
@property(nonatomic,copy)NSString *zhuangtai;//商品状态
@end
