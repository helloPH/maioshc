//
//  selfView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ShareRedPackView.h"

@implementation ShareRedPackView
{
    NSString *_danhao;
    NSString *_title;
    NSString *_imagePath;
    NSString *_dianpuId;
    NSString *_url;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-168)/2.0, 10*MCscale, 168*MCscale, 88*MCscale)];
    image.backgroundColor = [UIColor clearColor];
    image.image = [UIImage imageNamed:@"分享红包"];
    [self addSubview:image];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+10*MCscale, self.width, 40*MCscale)];
    title.text = @"恭喜获得10个红包";
    title.textColor = redTextColor;
    title.tag = 10110;
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:MLwordFont_1];
    [self addSubview:title];
    
    UILabel *subTil = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom, self.width, 20*MCscale)];
    subTil.text = @"分享给小伙伴,大家一起抢";
    subTil.textAlignment = NSTextAlignmentCenter;
    subTil.textColor = textBlackColor;
    subTil.font = [UIFont systemFontOfSize:MLwordFont_12];
    subTil.backgroundColor = [UIColor clearColor];
    [self addSubview:subTil];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-61*MCscale, self.width, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(self.width/2.0, line1.bottom, 1, 60*MCscale)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(1+self.width/2.0*i, line1.bottom, self.width/2.0-2, 60*MCscale);
        btn.backgroundColor = [UIColor clearColor];
        if (i==0) {
            [btn setTitle:@"分享红包" forState:UIControlStateNormal];
            [btn setTitleColor:redTextColor forState:UIControlStateNormal];
        }
        else{
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_12];
        btn.tag = i+200;
        [btn addTarget:self action:@selector(shareRedPack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
//分享红包
-(void)shareRedPack:(UIButton *)btn
{
    NSInteger index = btn.tag- 200;
    if ([self.shareRedPackDelegate respondsToSelector:@selector(reloadDataFromShareRedPackWithIndex:)]) {
        [self.shareRedPackDelegate reloadDataFromShareRedPackWithTag:index];
    }
    
    NSLog(@"%ld",index);
    
    if (index  == 0) {
        [self WxShare];
    }
    else
    {
    //(@"取消分享");
    }
    
}
-(void)loadDataWithDanhao:(NSString *)danhao AndTitle:(NSString *)title AndImage:(NSString *)imagePath AndUrl:(NSString *)url AndDianpuId:(NSString *)dianpuID
{
    _danhao = danhao;
    _title = title;
    _imagePath = imagePath;
    _dianpuId = dianpuID;
    _url = url;
}
-(void)WxShare
{
    [UIView animateWithDuration:0.3 animations:^{
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                           defaultContent:@"测试一下"
                                                    image:[ShareSDK imageWithUrl:_imagePath]
                                                    title:_title
                                                      url:_url
                                              description:_title
                                                mediaType:SSPublishContentMediaTypeNews];
        //弹出分享菜单
        [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                              container:nil
                                content:publishContent
                          statusBarTips:YES
                            authOptions:nil
                           shareOptions:nil
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     if (state == SSResponseStateSuccess){
                                         NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":_dianpuId,@"shequid":@"0",@"fenxiangstatus":@"1",@"danhao":_danhao}];
                                         [HTTPTool getWithUrl:@"fenxiang.action" params:pram success:^(id json) {
                                             if ([[json valueForKey:@"fenzuid"]integerValue]<0) {
                                                 if ([self.shareRedPackDelegate respondsToSelector:@selector(reloadDataFromShareRedPackWithIndex:)]) {
                                                     [self.shareRedPackDelegate reloadDataFromShareRedPackWithIndex:[[json valueForKey:@"fenzuid"]integerValue]];
                                                 }
                                             }
                                             else{
                                                 
                                                 if ([self.shareRedPackDelegate respondsToSelector:@selector(reloadDataFromShareRedPackWithIndex:)]) {
                                                     [self.shareRedPackDelegate reloadDataFromShareRedPackWithIndex:[[json valueForKey:@"fenzuid"]integerValue]];
                                                 }
                                             }
                                         } failure:^(NSError *error) {
                                             MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                                             bud.mode = MBProgressHUDModeCustomView;
                                             bud.labelText = @"网络连接错误";
                                             [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                         }];
                                     }
                                     else if (state == SSResponseStateFail){
                                         MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                                         mbHud.mode = MBProgressHUDModeText;
                                         mbHud.labelText = [error errorDescription];
                                         [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                     }
                                 }];
    }];
}
- (void)myTask {
    sleep(1.5);
}
@end
