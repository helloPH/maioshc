//
//  MoreViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MoreViewController.h"
#import "Header.h"
#import "NewFunctionViewController.h"
#import "WXApiObject.h"
@interface MoreViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    UIImageView *qrcodeImage;//二维码
    UIView *maskView;//遮罩视图
}
@end

@implementation MoreViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    //初始化导航
    [self initNavigation];
    //初始化表格
    [self initTableView];
    //初始化表头
    [self tableHeadView];
    //初始化二维码
    [self initQrCodeView];
    //初始化遮罩
    [self initMaskView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"关于妙生活城";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(void)initTableView
{
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.backgroundColor= [UIColor whiteColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollEnabled = NO;
    [self.view addSubview:_table];
}
-(void)tableHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 185*MCscale)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*MCscale, 80*MCscale)];
    image.backgroundColor = [UIColor clearColor];
    image.image = [UIImage imageNamed:@"app_icon"];
    image.center = CGPointMake(kDeviceWidth/2.0, 60*MCscale);
    [headView addSubview:image];
    
    UILabel *version =[[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+10*MCscale, kDeviceWidth, 20*MCscale)];
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version.text = [NSString stringWithFormat:@"当前版本 %@",versionStr];
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont systemFontOfSize:MLwordFont_7];
    version.backgroundColor = [UIColor clearColor];
    [headView addSubview:version];
    _table.tableHeaderView = headView;
}
//初始化二维码视图
-(void)initQrCodeView
{
    qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth/6.0, 230*MCscale, kDeviceWidth*2.0/3, kDeviceWidth*2.0/3)];
    qrcodeImage.backgroundColor = [UIColor whiteColor];
    qrcodeImage.layer.cornerRadius = 15.0;
    qrcodeImage.layer.shadowRadius = 5.0;
    qrcodeImage.layer.shadowOpacity = 0.5;
    qrcodeImage.layer.shadowOffset = CGSizeMake(0, 0);
}
//初始化遮罩视图
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [maskView addGestureRecognizer:tap];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 15/MCscale, 20*MCscale, 20*MCscale)];
        image.backgroundColor = [UIColor clearColor];
        image.tag = 201;
        [cell addSubview:image];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(image.right+5*MCscale, 6/SCscale1, 180*MCscale, 40*MCscale)];
        title.tag = 202;
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:MLwordFont_3];
        title.textColor = txtColors(72, 73, 74, 1);
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-25*MCscale, 15/MCscale, 15*MCscale, 20*MCscale)];
        arrowImage.image = [UIImage imageNamed:@"下拉键"];
        arrowImage.backgroundColor = [UIColor clearColor];
        [cell addSubview:arrowImage];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *title = (UILabel *)[cell viewWithTag:202];
    UIImageView *image = (UIImageView *)[cell viewWithTag:201];
    if (indexPath.row == 0) {
        image.image = [UIImage imageNamed:@"二维码"];
        title.text = @"二维码";
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, cell.top, kDeviceWidth, 1)];
        line1.backgroundColor = lineColor;
        [cell.contentView addSubview:line1];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, cell.height +5*MCscale, kDeviceWidth-20*MCscale, 0.5)];
        line.backgroundColor = lineColor;
        [cell.contentView addSubview:line];
    }
    else if (indexPath.row == 1){
        image.image = [UIImage imageNamed:@"新"];
        title.text = @"新功能介绍";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, cell.height +5*MCscale, kDeviceWidth-20*MCscale, 0.5)];
        line.backgroundColor = lineColor;
        [cell.contentView addSubview:line];
        
    }
    else if (indexPath.row == 2){
        image.image = [UIImage imageNamed:@"分享-橘黄色"];
        title.text = @"分享给朋友";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, cell.height +5*MCscale, kDeviceWidth-20*MCscale, 0.5)];
        line.backgroundColor = lineColor;
        [cell.contentView addSubview:line];
        
    }
    else if (indexPath.row == 3){
        image.image = [UIImage imageNamed:@"评分-空心"];
        title.text = @"去评分";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height +5*MCscale, kDeviceWidth, 1)];
        line.backgroundColor = lineColor;
        [cell.contentView addSubview:line];
        
    }
    //    else if (indexPath.row == 4){
    //        image.image = [UIImage imageNamed:@"app_icon"];
    //        title.text = @"微支付";
    //
    //        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height +5*MCscale, kDeviceWidth, 1)];
    //        line.backgroundColor = lineColor;
    //        [cell.contentView addSubview:line];
    //
    //    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*MCscale;
}
-(void)btnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self qrCodeData];
    }
    else if (indexPath.row==1) {
        NewFunctionViewController *vc = [[NewFunctionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2){
        [self shareMessage];
    }
    else if (indexPath.row == 4){
        [self zhifuData];
    }
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stor_url]];
}
-(void)qrCodeData
{
    [HTTPTool getWithUrl:@"QRCodeUrl.action" params:nil success:^(id json) {
        if ([json valueForKey:@"erweima"]) {
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                qrcodeImage.alpha = 0.95;
                [self.view addSubview:maskView];
                [self.view addSubview:qrcodeImage];
            }];
            NSString *imgUrl = [json valueForKey:@"erweima"];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            MyLog(@"imgISze== %.lf %.lf",img.size.width,img.size.height);
            [qrcodeImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"网络连接错误";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//点击遮罩事件
-(void)tapAction
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        qrcodeImage.alpha = 0;
        [maskView removeFromSuperview];
        [qrcodeImage removeFromSuperview];
    }];
}
-(void)myTask
{
    sleep(1.5);
}
#pragma mark -- 分享
-(void)shareMessage
{
    [HTTPTool getWithUrl:@"fenxiangFriends.action" params:nil success:^(id json) {
        MyLog(@"-- json %@",json);
        NSDictionary *mesDic = (NSDictionary *)json;
        if (mesDic.count>0) {
            [self share:mesDic];
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"获取分享信息失败";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"获取分享信息失败";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)share:(NSDictionary *)shareDic
{
    NSString *shareImg = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"tubiao"]];
    MyLog(@"-- %@",shareImg);
    NSString *shareUrl = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"url"]];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImg]]];
    NSString *shareCont = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"wenzi"]];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"妙生活城"
                                       defaultContent:@"妙生活城"
                                                image:[ShareSDK pngImageWithImage:img]
                                                title:shareCont
                                                  url:shareUrl
                                          description:shareCont
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:_table arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess){
                                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    mbHud.mode = MBProgressHUDModeText;
                                    mbHud.labelText = @"分享成功";
                                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                }
                                else if (state == SSResponseStateFail){
                                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    mbHud.mode = MBProgressHUDModeText;
                                    mbHud.labelText = @"分享失败";
                                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                }
                            }];
}
-(void)zhifuData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"total_fee":@"1",@"shequid":userShequ_id,@"body":@"妙生活城",@"userid":user_id}];
    [HTTPTool postWithUrl:@"weixingfangwen.action" params:pram success:^(id json) {
        MyLog(@"%@",json);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dic setValue:[json valueForKey:@"dingdanhao"] forKey:@"dingdanhao"];
        [dic setValue:[json valueForKey:@"noncestr"] forKey:@"noncestr"];
        [dic setValue:[json valueForKey:@"package"] forKey:@"package"];
        [dic setValue:[json valueForKey:@"partnerid"] forKey:@"partnerid"];
        [dic setValue:[json valueForKey:@"prepayid"] forKey:@"prepayid"];
        [dic setValue:[json valueForKey:@"sign"] forKey:@"sign"];
        [dic setValue:[json valueForKey:@"timestamp"] forKey:@"timestamp"];
        [self wzf:dic];
    } failure:^(NSError *error) {
        MyLog(@"%@",error);
    }];
}
-(void)wzf:(NSDictionary *)dic
{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    if(dic != nil){
        NSMutableString *retcode = [dic objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dic objectForKey:@"partnerid"];
            req.prepayId            = [dic objectForKey:@"prepayid"];
            req.nonceStr            = [dic objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dic objectForKey:@"package"];
            req.sign                = [dic objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            MyLog(@"%@",[dic objectForKey:@"retmsg"]);
        }
    }
}
@end
