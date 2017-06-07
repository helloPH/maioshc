//
//  ClassViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ClassViewController.h"
#import "shopListModel.h"
#import "shopController.h"
#import "Header.h"
@interface ClassViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,BMKLocationServiceDelegate>

@end

@implementation ClassViewController
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    BOOL isBotom,isRefresh;
    NSInteger loadType;
    int pageNum,lastPage;
    NSString *paixu;
    UIView *maskView;
    UIImageView *bubbleView;
    BMKLocationService *_locService;
    NSString *latit;
    NSString *longit;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    [self initData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [NSMutableArray arrayWithCapacity:0];
    isBotom = 1;
    paixu = @"0";
    pageNum = 1;
    isRefresh =0;
    latit =@"";
    longit = @"";
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = 5;
    _locService.delegate = self;
    //启动LocationService
    
    [self initNavigation];
    [self initSubViews];
    [self initMaskView];
    [self refresh];
}

-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    
}
-(void)initNavigation
{
    NSArray *btnTitleArray = @[@"美食佳饮",@"果蔬生鲜",@"商超便利",@"家庭服务"];
    self.navigationItem.title = btnTitleArray[_viewTag - 1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(void)btnAction:(UIButton *)button
{
    if (button.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)initSubViews
{
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0,64, kDeviceWidth, 30*MCscale)];
    btnBackView.alpha = 0.95;
    btnBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBackView];
    CGFloat btnWidth = kDeviceWidth/3.0;
    NSArray *btnArray = @[@"综合排序",@"销量最高",@"距离最近"];
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
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = textColors.CGColor;
        button.alpha = 0.95;
        button.tag = 100+i;
        [btnBackView addSubview:button];
    }
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94*MCscale, kDeviceWidth, kDeviceHeight - 94*MCscale) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
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
-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
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
            [self maskViewDisMiss];
        }
        [dataArray removeAllObjects];
        [self initData];
    }
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
    latit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
    longit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
    
    [_locService stopUserLocationService];
    
    [dataArray removeAllObjects];
    [self initData];
}

#pragma mark -- 列表数据
-(void)initData
{
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    NSMutableDictionary *pram;
    if ([paixu isEqualToString:@"5"]) {
        pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"leixing":[NSString stringWithFormat:@"%ld",(long)_viewTag],@"paixu":paixu,@"x":longit,@"y":latit}];
    }
    else
    {
        pram  = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"leixing":[NSString stringWithFormat:@"%ld",(long)_viewTag],@"paixu":paixu}];
    }
    
    [HTTPTool getWithUrl:@"findByShequid5.action" params:pram success:^(id json) {
        [dbud hide:YES];
        NSLog(@"店铺分类 %@",json);
        
        if (isRefresh) {
            [self endRefresh:loadType];
        }
        if (lastPage == pageNum) {
            [dataArray removeAllObjects];
        }
        lastPage = pageNum;
        NSDictionary *dict = (NSDictionary *)json;
        NSArray *ary = [dict valueForKey:@"dianpushuju"];
        if (ary.count >0) {
            isBotom = 0;
            [self loadFootView];
            for(NSDictionary *dic in ary){
                shopListModel *mode= [[shopListModel alloc]initWithContent:dic];
                [dataArray addObject:mode];
            }
            [mainTableView reloadData];
            mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
        }
        else{
            [mainTableView reloadData];
            isBotom = 1;
            [self loadFootView];
            mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页"]];
        }
    } failure:^(NSError *error) {
        //        [self endRefresh:loadType];
        [dbud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误1";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    homePageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[homePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (dataArray.count !=0) {
        cell.shopModel = dataArray[indexPath.row];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shopController *shop = [[shopController alloc]init];
    if(dataArray.count >0){
        shopListModel *model = dataArray[indexPath.row];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*MCscale;
}
-(void)refresh
{
    //下拉刷新
    [mainTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [mainTableView addFooterWithTarget:self action:@selector(footRefreshing)];
    mainTableView.headerPullToRefreshText = @"下拉刷新数据";
    mainTableView.headerReleaseToRefreshText = @"松开刷新";
    mainTableView.headerRefreshingText = @"拼命加载中";
    mainTableView.footerPullToRefreshText = @"上拉加载数据";
    mainTableView.footerReleaseToRefreshText = @"松开加载数据";
    mainTableView.footerRefreshingText = @"拼命加载中";
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
        mainTableView.tableFooterView = fotView;
        mainTableView.footerHidden = YES;
    }
    else{
        mainTableView.footerHidden = NO;
        mainTableView.tableFooterView = nil;
    }
}

-(void)endRefresh:(BOOL)bolType
{
    if (bolType) {
        [mainTableView footerEndRefreshing];
    }
    else{
        [mainTableView headerEndRefreshing];
    }
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        bubbleView.alpha = 0;
        [bubbleView removeFromSuperview];
    }];
}
-(void)myTask
{
    sleep(1.5);
}

-(void)viewWillDisappear:(BOOL)animated
{
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
