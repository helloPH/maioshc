//
//  MainScrollView.h
//  PalmDoctor
//
//  Created by qichuang on 16/2/1.
//  Copyright © 2016年 qichuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScrollView : UIScrollView<UIScrollViewDelegate>

//为scrollview添加图片 
-(void)addImageViewForScrollViewWith:(NSArray *)array;

@end
