//
//  orderDetailModel.h
//  LifeForMM
//
//  Created by HUI on 15/9/7.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "BaseModel.h"

@interface orderDetailModel : BaseModel
@property(nonatomic,copy)NSString *dianpuid; //店铺id
@property(nonatomic,copy)NSString *dianpustate;//店铺状态
@property(nonatomic,copy)NSString *dinapuname; //店铺名字
@property(nonatomic,copy)NSString *dindanbeizhu; //订单备注
@property(nonatomic,copy)NSString *dindanzhuangtai; //订单状态
@property(nonatomic,copy)NSString *dingdanhao;//单号
@property(nonatomic,copy)NSString *fapiaotaitou;//发票台头
@property(nonatomic,copy)NSString *fujiafei;//附加费
@property(nonatomic,copy)NSString *fujiafeiname;//附加费名字
@property(nonatomic,copy)NSString *peisongshishou;//配送实收
@property(nonatomic,copy)NSString *shequid;//社区id
@property(nonatomic,retain)NSArray *shoplist;//商品数组

@property(nonatomic,copy)NSString *jiage; //价格
@property(nonatomic,copy)NSString *shopimg; //商品图片
@property(nonatomic,copy)NSString *shopname; //商品名字
@property(nonatomic,copy)NSString *shopshuxing;//商品属性
@property(nonatomic,copy)NSString *shuliang; //数量
@property(nonatomic,copy)NSString *xinghao;//型号
@property(nonatomic,copy)NSString *yanse; //颜色

@property(nonatomic,copy)NSString *shouhuodizhi;//收货地址
@property(nonatomic,copy)NSString *shouhuoren;//收货人
@property(nonatomic,copy)NSString *tel;//电话
@property(nonatomic,copy)NSString *yingfujines; //应付金额
@property(nonatomic,copy)NSString *youhuiquanstatus; //优惠券状态
@property(nonatomic,copy)NSString *youhuis; //优惠
@property(nonatomic,copy)NSString *yuyuesongda;//预约送达时间
@property(nonatomic,copy)NSString *zhifufangshi;//支付方式
@property(nonatomic,copy)NSString *cretdate; //下单时间
@end
