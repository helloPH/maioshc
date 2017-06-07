//
//  ShareRedPackView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 红包分享视图

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol ShareRedPackViewDelegate <NSObject>
-(void)reloadDataFromShareRedPackWithIndex:(NSInteger)index;
-(void)reloadDataFromShareRedPackWithTag:(NSInteger)tag;
@end
@interface ShareRedPackView : UIView
@property (nonatomic,strong)id<ShareRedPackViewDelegate>shareRedPackDelegate;

-(void)loadDataWithDanhao:(NSString *)danhao AndTitle:(NSString *)title AndImage:(NSString *)imagePath AndUrl:(NSString *)url AndDianpuId:(NSString *)dianpuID;

@end
