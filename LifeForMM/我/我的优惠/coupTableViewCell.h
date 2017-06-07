//
//  coupTableViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myYouhModel.h"
@interface coupTableViewCell : UITableViewCell
@property (nonatomic,assign)NSInteger useDay;
@property (nonatomic,retain)UILabel *dataLabel,*limitLabel,*placelLbel,*telephoneLabel,*validity;
@property (nonatomic,retain)UIImageView *titImage;
@property (nonatomic,retain)myYouhModel *model;
@end
