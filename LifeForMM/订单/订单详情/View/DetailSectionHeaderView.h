//
//  DetailSectionHeaderView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DetailSectionHeaderViewDelegate <NSObject>

-(void)gotoDianpuFirst;
@end

@interface DetailSectionHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str;
@property (nonatomic,strong)id<DetailSectionHeaderViewDelegate>headerDelegate;
@end
