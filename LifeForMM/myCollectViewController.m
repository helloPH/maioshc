//
//  myCollectViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/19.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "myCollectViewController.h"
#import "Header.h"
#import "lifeCityViewController.h"
#import "GoodDetailViewController.h"
#import "collectionModel.h"
#import "TGCenterLineLabel.h"
#import "shopController.h"
@interface myCollectViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UIView *goodView,*btnView,*lineView;// 商品、店铺
    UITableView *goodTableView;//商品表、店铺
    NSMutableArray *shopDataAry,*goodDataAry,*dataArray;//店铺数据 商品数据
    BOOL isGood;//是否是商品
    MBProgressHUD *Hud;
}
@end

@implementation myCollectViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的收藏";
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notvactionAction) name:@"goodAddShoucang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notvactionAction) name:@"shopAddShoucang" object:nil];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    dataArray = [[NSMutableArray alloc]init];
    goodDataAry = [[NSMutableArray alloc]init];
    shopDataAry = [[NSMutableArray alloc]init];
    isGood = 1;
    [self loadNavigation];
    [self initGoodView];
    [self relodData];
    [self addSlideGesture];
}
//导航栏
-(void)loadNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 101;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"主页"] forState:UIControlStateNormal];
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)notvactionAction
{
    [dataArray removeAllObjects];
    [goodDataAry removeAllObjects];
    [shopDataAry removeAllObjects];
    [self relodData];
}
#pragma mark -- 获取数据
-(void)relodData
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSString *googOrshop = [NSString stringWithFormat:@"%d",isGood];
    goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shoucang.userid":user_id,@"shoucang.shoucangtype":googOrshop}];
    [HTTPTool getWithUrl:@"showShoucang.action" params:pram success:^(id json) {
        [Hud hide:YES];
        if (![[json valueForKey:@"message"]integerValue]) {
            if(isGood){
                [goodDataAry removeAllObjects];
                NSArray *ary = [json valueForKey:@"shop"];
                for(NSDictionary *dic in ary){
                    collectionModel *model = [[collectionModel alloc]initWithContent:dic];
                    [goodDataAry addObject:model];
                }
                dataArray = goodDataAry;
            }
            else{
                NSArray *ary = [json valueForKey:@"dianpu"];
                for(NSDictionary *dic in ary){
                    collectionModel *model = [[collectionModel alloc]initWithContent:dic];
                    [shopDataAry addObject:model];
                }
                dataArray = shopDataAry;
            }
            if (dataArray.count ==0) {
                goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的收藏无数据.jpg"]];
            }
            else{
                goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            }
        }
        else{
            goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的收藏无数据.jpg"]];
        }
        [goodTableView reloadData];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)addSlideGesture
{
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideAction:)];
    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwip];
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideAction:)];
    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwip];
}
-(void)slideAction:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == 2) {
        UIButton *bt = (UIButton *)[btnView viewWithTag:1002];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[btnView viewWithTag:1001];
        [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
        lineView.frame = CGRectMake(35, 38, kDeviceWidth/3.0, 2);
        isGood = 1;
        dataArray = goodDataAry;
    }
    else{
        UIButton *bt = (UIButton *)[btnView viewWithTag:1001];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[btnView viewWithTag:1002];
        [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35) + kDeviceWidth/2.0, 38, kDeviceWidth/3.0, 2);
        isGood = 0;
        dataArray = shopDataAry;
    }
    if (dataArray.count == 0) {
        [self relodData];
    }
    else{
        [goodTableView reloadData];
        goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
    }
}
-(void)backBtnAction
{
    mainController *main = (mainController *)self.tabBarController;
    main.controlShowStyle = 0;
    [main showOrHiddenTabBarView:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnAction
{
    mainController *main = (mainController *)self.tabBarController;
    main.controlShowStyle = 1;
    [main showOrHiddenTabBarView:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
// 商品、店铺列表
-(void)initGoodView
{
    goodView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , kDeviceHeight)];
    goodView.backgroundColor = [UIColor clearColor];
    goodTableView = [[UITableView alloc]initWithFrame:goodView.bounds style:UITableViewStyleGrouped];
    goodTableView.delegate = self;
    goodTableView.dataSource = self;
    goodTableView.backgroundColor = [UIColor whiteColor];
    goodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodView addSubview:goodTableView];
    [self.view addSubview:goodView];
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
    btnView.backgroundColor = [UIColor whiteColor];
    lineView = [[UIView alloc]initWithFrame:CGRectMake(35, 38, kDeviceWidth/3.0, 2)];
    lineView.backgroundColor = txtColors(25, 182, 133, 1);
    [btnView addSubview:lineView];
    
    UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodBtn.frame = CGRectMake(0, 0, kDeviceWidth/2.0, 38);
    goodBtn.tag = 1001;
    goodBtn.backgroundColor = [UIColor clearColor];
    [goodBtn setTitle:@"商品" forState:UIControlStateNormal];
    [goodBtn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    [goodBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    goodBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    [btnView addSubview:goodBtn];
    
    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeBtn.frame = CGRectMake(kDeviceWidth/2.0, 0, kDeviceWidth/2.0, 38);
    storeBtn.tag = 1002;
    storeBtn.backgroundColor = [UIColor clearColor];
    [storeBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [storeBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    [btnView addSubview:storeBtn];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [btnView addSubview:line];
    [self.view addSubview:btnView];
}
//按钮事件
-(void)goodOrStoreBtnAction:(UIButton *)btn
{
    [btn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    if (btn.tag == 1001) {
        UIButton *bt = (UIButton *)[btnView viewWithTag:1002];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineView.frame = CGRectMake(35, 38, kDeviceWidth/3.0, 2);
        isGood = 1;
        dataArray = goodDataAry;
    }
    else{
        UIButton *bt = (UIButton *)[btnView viewWithTag:1001];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35) + kDeviceWidth/2.0, 38, kDeviceWidth/3.0, 2);
        isGood = 0;
        dataArray = shopDataAry;
    }
    if (dataArray.count == 0) {
        [self relodData];
    }
    else{
        [goodTableView reloadData];
        goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 10, 50, 50)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 1001;
        [cell.contentView addSubview:imageView];
        
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectZero];
        labe.tag = 1002;
        labe.backgroundColor = [UIColor clearColor];
        labe.textAlignment = NSTextAlignmentLeft;
        labe.textColor =[UIColor blackColor];
        [cell.contentView addSubview:labe];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectZero];
        price.tag = 1004;
        price.backgroundColor = [UIColor clearColor];
        price.textAlignment = NSTextAlignmentLeft;
        price.textColor = txtColors(241, 53, 66, 1);
        price.font = [UIFont systemFontOfSize:MLwordFont_2];
        [cell.contentView addSubview:price];
        
        TGCenterLineLabel *original = [[TGCenterLineLabel alloc]initWithFrame:CGRectZero];
        original.tag = 1005;
        original.backgroundColor = [UIColor clearColor];
        original.textAlignment = NSTextAlignmentLeft;
        original.textColor = textColors;
        original.font = [UIFont systemFontOfSize:MLwordFont_6];
        [cell.contentView addSubview:original];
        
        UIView *delView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, 200, 70)];
        delView.backgroundColor = txtColors(206, 207, 208, 1);
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
        image.image = [UIImage imageNamed:@"红色删除"];
        [delView addSubview:image];
        image.tag = 1003;
        [cell.contentView addSubview:delView];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 69, kDeviceWidth-40, 1)];
        line.backgroundColor = lineColor;
        [cell.contentView addSubview:line];
    }
    collectionModel *model = dataArray[indexPath.row];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:1001];
    UILabel *lab = (UILabel *)[cell viewWithTag:1002];
    UILabel *price = (UILabel *)[cell viewWithTag:1004];
    TGCenterLineLabel *original = (TGCenterLineLabel *)[cell viewWithTag:1005];
    NSURL *imgurl;
    if (isGood) {
        lab.frame = CGRectMake(imageview.right+10, 15, 200*MCscale, 20);
        lab.font = [UIFont systemFontOfSize:MLwordFont_5];
        price.frame = CGRectMake(imageview.right+10, lab.bottom+5, 80*MCscale, 20);
        original.frame = CGRectMake(price.right+10, lab.bottom+5, 80*MCscale, 20);
        price.alpha = 1;
        imgurl = [NSURL URLWithString:model.canpinpic];
        lab.text = model.shopname;
        price.text = [NSString stringWithFormat:@"¥%@",model.xianjia];//@"¥30.0";
        NSString *yj = [NSString stringWithFormat:@"%@",model.yuanjia];
        if (![yj isEqualToString:@"0"]) {
            original.alpha = 1;
            original.text = [NSString stringWithFormat:@"原价:%@",yj];
        }
        else
            original.alpha = 0;
    }
    else{
        imgurl = [NSURL URLWithString:model.dianpulogo];
        lab.frame = CGRectMake(imageview.right+10, 25, 200*MCscale, 20);
        lab.font = [UIFont systemFontOfSize:MLwordFont_12];
        price.alpha = 0;
        original.alpha = 0;
        lab.text = model.dianpuname;
    }
    
    [imageview sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    UIImageView *delImg = (UIImageView *)[cell viewWithTag:1003];
    delImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delData:)];
    [delImg addGestureRecognizer:tap];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self delData:indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    collectionModel *model = dataArray[indexPath.row];
    if (isGood == 1) {
        GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
        goodDetail.goodId = model.shopid;
        goodDetail.dianpuId = model.dianpuid;
        goodDetail.godShequid = model.shequid;
        [self.navigationController pushViewController:goodDetail animated:YES];
    }
    else{
        shopController *shop = [[shopController alloc]init];
        shop.shopName = model.dianpuname;
        shop.shopId = model.dianpuid;
        [self.navigationController pushViewController:shop animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 删除数据
-(void)delData:(NSInteger)index
{
    collectionModel *mode = dataArray[index];
    NSString *dianpuid,*shangpindid;
    if (isGood) {
        shangpindid = mode.shopid;
        dianpuid = @"0";
    }
    else{
        shangpindid = @"0";
        dianpuid = mode.dianpuid;
    }
    NSString *typ = [NSString stringWithFormat:@"%d",isGood];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shoucang.userid":user_id,@"shoucang.shoucangtype":typ,@"shoucang.shopid":shangpindid,@"shoucang.shequid":mode.shequid,@"shoucang.dianpuid":dianpuid}];
    [HTTPTool getWithUrl:@"deleteShoucang.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"message"]integerValue] == 1) {
            [dataArray removeObjectAtIndex:index];
            if (dataArray.count == 0) {
                goodTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的收藏无数据.jpg"]];
            }
            [goodTableView reloadData];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)myTask
{
    sleep(1.5);
}

@end
