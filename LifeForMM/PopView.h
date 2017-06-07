//
//  PopView.h
//  LifeForMM
//
//  Created by HUI on 15/7/29.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopView;
@protocol PopViewDelegate <NSObject>

@optional
-(void)popBtnAction:(PopView *)pop atIndex:(NSInteger)index btnTag:(NSInteger )btag;

@end
@interface PopView : UIView
@property(nonatomic,retain)UIButton *popBtn;
@property(nonatomic,copy)NSString *btnTitle;
@property(nonatomic,weak)id <PopViewDelegate>delegate;
@end
