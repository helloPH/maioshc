//
//  locationViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "locationViewController.h"
#import "Header.h"

@interface locationViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@end

@implementation locationViewController
{
    UITableView *locationTableView;
    UIImageView *caozuotishiImage;
    UITextField *addressText;
    CLLocation *sloccation;
    CLGeocoder *geocoder;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_codeSearch;
    BMKReverseGeoCodeOption *_reverSearch;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    NSMutableArray *addressNameArray;
    NSMutableArray *addressArray;
    BOOL isSearch;
    BOOL isLoca;
    
    NSString *city;
    NSString *address_x;
    NSString *address_y;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearch = 0;
    isLoca = 0;
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    city = @"";
    address_x = @"0";
    address_y = @"0";
    
    addressNameArray = [NSMutableArray arrayWithCapacity:0];
    addressArray = [NSMutableArray arrayWithCapacity:0];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = 5;
    _locService.delegate = self;
    //启动LocationService
    [self performSelector:@selector(delay) withObject:self afterDelay:0.1];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,将由系统为您匹配社区" preferredStyle:1];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            city = @"";
            address_x = @"0";
            address_y = @"0";
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initNavigation];
    [self initSubViews];
}
-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstLocation"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/dwzhiyin.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
        caozuotishiImage.userInteractionEnabled = YES;
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [caozuotishiImage addGestureRecognizer:imageTap];
        [self.view addSubview:caozuotishiImage];
    }
}

-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstLocation"];
    [caozuotishiImage removeFromSuperview];
}

-(void)initNavigation
{
    self.navigationItem.title = @"选择收货地址";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    //    [rightButton setBackgroundImage:[UIImage imageNamed:@"自我定位"] forState:UIControlStateNormal];
    //    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    //    rightButton.tag = 1002;
    //    UIBarButtonItem *rightbarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //    self.navigationItem.rightBarButtonItem =rightbarBtn;
}
-(void)initSubViews
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, 130*MCscale)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    addressText = [[UITextField alloc]initWithFrame:CGRectMake(20*MCscale, 10*MCscale, kDeviceWidth - 40*MCscale, 30*MCscale)];
    addressText.backgroundColor = txtColors(231, 231, 231, 1);
    addressText.font = [UIFont systemFontOfSize:MLwordFont_4];
    addressText.textAlignment = NSTextAlignmentLeft;
    addressText.borderStyle = UITextBorderStyleRoundedRect;
    addressText.placeholder = @"请输入收货地址";
    addressText.delegate = self;
    addressText.returnKeyType = UIReturnKeyDone;
    [backView addSubview:addressText];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, addressText.bottom +10*MCscale, kDeviceWidth, 10*MCscale)];
    lineView.backgroundColor = lineColor;
    [backView addSubview:lineView];
    
    UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, kDeviceWidth, 40*MCscale)];
    locationView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:locationView];
    UITapGestureRecognizer *locaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapClick)];
    [locationView addGestureRecognizer:locaTap];
    
    UIImageView *locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth/2.0-80*MCscale, 10*MCscale, 20*MCscale, 20*MCscale)];
    locationImage.image = [UIImage imageNamed:@"定位-1"];
    [locationView addSubview:locationImage];
    
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140*MCscale, 20*MCscale)];
    locationLabel.center = CGPointMake(kDeviceWidth/2.0+10*MCscale, locationView.height/2.0);
    locationLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textColor = textColors;
    locationLabel.text = @"点击定位当前位置";
    [locationView addSubview:locationLabel];
    
    UIView *locaBackView = [[UIView alloc]initWithFrame:CGRectMake(0, locationView.bottom, kDeviceWidth, 30*MCscale)];
    locaBackView.backgroundColor = txtColors(231, 231, 231, 1);
    [backView addSubview:locaBackView];
    
    UIImageView *locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*MCscale,5*MCscale,20*MCscale, 20*MCscale)];
    locaImage.image = [UIImage imageNamed:@"定位"];
    [locaBackView addSubview:locaImage];
    
    UILabel *locaLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*MCscale, 20*MCscale)];
    locaLabel.center = CGPointMake(135*MCscale, locaBackView.height/2.0);
    locaLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    locaLabel.textAlignment = NSTextAlignmentLeft;
    locaLabel.textColor = textColors;
    locaLabel.text = @"附近地址";
    [locaBackView addSubview:locaLabel];
    
    [self loadTableView];
}
//初始化表格
-(void)loadTableView
{
    locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,194*MCscale, kDeviceWidth, kDeviceHeight-194*MCscale) style:UITableViewStylePlain];
    locationTableView.backgroundColor = [UIColor whiteColor];
    locationTableView.delegate = self;
    locationTableView.dataSource = self;
    locationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:locationTableView];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, cell.height-0.5, kDeviceWidth-20*MCscale,0.5)];
        lineView.backgroundColor = lineColor;
        [cell.contentView addSubview:lineView];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = addressNameArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSearch = 0;
    isLoca = 0;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *address = [NSString stringWithFormat:@"%@%@",addressArray[indexPath.row],addressNameArray[indexPath.row]];
    [[NSUserDefaults standardUserDefaults]setValue:addressNameArray[indexPath.row] forKey:@"addressName"];

    [self searchTipsWithKey:address];
}

-(void)searchTipsWithKey:(NSString *)key
{
    _codeSearch =[[BMKGeoCodeSearch alloc]init];
    _codeSearch.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    //    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address = key;
    BOOL flag = [_codeSearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}
-(void)delay
{
    _codeSearch =[[BMKGeoCodeSearch alloc]init];
    _codeSearch.delegate = self;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (isLoca) {
        NSString *latit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
        NSString *longit = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
        address_x = longit;
        address_y = latit;
        sloccation = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count) {
                //获取当前城市
                CLPlacemark *mark = placemarks.firstObject;
                NSDictionary *dict = [mark addressDictionary];
                
                NSLog(@"%@",dict);
                city = [dict objectForKey:@"City"];
                
            }
        }];
        [self addressGetShequ];
        [_locService stopUserLocationService];
    }
    else
    {
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
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    sloccation = [[CLLocation alloc]initWithLatitude:result.location.latitude longitude:result.location.longitude];
    geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            
            NSLog(@"%@",dict);
            city = [dict objectForKey:@"City"];
            
        }
    }];
    
    NSLog(@"%@  %f  %f",result.address,result.location.longitude,result.location.latitude);
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (isSearch) {
            [self delay];
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){result.location.latitude, result.location.longitude};
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
        {//116.583514,39.909454
            
            address_y = [NSString stringWithFormat:@"%f",result.location.latitude];
            address_x = [NSString stringWithFormat:@"%f",result.location.longitude];
            
            [[NSUserDefaults standardUserDefaults]setValue:address_y forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults]setValue:address_x forKey:@"longitude"];
            [self addressGetShequ];
        }
        NSLog(@"%@",addressNameArray);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_locService stopUserLocationService];
    if (result.addressDetail) {
        city = result.addressDetail.city;
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [addressNameArray removeAllObjects];
        [addressArray removeAllObjects];
        for (int i = 0; i < result.poiList.count; i++) {
            BMKPoiInfo* poi = [result.poiList objectAtIndex:i];
            NSLog(@"%@",poi.name);
            if (addressArray.count <5) {
                [addressNameArray addObject:poi.name];
                [addressArray addObject:poi.address];
            }
            [locationTableView reloadData];
        }
        NSLog(@"%@",addressNameArray);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


-(void)locationTapClick
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,将由系统为您匹配社区" preferredStyle:1];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            city = @"";
            address_x = @"0";
            address_y = @"0";
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
    else
    {
        isLoca = 1;
        [_locService startUserLocationService];
    }
}
-(void)addressGetShequ
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.delegate = self;
    hub.mode = MBProgressHUDModeIndeterminate;
    hub.labelText = @"请稍等...";
    [hub show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"city":city,@"address.x":address_x,@"address.y":address_y}];
    
    [HTTPTool getWithUrl:@"addressGetShequ.action" params:pram success:^(id json) {
        [hub hide:YES];
        NSLog(@"定位%@",json);
        //117.623181,44.592075,锡林郭勒盟"
        [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"shequid"] forKey:@"userShequid"];        
        [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"shequname"] forKey:@"userShequName"];
        
        NSNotification *resetTitle = [NSNotification notificationWithName:@"resetTitle" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:resetTitle];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetTitle" object:nil];
        
        [self btnAction];
    } failure:^(NSError *error) {
        [hub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)btnAction
{
    mainController *main = (mainController *)self.tabBarController;
    main.controlShowStyle = 1;
    [main showOrHiddenTabBarView:NO];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.72];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isSearch = 1;
    isLoca = 0;
    [addressText resignFirstResponder];
    [self searchTipsWithKey:addressText.text];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isSearch = 1;
    isLoca = 0;
    [addressText resignFirstResponder];
    [self searchTipsWithKey:addressText.text];
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _locService.delegate = nil;
    _codeSearch.delegate = nil;
    _codeSearch=nil;
    sloccation= nil;
    geocoder=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myTask
{
    sleep(1.5);
}
@end
