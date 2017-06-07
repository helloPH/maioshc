//
//  shopController.h
//  LifeForMM
//
//  Created by HUI on 16/3/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shopController : UIViewController
@property(nonatomic,copy)NSString *isHuodong;//是否有活动
@property(nonatomic,copy)NSString *shopId; // 店铺id
@property(nonatomic,copy)NSString *shopName; //店铺名
@property(nonatomic,assign)BOOL isReset;//是否休息中
@end
