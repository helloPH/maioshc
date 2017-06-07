//
//  oldOrderViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "oldOrderModel.h"
@interface oldOrderViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *orderNumber,*orderTime,*orderState;//单号 时间 状态
@property(nonatomic,retain)UIImageView *orderGoodImag;
@property(nonatomic,retain)oldOrderModel *model;
@property(nonatomic,retain)UILabel *pingjia,*goodEl,*ServiceEl;
@end
