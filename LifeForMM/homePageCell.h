//
//  homePageCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopListModel.h"
@interface homePageCell : UITableViewCell
@property(nonatomic,retain)UIImageView *storeImage,*actionState,*renzhengImg;
@property(nonatomic,copy)UILabel *storeName,*address;
@property(nonatomic,copy)NSString *addressDetail,*storeNameString;
@property(nonatomic,retain)NSMutableArray *imageViewAry;
@property(nonatomic,retain)shopListModel *shopModel;
@property(nonatomic,retain)UILabel *yuyueMessage;//预约说明
@property (nonatomic,strong)UIView *line;//底部线
@end
