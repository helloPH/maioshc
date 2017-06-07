//
//  MainScrollView.m
//  PalmDoctor
//
//  Created by qichuang on 16/2/1.
//  Copyright © 2016年 qichuang. All rights reserved.
//

#import "MainScrollView.h"
#import "Header.h"
#define View_Width self.frame.size.width

#define View_Height self.frame.size.height

@implementation MainScrollView
{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    UIPageControl *_pageControl;
    
    NSArray *_array;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollViewWithFrame:frame];
        
        _array = [NSArray array];
        }
    return self;
}

//布局
-(void)createScrollViewWithFrame:(CGRect)frame
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, View_Width, View_Height)];
    
    //让Scrollview的偏移量在第二张
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    //滑动指示器
    //上下
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //左右
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    
    
    //pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(View_Width /2-25*MCscale, View_Height - 20*MCscale, 50*MCscale, 20*MCscale)];
    
    //被显示时的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    //不被显示时的颜色
    _pageControl.pageIndicatorTintColor = lineColor;
    
    [self addSubview:_pageControl];
}

//为scrollview添加图片
-(void)addImageViewForScrollViewWith:(NSArray *)array
{
    //更改Scrollview可]显示的大小
    _scrollView.contentSize = CGSizeMake(View_Width * array.count, View_Height);
    
    //pageControl的数量
    _pageControl.numberOfPages = array.count;
    
    //往scrollview上添加图片
    //将数组换成可变数组
    
    NSMutableArray *picArray = [NSMutableArray arrayWithArray:array];
    
    //循环创建imageView
    for (int i = 0; i < picArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(View_Width * i, 0, View_Width, View_Height)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
//        imageView.image = [UIImage imageNamed:picArray[i]];
        
        [_scrollView addSubview:imageView];
    }
    _array = array;
}

#pragma mark   UIScrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//只要偏移量发生变化 就会调用此方法
    //拿到在X方向上的偏移量
    float offset_X = scrollView.contentOffset.x;
    
    //得到当前显示的图片是第几张
    int page = offset_X/View_Width + 0.5;
    
    //设置pagecontrol显示哪一页
    _pageControl.currentPage = page;

}
@end
