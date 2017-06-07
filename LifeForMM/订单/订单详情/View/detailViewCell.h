//
//  detailViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface detailViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *goodImage; //商品图片
@property(nonatomic,retain)UILabel *goodTitle,*price,*godNum;//商品名称 单价 数量
@property(nonatomic,retain)NSDictionary *detailDics;//数据字典
@property(nonatomic,retain)UILabel *xianghaoLab,*yanseL;//型号 颜色
@property(nonatomic,retain)UIView  *line;
@end
