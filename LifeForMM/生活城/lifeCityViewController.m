//
//  lifeCityViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/16.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "lifeCityViewController.h"
#import "Header.h"
#import "AdScrollView.h"
#import "locationViewController.h"
#import "searchViewController.h"
#import "RegisterViewController.h"
#import "UserAgreeViewController.h"
#import "shopListModel.h"
#import "headScrolImageModel.h"
#import "findPasViewController.h"
#import "UseDirectionViewController.h"
#import "shopController.h"
#import "UpdateTipView.h"
#import "LognPopView.h"
#import "GoodDetailViewController.h"
#import "AccountLoginView.h"
#import "PaomaView.h"
#import "ClassViewController.h"
#import "FamilyServiceViewController.h"
#import "ReductionViewController.h"
#import "SpecialViewController.h"
#import "MakeMoneyViewController.h"
#import "FuliViewController.h"
@interface lifeCityViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,updateTipDelegate,LognPopDeldgate,UIWebViewDelegate,AccountLoginViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,MakeMoneyViewControllerDelegate>
{
    UIView *headView;
    PaomaView *paomaview;
    LognPopView *loginView;//登陆弹框
    MaskView *maskView;//弹框遮罩
    UIView *mask,*bubbleMask;//输入遮罩
    BOOL isShow,isRefresh;
    NSInteger loadType;
    int pageNum,lastPage;
    NSMutableArray *scroImageAry;//轮播数据
    UIImageView *giftImageView;
    NSInteger gitGoin;//标记新人礼加入视图次数
    NSMutableArray *hongbaoAry;//红包返回数据
    AdScrollView *scrollView;
    NSMutableArray *allDataAry; //所有数据
    UpdateTipView *updatePop;//更新提示弹框
    UIView *updateBackgroundView;//更新背景
    NSString *sysLevel,*descripton;//更新等级 更新说明
    BOOL isBotom;
    //网页视图
    UIWebView * webview;
    AccountLoginView *accounView;
    UIView *titleView;
    UILabel *shequNameLabel;
    UIView *leftView;
    UILabel *leftLabel;
    UIView *rightView;
    UIImageView  *huImageView;
    UIImageView *bubbleView;
    NSString *paixu;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_codeSearch;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    BOOL isPaixu;
    NSString *latit;
    NSString *longit;
    CLLocation *sloccation;
    CLGeocoder *geocoder;
    NSMutableArray *addressNameArray;
}
@end
@implementation lifeCityViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginPopView) name:@"userWillLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeShequName) name:@"resetTitle" object:nil];
    [self initData];
    if (userLastAddress) {
        leftLabel.text = [NSString stringWithFormat:@"%@",userLastAddress];
        NSString *xingStr =[NSString stringWithFormat:@"%@",leftLabel.text];
        CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(150*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        leftLabel.frame = CGRectMake(33*MCscale, 0, xinSzie.width+6*MCscale, 30*MCscale);
        leftView.frame = CGRectMake(15*MCscale,25*MCscale, leftLabel.width + 40*MCscale, 30*MCscale);

    }
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    isShow = 0;
    scroImageAry = [[NSMutableArray alloc]init];
    allDataAry = [NSMutableArray arrayWithCapacity:0];
    addressNameArray = [NSMutableArray arrayWithCapacity:0];
    gitGoin = 0;
    pageNum = 1;
    isRefresh =0;
    isBotom = 1;
    isPaixu = 1;
    paixu = @"0";
    latit =@"";
    longit = @"";
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = 5;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    [self performSelector:@selector(delay) withObject:self afterDelay:0.1];
    [self getGonggaoData];
    [self getUpdateData];
    [self initNavigation];
    [self loadTableView];
    [self initNavigation];
    [self initHeadView];
    [self initScroViewData];
    [self initMask];
    [self initBubbleMask];
    [self newPersongGift];
    [self refresh];
    [self BackgroundDataAcquisition];
}
//获取后台版本(版本更新有关)
-(void)getUpdateData
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"banbenhao":appCurVersionNum,@"xitong":@"2"}];
    
    [HTTPTool getWithUrl:@"banbenNew.action" params:pram success:^(id json) {
        
        NSLog(@"-- message %@",json);
        NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"3"]) {
            sysLevel = [NSString stringWithFormat:@"%@",[json valueForKey:@"jibie"]];
            descripton = [NSString stringWithFormat:@"%@",[json valueForKey:@"shuoming"]];
            [self initUpdateTipView];
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark -- tipView
-(void)initUpdateTipView
{
    updateBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    updateBackgroundView.backgroundColor = [UIColor clearColor];
    updatePop = [[UpdateTipView alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 320*MCscale)];
    updatePop.delegate = self;
    NSArray *descripAry = [descripton componentsSeparatedByString:@"#"];
    updatePop.alpha = 0.95;
    NSString *decStr = @"";
    for (int i = 0; i<descripAry.count; i++) {
        if (i==0) {
            decStr = [NSString stringWithFormat:@"%@\n",descripAry[i]];
        }
        else
            decStr = [NSString stringWithFormat:@"%@%@\n",decStr,descripAry[i]];
    }
    NSString *ss = [NSString stringWithFormat:@"%@",decStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5*MCscale;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:MLwordFont_3],NSParagraphStyleAttributeName:paragraphStyle};
    updatePop.txtView.attributedText = [[NSAttributedString alloc]initWithString:ss attributes:attributes];
    mainController *main = (mainController *)self.tabBarController;
    [main tabarNoEnable:0];
    [self.view addSubview:updateBackgroundView];
    [self.view addSubview:updatePop];
}
#pragma mark --更新类代理方法
-(void)updateTip:(UpdateTipView *)updateView tapIndex:(NSInteger)index
{
    MyLog(@"index btnTag %ld",(long)index);
    mainController *main = (mainController *)self.tabBarController;
    [main tabarNoEnable:1];
    if (index == 102) {
        if ([sysLevel isEqualToString:@"1"]) {
            exit(0);
        }
        else{
            [updateBackgroundView removeFromSuperview];
            [updatePop removeFromSuperview];
        }
    }
    else if (index == 101){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stor_url]];
    }
}
-(void)changeShequName
{
    shequNameLabel.text = userShequ_Name;
}
//初始化导航栏
-(void)initNavigation
{
    //定位视图
    leftView = [[UIView alloc]init];
    leftView.backgroundColor = lineColor;
    leftView.layer.cornerRadius = 15*MCscale;
    leftView.layer.masksToBounds = YES;
    leftView.alpha = 0.75;
    [self.view addSubview:leftView];
    UITapGestureRecognizer *leftViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NaviViewTapClick:)];
    [leftView addGestureRecognizer:leftViewTap];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(5*MCscale, 2*MCscale, 25*MCscale, 25*MCscale)];
    leftImage.image = [UIImage imageNamed:@"定位"];
    [leftView addSubview:leftImage];
    leftLabel = [[UILabel alloc]init];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:leftLabel];
    
    //搜索视图
    rightView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth-120*MCscale,25*MCscale, 100*MCscale, 30*MCscale)];
    rightView.backgroundColor = lineColor;
    rightView.layer.cornerRadius = 15*MCscale;
    rightView.layer.masksToBounds = YES;
    rightView.alpha = 0.75;
    [self.view addSubview:rightView];
    UITapGestureRecognizer *rightViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NaviViewTapClick:)];
    [rightView addGestureRecognizer:rightViewTap];
    
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(rightView.width-40*MCscale, 2*MCscale, 25*MCscale, 25*MCscale)];
    rightImage.image = [UIImage imageNamed:@"搜索"];
    [rightView addSubview:rightImage];
    
    //按钮视图
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,80*MCscale)];
    titleView.backgroundColor = txtColors(230, 230, 230, 0.75);
    titleView.alpha = 0.95;
    titleView.hidden = YES;
    [self.view addSubview:titleView];
    
    shequNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,20, kDeviceWidth, 30*MCscale)];
    shequNameLabel.text = userShequ_Name;
    shequNameLabel.textAlignment = NSTextAlignmentCenter;
    shequNameLabel.textColor = txtColors(114, 185, 170, 1);
    shequNameLabel.backgroundColor = [UIColor clearColor];
    shequNameLabel.alpha = 0.95;
    shequNameLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_3];
    [titleView addSubview:shequNameLabel];
    
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, shequNameLabel.bottom, kDeviceWidth, 30*MCscale)];
    btnBackView.alpha = 0.95;
    btnBackView.backgroundColor = lineColor;
    [titleView addSubview:btnBackView];
    
    NSArray *btnArray = @[@"综合排序",@"销量最高",@"距离最近"];
    CGFloat btnWidth = kDeviceWidth/3.0;
    for (int i= 0; i < btnArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnWidth*i , 0, btnWidth, 30*MCscale);
        [button setTitle:btnArray[i] forState:UIControlStateNormal];
        [button setTitleColor:textColors forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"上拉键"] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(6*MCscale,btnWidth-30*MCscale,6*MCscale,15*MCscale);
            button.titleEdgeInsets = UIEdgeInsetsMake(0,-10*MCscale,0,30*MCscale);
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 0.95;
        button.tag = 100+i;
        [btnBackView addSubview:button];
    }
    
    bubbleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, btnBackView.bottom, btnWidth, 220*MCscale)];
    bubbleView.backgroundColor = [UIColor clearColor];
    bubbleView.userInteractionEnabled = YES;
    bubbleView.image = [UIImage imageNamed:@"排序"];
    
    NSArray *titleArray = @[@"综合排序",@"速度最快",@"评分最高",@"起送价最低"];
    NSArray *imageArrays = @[@"综合排序",@"速度最快",@"评价最高",@"起送价最低"];
    for (int i= 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*MCscale ,50*i+13*MCscale, btnWidth-20*MCscale, 50*MCscale);
        [button setImage:[UIImage imageNamed:imageArrays[i]] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(16*MCscale,10*MCscale,16*MCscale,btnWidth-20*MCscale-25*MCscale);
        button.titleEdgeInsets = UIEdgeInsetsMake(0,-10*MCscale,0,0);
        [button setTitleColor:textColors forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        button.tag = 500+i;
        [bubbleView addSubview:button];
        if (i<3) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, button.bottom, bubbleView.width - 20*MCscale, 1)];
            line.backgroundColor = lineColor;
            [bubbleView addSubview:line];
        }
    }
}
-(void)NaviViewTapClick:(UITapGestureRecognizer *)tap
{
    if (tap.view == leftView) {
        locationViewController *loca = [[locationViewController alloc]init];
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:loca animated:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
    else
    {
        searchViewController *search = [[searchViewController alloc]init];
        search.viewTag = 1;
        [self.navigationController pushViewController:search animated:YES];
    }
}
-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        [UIView animateWithDuration:0.3 animations:^{
            bubbleMask.alpha = 1;
            [self .view addSubview:bubbleMask];
            bubbleView.alpha = 0.95;
            [self.view addSubview:bubbleView];
        }];
    }
    else if(sender.tag == 102)
    {
        isRefresh = 1;
        loadType = 0;
        lastPage = 1;
        pageNum = 1;
        isPaixu = 0;
        paixu = @"5";
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,将由系统为您匹配社区" preferredStyle:1];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }   [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addAction:suerAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [_locService startUserLocationService];
        }
    }
    else
    {
        isRefresh = 1;
        loadType = 0;
        lastPage = 1;
        pageNum = 1;
        if (sender.tag == 101) {
            paixu = @"4";
        }
        else
        {
            NSUInteger index = sender.tag - 500;
            paixu = [NSString stringWithFormat:@"%ld",(long)index];
            [self bubbleMaskDismiss];
        }
        [allDataAry removeAllObjects];
        [self initData];
    }
}
-(void)delay
{
    _codeSearch =[[BMKGeoCodeSearch alloc]init];
    _codeSearch.delegate = self;
}
#pragma mark 实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (isPaixu) {
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude] forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude] forKey:@"longitude"];
        NSLog(@"%f  %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        //发起反向地理编码检索
        reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_codeSearch reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }
    else
    {
        latit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
        longit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
        [_locService stopUserLocationService];
        [allDataAry removeAllObjects];
        [self initData];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_locService stopUserLocationService];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKPoiInfo* poi = [result.poiList objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setValue:poi.name forKey:@"addressName"];
        leftLabel.text = userLastAddress;
        NSString *xingStr =[NSString stringWithFormat:@"%@",userLastAddress];
        CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(150*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        leftLabel.frame = CGRectMake(33*MCscale, 0, xinSzie.width+6*MCscale, 30*MCscale);
        leftView.frame=CGRectMake(15*MCscale,25*MCscale, leftLabel.width + 40*MCscale, 30*MCscale);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark 获取公告
-(void)getGonggaoData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyguanggao.action" params:pram success:^(id json) {
        NSLog(@"公告 %@",json);
        paomaview = [[PaomaView alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0 + 25*MCscale, 20*MCscale, 180*MCscale, 20*MCscale) AndText:[NSString stringWithFormat:@"%@",[json valueForKey:@"gonggao"]]];
        [huImageView addSubview:paomaview];
        
    } failure:^(NSError *error) {
        [self requestNetworkWrong:@"网络连接错误6"];
    }];
}
#pragma mark -- 列表数据
-(void)initData
{
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //解析当前返回的数据
        NSMutableDictionary *pram;
        if ([paixu isEqualToString:@"5"]) {
            pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"leixing":@"0",@"paixu":paixu,@"x":longit,@"y":latit}];
        }
        else
        {
            pram  = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"leixing":@"0",@"paixu":paixu}];
        }
        [HTTPTool getWithUrl:@"findByShequid5.action" params:pram success:^(id json) {
            [dbud hide:YES];
            if (isRefresh) {
                [self endRefresh:loadType];
            }
            if (lastPage == pageNum) {
                [allDataAry removeAllObjects];
            }
            lastPage = pageNum;
            NSLog(@"所有店铺 %@",json);
            
            if(![json valueForKey:@"massages"]){
                NSDictionary *dict = (NSDictionary *)json;
                NSArray *ary = [dict valueForKey:@"dianpushuju"];
                if (ary.count >0) {
                    isBotom = 0;
                    [self loadFootView];
                    for(NSDictionary *dic in ary){
                        shopListModel *mode= [[shopListModel alloc]initWithContent:dic];
                        [allDataAry addObject:mode];
                    }
                    NSString *isXinrenli = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isXinrenli"]];
                    NSString *newgift = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"xinrenli"]];
                    NSString * xrlTapNum=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"xrlTapNum"]];
                    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
                    if ([sdf integerForKey:@"isLogin"]== 1) {
                        if (gitGoin <2){
                            if ([newgift isEqualToString:@"0"]) {
                                if ([xrlTapNum integerValue]<2) {
                                    if ( [isXinrenli isEqualToString:@"1"]) {
                                        [self.view addSubview:giftImageView];
                                        //                                    [self.view insertSubview:updatePop belowSubview:giftImageView];
                                        [self.view bringSubviewToFront:updatePop];
                                        [self.view bringSubviewToFront:loginView];
                                        gitGoin =1;
                                    }
                                    else
                                        [giftImageView removeFromSuperview];
                                }
                                else
                                    [giftImageView removeFromSuperview];
                            }
                            else
                                [giftImageView removeFromSuperview];
                        }
                        else
                            [giftImageView removeFromSuperview];
                    }
                    else
                    {
                        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequid":userShequ_id}];
                        [HTTPTool getWithUrl:@"shequXinrenli.action" params:pram success:^(id json) {
                            MyLog(@"%@",json);
                            [[NSUserDefaults standardUserDefaults]  setValue:[json valueForKey:@"xinrenli"] forKey:@"isXinrenli"];
                            NSString *isXinrenli = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isXinrenli"]];
                            if (gitGoin <2){
                                if ([isXinrenli integerValue] == 1) {
                                    if ([xrlTapNum integerValue]<2) {
                                        [self.view addSubview:giftImageView];
                                        //                                    [self.view insertSubview:updatePop belowSubview:giftImageView];
                                        [self.view bringSubviewToFront:updatePop];
                                        [self.view bringSubviewToFront:loginView];
                                        gitGoin =1;
                                    }
                                    else
                                        [giftImageView removeFromSuperview];
                                }
                                else
                                    [giftImageView removeFromSuperview];
                            }
                            else
                                [giftImageView removeFromSuperview];
                        }
                                     failure:^(NSError *error) {
                                     }];
                    }
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        [_mainTableView reloadData];
                        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
                    });
                }
                else{
                    if (lastPage == 1) {
                        //通知主线程刷新
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //回调或者说是通知主线程刷新，
                            [_mainTableView reloadData];
                            isBotom = 1;
                            [self loadFootView];
                            _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页"]];
                        });
                    }
                    else
                    {
                        //通知主线程刷新
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //回调或者说是通知主线程刷新，
                            isBotom = 1;
                            [self loadFootView];
                            [_mainTableView reloadData];
                            _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
                        });
                    }
                }
            }
            else{
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [_mainTableView reloadData];
                    _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页"]];
                });
            }
        } failure:^(NSError *error) {
            [self endRefresh:loadType];
            [dbud hide:YES];
            [self requestNetworkWrong:@"网络连接错误1"];
        }];
    });
}
#pragma mark -- 轮播请求数据
-(void)initScroViewData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id}];
    [HTTPTool getWithUrl:@"imageHead3.action" params:pram success:^(id json) {
        NSArray *imary = [json valueForKey:@"listImage"];
        MyLog(@"-+++- json %@",json);
        if (imary.count>0) {
            for(NSDictionary *dic in imary){
                headScrolImageModel *scroModel = [[headScrolImageModel alloc]initWithContent:dic];
                [scroImageAry addObject:scroModel];
            }
        }
        [self refrashHeadScrolData];
    } failure:^(NSError *error) {
        [self requestNetworkWrong:@"网络连接错误3"];
    }];
}
//新人礼
-(void)newPersongGift
{
    giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/2.0, kDeviceWidth/2.0)];
    giftImageView.backgroundColor = [UIColor clearColor];
    giftImageView.userInteractionEnabled = YES;
    giftImageView.center = CGPointMake(kDeviceWidth*2/5.0+kDeviceWidth/4.0, kDeviceHeight*5/9.0+100);
    giftImageView.image= [UIImage imageNamed:@"新人礼"];
    giftImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newPosenAction:)];
    [giftImageView addGestureRecognizer:tap];
}
-(void)loadTableView
{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainTableView];
}
-(void)initHeadView
{
    headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    [self initScrollView];
    CGFloat huHeiht;
    if (IPHONE_Plus) {
        huHeiht = 217;
    }
    else if (IPHONE_5){
        huHeiht = 197;
    }
    else{
        huHeiht = 207;
    }
    huImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, huHeiht, kDeviceWidth, 50*MCscale)];
    huImageView.image = [UIImage imageNamed:@"tuoyuan"];
    huImageView.userInteractionEnabled = YES;
    [headView addSubview:huImageView];
    [huImageView bringSubviewToFront:headView];
    
    UIImageView *labaImage = [[UIImageView alloc]initWithFrame:CGRectMake(huImageView.width /4.0, 20*MCscale, 20*MCscale, 20*MCscale)];
    labaImage.image = [UIImage imageNamed:@"laba"];
    [huImageView addSubview:labaImage];
    
    UIView *buttonViews = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 80)];
    buttonViews.backgroundColor = [UIColor whiteColor];
    if (IPHONE_Plus) {
        headView.frame = CGRectMake(0, 0, kDeviceWidth, 485);
        buttonViews.frame = CGRectMake(0, 269, kDeviceWidth, 80);
    }
    else if (IPHONE_5){
        headView.frame = CGRectMake(0, 0, kDeviceWidth, 465);
        buttonViews.frame = CGRectMake(0, 244, kDeviceWidth, 80);
    }
    else{
        headView.frame = CGRectMake(0, 0, kDeviceWidth, 475);
        buttonViews.frame = CGRectMake(0,259, kDeviceWidth, 80);
    }
    NSArray *btnImageArray = @[@"餐饮",@"便利服务",@"商超服务",@"社区其他"];
    NSArray *btnTitleArray = @[@"美食佳饮",@"果蔬生鲜",@"商超便利",@"家庭服务"];
    
    for (int j= 0; j<4; j++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(listDataType:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+j;
        [btn setImage:[UIImage imageNamed:btnImageArray[j]] forState:UIControlStateNormal];
        [buttonViews addSubview:btn];
        UILabel *btnTitle = [[UILabel alloc]init];
        btnTitle.backgroundColor = [UIColor clearColor];
        btnTitle.text = btnTitleArray[j];
        btnTitle.textColor = txtColors(25, 26, 27, 1);
        btnTitle.textAlignment = NSTextAlignmentCenter;
        btnTitle.font = [UIFont systemFontOfSize:MLwordFont_8];
        [buttonViews addSubview:btnTitle];
        if (IPHONE_Plus){
            btn.frame = CGRectMake(52+50*j+j*38, 5, 50, 50);
            btnTitle.frame = CGRectMake(47+60*j+j*27.5, 58, 60, 20);
        }
        else if(IPHONE_5){
            btn.frame = CGRectMake(30+50*j+j*20, 5, 50, 50);
            btnTitle.frame = CGRectMake(25+60*j+j*10, 58, 60, 20);
        }
        else{
            btn.frame = CGRectMake(32+50*j+j*38, 5, 50, 50);
            btnTitle.frame = CGRectMake(27+60*j+j*27.5, 58, 60, 20);
        }
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 85*MCscale, kDeviceWidth,5*MCscale)];
    line.backgroundColor = txtColors(241, 241, 241, 1);
    [buttonViews addSubview:line];
    [headView addSubview:buttonViews];
    
    UIView *imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, buttonViews.bottom+10*MCscale, kDeviceWidth, 100*MCscale)];
    imageBackView.backgroundColor = txtColors(241, 241, 241, 1);
    [headView addSubview:imageBackView];
    
    NSArray *imageArray = @[@"1",@"2",@"3",@"4"];
    CGFloat imageWidth = (headView.width-2)/2;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth+2)*i,(50+2)*j*MCscale, imageWidth, 50*MCscale)];
            image.image = [UIImage imageNamed:imageArray[j*2+i]];
            image.backgroundColor = [UIColor clearColor];
            image.userInteractionEnabled = YES;
            image.tag = 10000+j*2+i;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
            [image addGestureRecognizer:imageTap];
            [imageBackView addSubview:image];
        }
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,imageBackView.bottom, kDeviceWidth,5)];
    lineView.backgroundColor = txtColors(241, 241, 241, 1);
    [headView addSubview:lineView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,lineView.bottom+3*MCscale,kDeviceWidth,30*MCscale)];
    backView.backgroundColor = [UIColor clearColor];
    [headView addSubview:backView];
    
    UILabel *fenleiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 70*MCscale, 20*MCscale)];
    fenleiLabel.center = CGPointMake(backView.width/2.0, 15*MCscale);
    fenleiLabel.textAlignment = NSTextAlignmentCenter;
    fenleiLabel.text = @"附近店铺";
    fenleiLabel.textColor = txtColors(173, 173, 173, 1);
    fenleiLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [backView addSubview:fenleiLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(70*MCscale,15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5)];
    line1.backgroundColor = txtColors(173, 173, 173, 1);
    [backView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(fenleiLabel.right +10*MCscale, 15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5)];
    line2.backgroundColor = txtColors(173, 173, 173, 1);
    [backView addSubview:line2];
    _mainTableView.tableHeaderView = headView;
}
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 10000)
    {
        SpecialViewController *SpecialVC = [[SpecialViewController alloc]init];
        [self.navigationController pushViewController:SpecialVC animated:YES];
    }
    else if (tap.view.tag == 10001)
    {
        MakeMoneyViewController *MoneyVC = [[MakeMoneyViewController alloc]init];
        MoneyVC.moneyDelegate = self;
        [self.navigationController pushViewController:MoneyVC animated:YES];
    }
    else if (tap.view.tag == 10002) {
        ReductionViewController *ReductionVC = [[ReductionViewController alloc]init];
        [self.navigationController pushViewController:ReductionVC animated:YES];
    }
    else
    {
        FuliViewController *fuliVC = [[FuliViewController alloc]init];
        [self.navigationController pushViewController:fuliVC animated:YES];
    }
}

#pragma mark MakeMoneyViewControllerDelegate
-(void)gotoLogin
{
    [self loginPopView];
}
-(void)initScrollView
{
    CGFloat scroHeigh;
    if (IPHONE_Plus){
        scroHeigh = 267.0;
    }
    else if (IPHONE_5){
        scroHeigh = 242.0;
    }
    else{
        scroHeigh = 257.0;
    }
    scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, scroHeigh)];
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for(NSString *str in scroImageAry){
        [ary addObject:str];
    }
    scrollView.imageNameArray = ary;
    scrollView.contentSize = CGSizeMake(kDeviceWidth*4, scroHeigh);
    //    scrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    //    scrollView.pageControl.pageIndicatorTintColor = txtColors(211, 206, 207, 1);
    //    scrollView.pageControl.currentPageIndicatorTintColor = txtColors(29, 126, 252, 1);
    scrollView.showsHorizontalScrollIndicator = NO;
    [headView addSubview:scrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scroTapAction)];
    [scrollView addGestureRecognizer:tap];
}
-(void)scroTapAction
{
    NSLog(@"-- %ld",(long)scrollView.pageControl.currentPage);
    NSInteger index = scrollView.pageControl.currentPage;
    if (scroImageAry.count>0) {
        headScrolImageModel *model = scroImageAry[index];
        NSString *shuxing = [NSString stringWithFormat:@"%@",model.shuxing];
        NSString *pipeiid = [NSString stringWithFormat:@"%@",model.pipeiid];
        if (![shuxing isEqualToString:@"0"]) {
            if ([shuxing isEqualToString:@"1"]) {
                //跳商品详情
                NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shopid":pipeiid}];
                [HTTPTool getWithUrl:@"clickShop.action" params:pram success:^(id json) {
                    NSString *dpid = [json valueForKey:@"dianpuid"];
                    NSString *sqid = [json valueForKey:@"shequid"];
                    NSString *th = [NSString stringWithFormat:@"%@",[json valueForKey:@"tehui"]];
                    GoodDetailViewController *gvc = [[GoodDetailViewController alloc]init];
                    gvc.goodId = pipeiid;
                    gvc.dianpuId = dpid;
                    gvc.godShequid = sqid;
                    if ([th isEqualToString:@"1"]) {
                        NSString *tehui = [NSString stringWithFormat:@"%@images/shangpin/biaoqian/tehui.png",HTTPWeb];
                        gvc.goodtag = tehui;
                    }
                    else{
                        gvc.goodtag = @"1";
                    }
                    [self.navigationController pushViewController:gvc animated:YES];
                } failure:^(NSError *error) {
                }];
            }
            else{
                //跳转店铺
                NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dpid":pipeiid}];
                [HTTPTool getWithUrl:@"clickDianpu.action" params:pram success:^(id json) {
                    NSString *dpName = [json valueForKey:@"dianpuname"];
                    NSString *topHong = [json valueForKey:@"huodong"];
                    shopController *svc = [[shopController alloc]init];
                    svc.shopId = pipeiid;
                    svc.shopName = dpName;
                    svc.isHuodong = topHong;
                    svc.isReset = 0;
                    [self.navigationController pushViewController:svc animated:YES];
                } failure:^(NSError *error) {
                }];
            }
        }
    }
}
-(void)refrashHeadScrolData
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i<scroImageAry.count; i++) {
        headScrolImageModel *model = scroImageAry[i];
        NSString *str = [NSString stringWithFormat:@"%@",model.imageurl];
        [ary addObject:str];
    }
    scrollView.imageNameArray = ary;
}

#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (allDataAry.count !=0) {
        return allDataAry.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    homePageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[homePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (allDataAry.count !=0) {
        cell.shopModel = allDataAry[indexPath.row];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f",velocity.y);
    if (velocity.y < 0.0)
    {
        titleView.hidden = YES;
        //向下滑动隐藏导航栏
        leftView.hidden = NO;
        rightView.hidden = NO;
        _mainTableView.frame = CGRectMake(0,0, kDeviceWidth, kDeviceHeight-49*MCscale);

    }else
    {
        
        leftView.hidden = YES;
        rightView.hidden = YES;
        titleView.hidden = NO;
        _mainTableView.frame = CGRectMake(0, 20*MCscale, kDeviceWidth, kDeviceHeight - 20*MCscale-49*MCscale);
    }
}

-(void)moreShopTap:(UITapGestureRecognizer *)tap
{
    [_mainTableView reloadData];
    _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
}

-(void)listDataType:(UIButton *)btn
{
    if (btn.tag - 99 == 4) {
        FamilyServiceViewController *familyVC = [[FamilyServiceViewController alloc]init];
        [self.navigationController pushViewController:familyVC animated:YES];
    }
    else
    {
        ClassViewController *classVC = [[ClassViewController alloc]init];
        classVC.viewTag = btn.tag - 99;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    shopController *shop = [[shopController alloc]init];
    if(allDataAry.count >0){
        shopListModel *model = allDataAry[indexPath.row];
        shop.shopId = model.shopId;
        shop.shopName = model.dianpuname;
        NSString *shopState = [NSString stringWithFormat:@"%@",model.zhuangtaipaihu];
        if ([shopState isEqualToString:@"3"]) {
            shop.isReset = 1;
        }
        else
            shop.isReset = 0;
        shop.isHuodong = [NSString stringWithFormat:@"%@",model.isHuodong];
        [self.navigationController pushViewController:shop animated:YES];
    }
}
//遮罩视图
-(void)initMaskView
{
    maskView = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [maskView addGestureRecognizer:tap];
    [self.view addSubview:maskView];
}

//隐藏遮罩
-(void)maskDisMiss
{
    isShow = 0;
    NSInteger userLogin = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLogin"];
    if (userLogin == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isLogin"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        loginView.alpha = 0;
        [self.view endEditing:YES];
        [loginView removeFromSuperview];
    }];
    NSNotification *timerStop = [NSNotification notificationWithName:@"timerStop" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerStop" object:nil];
}
-(void)loginPopView
{
    if (isShow ==0) {
        isShow = 1;
        [self initMaskView];
        [self initPopView];
    }
}
#pragma mark -- 登录弹框
-(void)initPopView
{
    loginView = [[LognPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 150*MCscale, kDeviceWidth*9/10.0, 350*MCscale)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    [self.view bringSubviewToFront:loginView];
    if (userPass_pas && userName_tel){
        loginView.remainLabel.alpha = 1;
        //        [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
    }
}
#pragma mark -- LognPopDelegate
-(void)lognPopView:(LognPopView *)lognPop btnIndex:(NSInteger)index
{
    if (index == 108){
        [self dismissPass];//忘记密码
    }
    else if (index == 111){
        [self userAgreement];//用户协议
    }
    else if (index == 113){
        [self regeisterAction]; //注册
    }
}

-(void)loginSuccessWithDict:(NSDictionary *)dict
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeCustomView;
    mbHud.labelText = @"登录成功";
    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    isShow = 0;
    NSString *newgift = [NSString stringWithFormat:@"%@",[dict valueForKey:@"xinrenli"]];
    NSString *isXinrenli = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isXinrenli"]];
    MyLog(@"%@%@",newgift,isXinrenli);
    if ([newgift isEqualToString:@"0"]) {
        if ([isXinrenli isEqualToString:@"1"]) {
            [self.view addSubview:giftImageView];
        }
        else
            [giftImageView removeFromSuperview];
    }
    else
        [giftImageView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        loginView.alpha = 0;
        [self.view endEditing:YES];
        [loginView removeFromSuperview];
    }];
}

-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mask addGestureRecognizer:tap];
}

-(void)initBubbleMask
{
    bubbleMask = [[UIView alloc]initWithFrame:self.view.bounds];
    bubbleMask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleMaskDismiss)];
    [bubbleMask addGestureRecognizer:tap];
}
//注册BtnAction
-(void)regeisterAction
{
    [self lognViewDis];
    RegisterViewController *regis = [[RegisterViewController alloc]init];
    regis.isInvite = NO;
    [self.navigationController pushViewController:regis animated:YES];
    
    NSNotification *timerStop = [NSNotification notificationWithName:@"timerStop" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerStop" object:nil];
}
//忘记密码
-(void)dismissPass
{
    [self lognViewDis];
    findPasViewController *finPasVc = [[findPasViewController alloc]init];
    [self.navigationController pushViewController:finPasVc animated:YES];
    NSNotification *timerStop = [NSNotification notificationWithName:@"timerStop" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerStop" object:nil];
}
//跳转隐藏登录框
-(void)lognViewDis
{
    isShow = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        loginView.alpha = 0;
        [loginView removeFromSuperview];
        //        loginView.seconds = 5;
    }];
}
-(void)userAgreement
{
    NSNotification *timerStop = [NSNotification notificationWithName:@"timerStop" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerStop" object:nil];
    [self lognViewDis];
    UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
    agr.pageUrl = [NSString stringWithFormat:@"%@gonggao/yonghuxieyi.jsp",HTTPHEADER];
    agr.titStr = @"妙生活城平台用户协议";
    [self.navigationController pushViewController:agr animated:YES];
}
//检测是否登录
-(void)newPosenAction:(UITapGestureRecognizer *)tap
{
    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
    if (userName_tel && userPass_pas) {
        if ([sdf integerForKey:@"isLogin"]==0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录后才能领取新人礼" preferredStyle:1];
            UIAlertAction *surerAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [giftImageView removeFromSuperview];
                [self loginPopView];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃新人礼" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [giftImageView removeFromSuperview];
                gitGoin = 2;
            }];
            [alert addAction:surerAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [giftImageView removeFromSuperview];
            [self receiveNewGift];
        }
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录后才能领取新人礼" preferredStyle:1];
        UIAlertAction *surerAction = [UIAlertAction actionWithTitle:@"去注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [giftImageView removeFromSuperview];
            RegisterViewController *regis = [[RegisterViewController alloc]init];
            regis.isInvite = NO;
            [self.navigationController pushViewController:regis animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃新人礼" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [giftImageView removeFromSuperview];
            gitGoin = 2;
        }];
        [alert addAction:surerAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//新人礼
-(void)receiveNewGift
{
    [giftImageView removeFromSuperview];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":@"0",@"shequid":userShequ_id,@"hongbaotype":@"0"}];
    
    [HTTPTool postWithUrl:@"fahongbao.action" params:pram success:^(id json) {
        if(![json valueForKey:@"message"]){
            NSArray *ary = [json valueForKey:@"fahongbao"];
            NSDictionary *dic = ary[0];
            NSString *urll= [NSString stringWithFormat:@"%@",[dic valueForKey:@"hongbaourl"]];
            NSString *imagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"imgurl"]];
            NSString *hongMessage = [dic valueForKey:@"shuoming"];
            [UIView animateWithDuration:0.3 animations:^{
                //构造分享内容
                id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                                   defaultContent:@"妙生活城"
                                                            image:[ShareSDK imageWithUrl:imagePath]
                                                            title:hongMessage
                                                              url:urll
                                                      description:hongMessage
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
                                                 [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"xrlTapNum"];
                                                 gitGoin = 2;
                                                 NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id,@"fenxiangstatus":@"1",@"tel":userName_tel}];
                                                 [HTTPTool getWithUrl:@"fenxiangstatus.action" params:pram success:^(id json) {
                                                     if ([[json valueForKey:@"fenzuid"]integerValue]<0) {
                                                         [self requestNetworkWrong:@"创建红包失败"];
                                                     }
                                                     else{
                                                         [self requestNetworkWrong:@"分享成功"];
                                                         NSNotification *newGoodNotification = [NSNotification notificationWithName:@"newGoodNotification" object:nil];
                                                         [[NSNotificationCenter defaultCenter]postNotification:newGoodNotification];
                                                         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newGoodNotification" object:nil];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                     bud.mode = MBProgressHUDModeCustomView;
                                                     bud.labelText = @"网络连接错误4";
                                                     [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                                 }];
                                             }
                                             else if (state == SSResponseStateFail){
                                                 [self requestNetworkWrong:[error errorDescription]];
                                             }
                                         }];
            }];
        }
        else{
            [self requestNetworkWrong:@"分享失败"];
        }
    } failure:^(NSError *error) {
        [self requestNetworkWrong:@"网络连接错误5"];
    }];
}


-(void)BackgroundDataAcquisition
{
    //让该方法延迟五秒在执行一次
    [self performSelector:@selector(BackgroundDataAcquisition) withObject:nil afterDelay:60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"H"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"datetime %@",dateTime);
    if ([dateTime integerValue]>=8 && [dateTime integerValue]<=23) {
        
        //ping命令 原理：向大型的门户网址发送请求，来判断当前的网络状态
        //1、请求队列管理者(数据请求工具)
        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.m1ao.com/"]];
        //2、发送请求监测网络
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            //判断状态
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                [self timerClick];
            }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
                [self timerClick];
            }else if (status == AFNetworkReachabilityStatusNotReachable){
            }else{
                [self requestNetworkWrong:@"不可是别的网络状态"];
            }
        }];
        //3、启动网络监测
        [manager.reachabilityManager startMonitoring];//stopMonitoring
    }
    //网页视图
    webview = [[UIWebView alloc]initWithFrame:CGRectZero];
    webview.delegate = self;
    [self.view addSubview:webview];
}

-(void)timerClick
{
    NSString *urlStr = [NSString stringWithFormat:@"%@UserInfo.jsp?userid=%@&shequid=%@",HTTPWeb,user_id,userShequ_id];
    NSLog(@"%@",urlStr);
    
    NSURL *url =[NSURL URLWithString:urlStr];
    //转化成相应的源码
    NSString * htmlStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //加载HTML数据的
    //baseURL通常写为公司网址
    [webview loadHTMLString:htmlStr baseURL:nil];
    NSUserDefaults *def =  [NSUserDefaults standardUserDefaults];
    [self sendUILocalNotificationWithBody:nil AndTitle:nil AndBadgeNumber:[[def valueForKey:@"youhuiquancount"] integerValue] AndSound:nil];
    NSLog(@"youhuiquancount = %ld",(long)[[def valueForKey:@"youhuiquancount"] integerValue]);
}
#pragma mark WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //在该方法中可以手动书写javaScript代码 为图片添加点击事件可以获取图片网址
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"sdaf %@",currentURL);
    NSRange range = [currentURL rangeOfString:@"<!-- 1user登录时间  -->"];//匹配得到的下标
    NSString *str1 = [currentURL substringWithRange:NSMakeRange(0,range.location+range.length)];
    
    NSRange range2 = [currentURL rangeOfString:@"<!--2 user注册设备 -->"];//匹配得到的下标
    NSString *str2 = [currentURL substringWithRange:NSMakeRange(range.location+range.length,range2.location+range2.length-range.location-range.length)];
    
    NSRange range3 = [currentURL rangeOfString:@"<!--3 系统推送编号 -->"];//匹配得到的下标
    NSString *str3 = [currentURL substringWithRange:NSMakeRange(range2.location+range2.length,range3.location+ range3.length -range2.location-range2.length)];
    
    NSString *str4 = [currentURL substringFromIndex:range3.location+range3.length];
    
    NSRange rangeDef1 = [str1 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop1 = [str1 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef2 = [str2 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop2 = [str2 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef3 = [str3 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop3 = [str3 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef4 = [str4 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop4 = [str4 rangeOfString:@"><!"];//匹配得到的下标
    
    NSString *loginTime = [str1 substringWithRange:NSMakeRange(rangeDef1.location + rangeDef1.length +1,rangestop1.location-rangeDef1.location -rangeDef1.length-1-1)];
    
    NSString *shebeiBianhao = [str2 substringWithRange:NSMakeRange(rangeDef2.location + rangeDef2.length +1,rangestop2.location-rangeDef2.location -rangeDef2.length-1-1)];
    
    NSString *xitongbianhao = [str3 substringWithRange:NSMakeRange(rangeDef3.location + rangeDef3.length +1,rangestop3.location-rangeDef3.location -rangeDef3.length-1-1)];
    
    NSString *shequbianhao = [str4 substringWithRange:NSMakeRange(rangeDef4.location + rangeDef4.length +1,rangestop4.location-rangeDef4.location -rangeDef4.length-1-1)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSLog(@"设备相等时asdfads %@  %@ ",userSheBei_id,shebeiBianhao);
    if(![shebeiBianhao isEqualToString:@"0"]&&[userSheBei_id isEqualToString:shebeiBianhao])
    {
        NSLog(@"设备相等时 %@  %@ ",userSheBei_id,shebeiBianhao);
        NSString *hour = [loginTime substringWithRange:NSMakeRange(8, 2)];
        NSString *minute = [loginTime substringWithRange:NSMakeRange(10, 2)];
        NSString *second = [loginTime substringWithRange:NSMakeRange(12, 2)];
        NSString *loginTitle = [NSString stringWithFormat:@"您的账号于%@:%@:%@在其他地方登陆",hour,minute,second];
        [self sendUILocalNotificationWithBody:loginTitle AndTitle:nil AndBadgeNumber:0 AndSound:UILocalNotificationDefaultSoundName];
        [self AccountLoginViewWithLoginTime:loginTitle];
        [self.view bringSubviewToFront:accounView];
        
        [def setValue:0 forKey:@"isLogin"];
        [def setValue:userSheBei_id forKey:@"userId"];
        //        mainController *main = (mainController *)self.tabBarController;
        //        main.controlShowStyle = 1;
        //        [main tabarNoEnable:1];
        //        [main showOrHiddenTabBarView:NO];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"xrlTapNum"];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"youhuiquancount"];
        NSNotification *userExitNotification = [NSNotification notificationWithName:@"userExitFication" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:userExitNotification];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userExitFication" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        // 1.获取AFN的请求管理者
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        //网络延时设置15秒
        manger.requestSerializer.timeoutInterval = 15;
        manger.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //调用此接口,将要踢下线的设备的设备号删除
        NSString * urlPath = [NSString stringWithFormat:@"%@findbyuseriddenglulinshi.action",HTTPWeb];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
        // 3.发送请求
        [manger GET:urlPath parameters:pram success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
#pragma mark 系统通知
    else if(![xitongbianhao isEqualToString:@"0"]&&![[def valueForKey:@"xitongPush"] isEqualToString:xitongbianhao])
    {
        NSLog(@"系统不相等时 %@   %@  ",[def valueForKey:@"xitongPush"],[def valueForKey:@"shequPush"]);
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"xitongbianhao":xitongbianhao}];
        [self xitongPushActionWithUrl:@"tuiSongXiTongIOS.action" AndPram:pram];
        [def setValue:xitongbianhao forKey:@"xitongPush"];
    }
#pragma mark 社区通知
    else if(![shequbianhao isEqualToString:@"0"]&&![[def valueForKey:@"shequPush"] isEqualToString:shequbianhao])
    {
        NSLog(@"社区不相等时 %@   %@ ",[def valueForKey:@"xitongPush"],[def valueForKey:@"shequPush"]);
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequbianhao":shequbianhao}];
        [self xitongPushActionWithUrl:@"tuiSongSheQu.action" AndPram:pram];
        
        [def setValue:shequbianhao forKey:@"shequPush"];
    }
}
-(void)xitongPushActionWithUrl:(NSString *)url AndPram:(NSMutableDictionary *)pram
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = 20;
    
    NSString * urlPath =  [NSString stringWithFormat:@"%@/%@",HTTPPush,url];
    //    // 3.发送请求
    [manger GET:urlPath parameters:pram success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self sendUILocalNotificationWithBody:[responseObject valueForKey:@"content"] AndTitle:[responseObject valueForKey:@"biaoti"] AndBadgeNumber:0 AndSound:UILocalNotificationDefaultSoundName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}
-(void)sendUILocalNotificationWithBody:(NSString *)body AndTitle:(NSString *)title AndBadgeNumber:(NSInteger)num AndSound:(NSString *)sound
{
    //进行本地推送
    UILocalNotification * noti = [[UILocalNotification alloc]init];
    if (noti != nil) {
        //获取当前时间
        NSDate * now = [NSDate date];
        //让推送在10秒之后执行
        //设置推送开启时间
        noti.fireDate = now;
        //设置推送的循环次数 0表示不要重复
        noti.repeatInterval = 0;
        //设置推送的时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //设置红点表示数目/98721
        noti.applicationIconBadgeNumber =num;
        //设置推送声音
        noti.soundName = sound;//也可以添加音频文件，但是文字类型有要求acr
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.2) {
            //使用iOS8.0以上的方法
            noti.alertTitle = title;
        }
        //推送的内容
        noti.alertBody = body;
        //设置用户点入推送之后所需操作的具体内容
        //                        noti.userInfo = @{@"URL":@"http://www.iqy.com/wanwan"};
        //开启推送
        [[UIApplication sharedApplication]scheduleLocalNotification:noti];
    }
}

-(void)AccountLoginViewWithLoginTime:(NSString *)loginTime
{
    updateBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    updateBackgroundView.backgroundColor = [UIColor clearColor];
    accounView = [[AccountLoginView alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 180*MCscale)];
    accounView.alpha = 0.95;
    accounView.accountDelegate = self;
    [self.view addSubview:updateBackgroundView];
    [self.view addSubview:accounView];
    
    mainController *main = (mainController *)self.tabBarController;
    main.controlShowStyle = 1;
    [main tabarNoEnable:0];
    [main showOrHiddenTabBarView:NO];
    [accounView loadLabelTextContentWithLoginTime:loginTime];
}

#pragma mark AccountLoginViewDelegate
-(void)AccountLoginViewButtonClickWithIndex:(NSInteger)index
{
    if (index == 0) {
        [updateBackgroundView removeFromSuperview];
        [accounView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:userSheBei_id forKey:@"userId"];
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 1;
        [main tabarNoEnable:1];
        [main showOrHiddenTabBarView:NO];
    }
    else
    {
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 1;
        [main tabarNoEnable:1];
        [main showOrHiddenTabBarView:NO];
        [updateBackgroundView removeFromSuperview];
        [accounView removeFromSuperview];
        [self loginPopView];
    }
}
-(void)refresh
{
    //下拉刷新
    [_mainTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [_mainTableView addFooterWithTarget:self action:@selector(footRefreshing)];
    _mainTableView.headerPullToRefreshText = @"下拉刷新数据";
    _mainTableView.headerReleaseToRefreshText = @"松开刷新";
    _mainTableView.headerRefreshingText = @"拼命加载中";
    _mainTableView.footerPullToRefreshText = @"上拉加载数据";
    _mainTableView.footerReleaseToRefreshText = @"松开加载数据";
    _mainTableView.footerRefreshingText = @"拼命加载中";
}
//下拉
-(void)headReFreshing
{
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
    [self initData];
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self initData];
}

-(void)loadFootView
{
    if (isBotom == 1) {
        UIView *fotView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*MCscale)];
        fotView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*MCscale)];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = @"更多商家陆续进入中";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:MLwordFont_2];
        [fotView addSubview:lb];
        _mainTableView.tableFooterView = fotView;
        _mainTableView.footerHidden = YES;
    }
    else{
        _mainTableView.footerHidden = NO;
        _mainTableView.tableFooterView = nil;
    }
}

-(void)endRefresh:(BOOL)bolType
{
    if (bolType) {
        [_mainTableView footerEndRefreshing];
    }
    else{
        [_mainTableView headerEndRefreshing];
    }
}

//错误提示
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeText;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
#pragma mark --键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    [self.view addSubview:mask];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    [mask removeFromSuperview];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(void)bubbleMaskDismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        bubbleMask.alpha = 0;
        [bubbleMask removeFromSuperview];
        [self.view endEditing:YES];
        bubbleView.alpha = 0;
        [bubbleView removeFromSuperview];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    leftView.hidden = NO;
    rightView.hidden = NO;
    titleView.hidden = YES;
    _mainTableView.frame = CGRectMake(0,0, kDeviceWidth, kDeviceHeight-49*MCscale);
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
}
@end
