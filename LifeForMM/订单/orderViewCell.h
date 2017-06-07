//
//  orderViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recentOrderModel.h"

@interface orderViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *timeLabel,*showLabel,*orderNum,*delivery,*goodNum,*money;//时间 显示对应文案 单号 已确认送达 数量 金额
@property(nonatomic,retain)UIImageView *submitImage,*handleingImage,*sendingImage,*receiveImage;//提交订单 处理中 配送中 已收货
@property(nonatomic,retain)UILabel *submitTime,*sendTime,*receiveTime;//订单时间 送货时间 收货时间
@property(nonatomic,retain)UILabel *housekeeper,*telNumber;//管家 手机号
@property(nonatomic,retain)UIButton *gotoeEvaluate,*telBtn;//去评价 打电话
@property(nonatomic,retain)UIImageView *userheadImage;//用户头像
@property(nonatomic,retain)recentOrderModel *model;
@property(nonatomic,retain)UILabel *guanjia,*tel;
@property(nonatomic,retain)UIView *lineView;
@property(nonatomic,retain)UILabel *payAgnNum;//还需支付金额
@property(nonatomic,retain)UIButton *payBtn,*cancelOrderBtn;//支付 取消订单
@end
