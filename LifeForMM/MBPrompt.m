//
//  MBPrompt.m
//  LifeForMM
//
//  Created by HUI on 16/1/25.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MBPrompt.h"
#import "MBProgressHUD.h"
@implementation MBPrompt
+(void)requestWrong:(UIView *)view
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"网络连接错误";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
