//
//  FilePath.m
//  QuickLookDemo
//
//  Created by administrator on 15/5/25.
//  Copyright (c) 2015年 yangjw . All rights reserved.
//

#import "FilePath.h"
static FilePath *segFilePath = nil;
@implementation FilePath
+(id)lastFilePath
{
    @synchronized(self)
    {
        if (segFilePath == nil) {
            segFilePath = [[[self class]alloc]init];
        }
    }
    return segFilePath;
}
#pragma mark - 下面的方法为了确保只有一个实例对象
//覆盖allocWithZone：方法
+(id)allocWithZone:(struct _NSZone *)zone
{
    if (segFilePath == nil) {
        segFilePath = [super allocWithZone:zone];
    }
    return segFilePath;
}
//实现copy协议、返回本身
-(id)copyWithZone:(NSZone *)zone
{
    return segFilePath;
}
@end
