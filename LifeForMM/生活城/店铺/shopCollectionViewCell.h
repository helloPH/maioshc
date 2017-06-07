//
//  shopCollectionViewCell.h
//  LifeForMM
//
//  Created by HUI on 15/7/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGCenterLineLabel.h"
#import "shopModel.h"
@interface shopCollectionViewCell : UICollectionViewCell
@property(nonatomic,retain)UIImageView *goodImage;
@property(nonatomic,retain)UIImageView *shangbiao;
@property(nonatomic,retain)UILabel *goodTitle;
@property(nonatomic,retain)UILabel *nowPrice;
@property(nonatomic,retain)TGCenterLineLabel *oldPrice;
@property(nonatomic,retain)UIButton *goinShopCar;
@property(nonatomic,retain)shopModel *shModel;
@property(nonatomic,strong)UILabel *tishiLabel;//提示label

@end
