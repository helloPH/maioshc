//
//  mainController.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
#import "FilePath.h"
@interface mainController : UITabBarController<ItemViewDelegate>
{
@private
    UIImageView *_tabBarBG;//分栏背景
    UIImageView *_selectView; //滑动视图
    NSInteger _lastIndex;
    
}
@property (nonatomic,assign) NSInteger itemIndexter;
@property (nonatomic,assign) NSInteger controlShowStyle;
//@property (nonatomic,assign)FilePath *file;//单利
-(void)didItemView:(ItemView *)itemView atIndex:(NSInteger)index;
+(id)sharUserContext;
- (void)showOrHiddenTabBarView:(BOOL)isHidden;
- (void)tabarNoEnable:(BOOL)isEnable;
@end