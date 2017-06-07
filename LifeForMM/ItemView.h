//
//  ItemView.h
//  Movie
//
//  Created by Hui on 14-6-15.
//  Copyright (c) 2014年 www.skedu.com.cn北京尚德智远科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemView;
@protocol ItemViewDelegate <NSObject>

@optional
- (void)didItemView:(ItemView *)itemView atIndex:(NSInteger)index;

@end

@interface ItemView : UIView //用来自定义分栏项的 有图有字
{
@private
    UIImageView *_item;
    UILabel     *_title;
    id <ItemViewDelegate> _delegate;
}

@property (nonatomic, readonly) UIImageView *item;
@property (nonatomic, readonly) UILabel     *title;
@property (nonatomic, retain) id <ItemViewDelegate> delegate;
@end
