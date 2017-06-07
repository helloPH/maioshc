//
//  FuliViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "FuliViewController.h"
#import "Header.h"
#import "FuliDisplayModel.h"
#import "FuliCollectionViewCell.h"
#import "shopController.h"
@interface FuliViewController ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
@end

@implementation FuliViewController
{
    UICollectionView *mainCollecView;//商品列表
    BOOL isRefresh,isBotom;
    NSInteger loadType;
    int pageNum,lastPage;
    NSMutableArray *allDataAry; //所有数据
    UIView *maskView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    //    [self onlyLognUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    pageNum= 1;
    isBotom= 1;
    isRefresh = 0;
    allDataAry = [[NSMutableArray alloc]init];
    [self initNavigation];
    [self loadListData];
    [self initCollectionView];
    [self refresh];//刷新
}
-(void)initNavigation
{
    self.navigationItem.title = @"单你有礼";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -- 获取列表数据
-(void)loadListData
{
    MBProgressHUD *md = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    md.mode = MBProgressHUDModeIndeterminate;
    md.delegate = self;
    md.labelText = @"请稍等...";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shequid":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum]}];
        
        [HTTPTool getWithUrl:@"findbyfulis.action" params:pram success:^(id json) {
            [md hide:YES];
            NSLog(@"福利 %@",json);
            if (isRefresh) {
                [self endRefresh:loadType];
            }
            if (lastPage == pageNum) {
                [allDataAry removeAllObjects];
            }
            lastPage = pageNum;
            
            NSDictionary *dc = (NSDictionary *)json;
            NSArray *shoplist = [dc valueForKey:@"list"];
            if (shoplist.count >0) {
                for (NSDictionary *dict in shoplist) {
                    FuliDisplayModel *model = [[FuliDisplayModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [allDataAry addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainCollecView reloadData];
                    
                });
                
                isBotom = 0;
                [self loadFootView];
            }
            else
            {
                isBotom = 1;
                [self loadFootView];
            }
            
        } failure:^(NSError *error) {
            [md hide:YES];
            [self endRefresh:loadType];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误3";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    });
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.headerReferenceSize = CGSizeMake(kDeviceWidth, 15);
    
    mainCollecView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,64, kDeviceWidth, kDeviceHeight - 64*MCscale) collectionViewLayout:flowLayout1];
    //左侧
    mainCollecView.delegate = self;
    mainCollecView.dataSource = self;
    mainCollecView.alwaysBounceVertical = YES;
    mainCollecView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainCollecView];
    [mainCollecView registerClass:[FuliCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (allDataAry.count>0) {
        return allDataAry.count;
    }
    else
        return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell1";
    FuliCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //    [cell sizeToFit];
    if(allDataAry.count>0){
        [cell reloadDataWithIndexpath:indexPath AndArray:allDataAry];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kDeviceWidth/2-6, SCLHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    shopController *shop = [[shopController alloc]init];
    if(allDataAry.count >0){
        FuliDisplayModel *model = allDataAry[indexPath.row];
        shop.shopId = model.dianpuid;
        shop.shopName = model.dianpuname;
        //        NSString *shopState = [NSString stringWithFormat:@"%@",model.];
        //        if ([shopState isEqualToString:@"3"]) {
        //            shop.isReset = 1;
        //        }
        //        else
        //            shop.isReset = 0;
        //        shop.isHuodong = [NSString stringWithFormat:@"%@",model.isHuodong];
        [self.navigationController pushViewController:shop animated:YES];
    }
}
#pragma mark -- btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)refresh
{
    //下拉刷新
    [mainCollecView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [mainCollecView addFooterWithTarget:self action:@selector(footRefreshing)];
    mainCollecView.headerPullToRefreshText = @"下拉刷新数据";
    mainCollecView.headerReleaseToRefreshText = @"松开刷新";
    mainCollecView.headerRefreshingText = @"拼命加载中";
    mainCollecView.footerPullToRefreshText = @"上拉加载数据";
    mainCollecView.footerReleaseToRefreshText = @"松开加载数据";
    mainCollecView.footerRefreshingText = @"拼命加载中";
}
//下拉
-(void)headReFreshing
{
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
    [self loadListData];
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self loadListData];
}

-(void)endRefresh:(BOOL)bolType
{
    if (bolType) {
        [mainCollecView footerEndRefreshing];
    }
    else{
        [mainCollecView headerEndRefreshing];
    }
}
-(void)loadFootView
{
    if (isBotom == 1) {
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mHud.mode = MBProgressHUDModeCustomView;
        mHud.labelText = @"已经到底了";
        mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
