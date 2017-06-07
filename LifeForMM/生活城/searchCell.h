//
//  searchCell.h
//  LifeForMM
//
//  Created by HUI on 15/12/29.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchOldPrcLb.h"
#import "searchGoodModel.h"
@interface searchCell : UITableViewCell
@property (nonatomic,retain) UIImageView *goodLogo;//商品图像
@property (nonatomic,retain) UILabel *goodName;//商品名称
@property (nonatomic,retain) UILabel *goodPric;//商品价格
@property (nonatomic,retain) searchOldPrcLb *goodOldPrice;//原价
@property (nonatomic,retain) searchGoodModel *secmodel;
@end
