//
//  addressCell.h
//  LifeForMM
//
//  Created by HUI on 16/1/12.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userAddressModel.h"
@class addressCell;
@protocol addressDelegate <NSObject>
@optional
-(void)addressCell:(addressCell *)adresCell tapIndex:(NSInteger)index;
@end
@interface addressCell : UITableViewCell
@property (nonatomic,copy)UILabel *nameLabel;//姓名
@property (nonatomic,copy)UIImageView *choseImage;//选择img
@property (nonatomic,copy)UILabel *numLabel;//电话号码
@property (nonatomic,copy)UILabel *adresslabel;//地址
@property (nonatomic,copy)UIImageView *delImage;//删除
@property (nonatomic,retain)userAddressModel *modl;
@property (nonatomic,weak)id <addressDelegate> delegate;
@end
