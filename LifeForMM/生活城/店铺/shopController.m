//
//  shopController.m
//  LifeForMM
//
//  Created by HUI on 16/3/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "shopController.h"
#import "Header.h"
#import "shopCollectionViewCell.h"
#import "ShopDetailViewController.h"
#import "GoodDetailViewController.h"
#import "TGCenterLineLabel.h"
#import "UserOrderViewController.h"
#import "topActivityModel.h"
#import "shopTypeModel.h"
#import "CarViewController.h"
#import "SureOrderViewController.h"
#import "MaskView.h"
#import "NewAddresPopView.h"
#import "MBPrompt.h"
#import "OrderPromptView.h"
#import "userAddressModel.h"
#import "searchViewController.h"
@interface shopController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,newAddresPopDelegate,OrderPromptViewDelegate,CAAnimationDelegate>
{
    UIImageView *bubbleView;//气泡
    BOOL ritBtnBol;
    CGFloat lastoffl;
    UICollectionView *listCollecView;//商品列表
    UICollectionView *leftCollecView;//左侧商品列表
    UICollectionView *rightCollecView;//右侧列表
    UIScrollView *bckScrollview;//
    NSInteger lastBtnTag;
    UIScrollView *scrol;//头部导航
    UIView *fotView;//底部视图
    NSInteger goodNumInCar; //加入购物数量
    NSMutableArray *btnArray; //c存放所有加入购物车按钮
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    UIView *activityPopView;//置顶活动弹框
    UIView *topActivity; //置顶活动
    UITableView *activityTable; //置顶活动列表
    NSMutableArray *goodAry;
    UILabel *totlMoney;//总钱数
    UILabel *numLabel;//购物车物品数量
    NSMutableArray *topDataAry;//置顶活动数据
    UIImageView *topDirection;//置顶活动箭头
    CGFloat angle;//顶部箭头旋转角度
    NSMutableArray *shopTypeDataAyr;//商品分类数据
    BOOL hotArea;//是否有活动专区
    //    NSJSONSerialization
    UIView *activityView;//头部视图
    NSString *godId;//商品id 用户id
    CGFloat tolMoney;//总价
    NSInteger shuliang;//从服务器获取的购物车数量
    CGFloat total;//从服务器获取的购物车总价
    UIView *maskView;//遮罩
    BOOL isRefresh;
    NSInteger loadType,page;
    UILabel *youhuiLabel;//优惠价格
    NSInteger topTapNum;
    MBProgressHUD *mbHud;
    NewAddresPopView *newAddressPop;//新地址
    OrderPromptView *orderPrompt;//提示信息
    MaskView *mask;//弹框遮罩层
    NSMutableArray *pageAry;//
    NSMutableArray *minPageAry; //数组第一条数据所在页
    NSMutableArray *maxPageAry; //数组最后一条数据所在页
    NSMutableArray *allDataAry; //所有数据
    NSInteger typeIndex;//当前选择类型
    UIImageView *chooseBtnView;//选好了按钮
    UIImageView *whiteCar;//底部购物车
    UILabel *carEmptyLab; //购物车-空
    UIImageView *carEmptyImg;//
    NSString *titleMessage;
    NSInteger scroPage; //当前显示滑动视图page
    NSInteger typeNum;//分类下标
    NSMutableArray *allTypeWidths;
    CGFloat typBtnWidth;//
    NSMutableArray *xlengthsAry;
    UIImageView *caozuotishiImage;
    NSArray *titleArray;
    NSArray *imageArray;
}
@end

@implementation shopController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"goodPageAddGoods" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodCarData) name:@"changeGoodsAnying" object:nil];//goodPageAddGoods
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"cardelNotification" object:nil];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    ritBtnBol = 0;
    lastBtnTag = 1;
    scroPage = 1;
    lastoffl = 0.0;
    typeNum = 0;
    goodNumInCar = hotArea = tolMoney = isRefresh =topTapNum=0;
    page = 1;
    typeIndex = 0;
    typBtnWidth = 0.0;
    titleArray = @[@"店内搜索",@"分享商家",@"商家详情",@"收藏商家"];
    imageArray = @[@"灰色搜索",@"分享-橘黄色",@"店铺图标",@"叹号"];
    allTypeWidths = [[NSMutableArray alloc]init];
    btnArray = [[NSMutableArray alloc]init];
    goodAry = [[NSMutableArray alloc]init];
    topDataAry = [[NSMutableArray alloc]init];
    shopTypeDataAyr = [[NSMutableArray alloc]init];
    allDataAry = [[NSMutableArray alloc]init];
    minPageAry = [[NSMutableArray alloc]init];
    maxPageAry = [[NSMutableArray alloc]init];
    xlengthsAry = [[NSMutableArray alloc]init];
    [self getDianpuhuodong];
    [self initNavigation];
    [self initMaskView];
    [self initScrollView];
    [self loadShopTayData];
    [self popView];//弹框
    [self initfootView];//底部视图
    [self refresh];//刷新
    [self initNewAddressPop];
    [self maskView];//遮罩
    [self judgeTheFirst];
    [self restPrompt];
}

-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstShop"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/dianpushouye.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -45*MCscale, kDeviceWidth, kDeviceHeight+40*MCscale)];
        caozuotishiImage.alpha = 0.90;
        caozuotishiImage.userInteractionEnabled = YES;
        caozuotishiImage.backgroundColor = [UIColor clearColor];
        [self.view addSubview:caozuotishiImage];
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [caozuotishiImage addGestureRecognizer:imageTap];
    }
}
-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstShop"];
    [caozuotishiImage removeFromSuperview];
}

-(void)initNavigation
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@",_shopName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftbarBtn;
    self.navigationItem.backBarButtonItem.enabled = NO;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"加号按钮"] forState:UIControlStateNormal];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)getDianpuhuodong
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":_shopId}];
    [HTTPTool getWithUrl:@"findbydianpuhuodongpanduan.action" params:pram success:^(id json) {
        _isHuodong = [json valueForKey:@"massages"];
        [self initTopData];
        [self initHeadView];//头部视图
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误1";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)restPrompt
{
    if (_isReset) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"先看看，店铺休息中无法接受订单";
        [bud showWhileExecuting:@selector(showTask) onTarget:self withObject:nil animated:YES];
    }
}
-(void)initScrollView
{
    bckScrollview = [[UIScrollView alloc]init];
    if ([[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        bckScrollview.frame = CGRectMake(0, 64+SCTypeHeight+40*MCscale, kDeviceWidth, kDeviceHeight-(64+SCTypeHeight+40*MCscale+49));
        bckScrollview.contentSize = CGSizeMake(kDeviceWidth*3, kDeviceHeight-(64+SCTypeHeight+40*MCscale+49));
    }
    else{
        bckScrollview.frame = CGRectMake(0, 64+40*MCscale, kDeviceWidth, kDeviceHeight-64-SCTypeHeight-49);
        bckScrollview.contentSize = CGSizeMake(kDeviceWidth*3, kDeviceHeight-(64+40*MCscale+49));
    }
    bckScrollview.contentOffset = CGPointMake(0, 0);
    bckScrollview.pagingEnabled = YES;
    bckScrollview.showsHorizontalScrollIndicator = NO;
    bckScrollview.showsVerticalScrollIndicator = NO;
    bckScrollview.delegate = self;
    bckScrollview.alwaysBounceVertical = NO;
    bckScrollview.backgroundColor = [UIColor whiteColor];
    bckScrollview.delaysContentTouches = NO;
    bckScrollview.canCancelContentTouches = YES;
    [self.view addSubview:bckScrollview];
    [self initCollectionView];
}
#pragma mark -- 详情页添加数据/购物车删除数据
-(void)notafitionAction
{
    [self carNumData];
    [self relodCarData];
}
#pragma mark -- 置顶活动数据
-(void)initTopData
{
    if ([[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dpid":_shopId}];
        [HTTPTool getWithUrl:@"findzhiding.action" params:pram success:^(id json) {
            
            NSLog(@"json ======= %@",json);
            [topDataAry removeAllObjects];
            NSArray *ary = [json valueForKey:@"zhiding"];
            for (NSDictionary *dic in ary) {
                topActivityModel *mod = [[topActivityModel alloc]initWithContent:dic];
                [topDataAry addObject:mod];
            }
            if (topDataAry.count>0) {
                topActivityModel *mdd = topDataAry[0];
                UIView *tpv = [activityView viewWithTag:1101];
                UILabel *llb = (UILabel *)[tpv viewWithTag:1090];
                llb.text = mdd.jianjie;
                topDirection.alpha = 0.95;
                if(topDataAry.count>1){
                    //                    tpv.userInteractionEnabled = YES;
                    //                    topDirection.alpha = 0.95;
                }
                else{
                    //                    tpv.userInteractionEnabled = NO;
                    //                    topDirection.alpha = 0;
                }
            }
            [topActivity addSubview:activityTable];
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误2";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
#pragma mark -- 商品分类数据
-(void)loadShopTayData
{
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":_shopId,@"userid":user_id}];
    [HTTPTool getWithUrl:@"fenleishow.action" params:pram success:^(id json) {
        NSArray *ary = [json valueForKey:@"leibeilist"];
        [dbud hide:YES];
        if (ary.count >0) {
            NSArray *tyAry = ary[0];
            shopTypeDataAyr = [NSMutableArray arrayWithArray:tyAry];
            [shopTypeDataAyr insertObject:@"全部" atIndex:0];
            NSString *rexiao =[NSString stringWithFormat:@"%@",[ary[1] valueForKey:@"rexiao"]];
            if ([rexiao isEqualToString:@"1"]) {
                [shopTypeDataAyr insertObject:@"热销专区" atIndex:1];
            }
            for (int i = 0; i<shopTypeDataAyr.count; i++) {
                [pageAry addObject:@"1"];
            }
            [self initDataAry];
            [self headTypeView];
        }
    } failure:^(NSError *error) {
        [dbud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误3";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)initDataAry
{
    for (int i = 0; i<shopTypeDataAyr.count; i++) {
        [minPageAry addObject:@"1"];
        [maxPageAry addObject:@"1"];
        [allDataAry addObject:@[]];
    }
    [self loadListData];
    NSString *sty2= shopTypeDataAyr[1];
    [self loadTypData:sty2 direct:@"2"];
}
#pragma mark -- 获取列表数据
-(void)loadListData
{
    MBProgressHUD *md = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    md.mode = MBProgressHUDModeIndeterminate;
    md.delegate = self;
    md.labelText = @"请稍等...";
    if (!isRefresh) {
        [md show:YES];
    }
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_shopId,@"pageNum":@"1",@"userid":user_id}];
    [HTTPTool getWithUrl:@"shangpingshow1.action" params:pram success:^(id json) {
        [md hide:YES];
        NSLog(@"--00- json %@",json);
        
        NSDictionary *dc = (NSDictionary *)json;
        NSMutableArray *arys = [dc valueForKey:@"shoplist"];
        if (arys.count >0) {
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (int i = 0; i<arys.count; i++) {
                NSDictionary *dic = arys[i];
                shopModel *shModel = [[shopModel alloc]initWithContent:dic];
                [ary addObject:shModel];
            }
            [allDataAry replaceObjectAtIndex:0 withObject:ary];
            [self relodCarData];
            [leftCollecView reloadData];
        }
        else{
            if (isRefresh) {
                MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mHud.mode = MBProgressHUDModeCustomView;
                mHud.labelText = @"已经到底了";
                mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [self endRefresh:loadType];
            }
        }
    } failure:^(NSError *error) {
        [md hide:YES];
        [self endRefresh:loadType];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误4";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark -- 类别刷新数据
-(void)typeRefreshData:(NSString *)type
{
    NSInteger index = [self getAryIndex:type];
    NSString *maxPage = [NSString stringWithFormat:@"%@",maxPageAry[index]];
    NSString *minPage = [NSString stringWithFormat:@"%@",minPageAry[index]];
    NSString *pageNum = @"1";
    if (loadType) {
        pageNum = maxPage;
    }
    else{
        pageNum = minPage;
    }
    NSString *tyVal;
    if ([type isEqualToString:@"热销专区"]){
        tyVal = @"1";
    }
    else if ([type isEqualToString:@"全部"]){
        tyVal = @"0";
    }
    else
    {
        tyVal = type;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_shopId,@"pageNum":pageNum,@"leibei":tyVal,@"userid":user_id}];
    
    [HTTPTool getWithUrl:@"shangpingshow1.action" params:param success:^(id json) {
        NSDictionary *dc = (NSDictionary *)json;
        NSMutableArray *ary = [dc valueForKey:@"shoplist"];
        if (ary.count >0) {
            NSMutableArray *pgAry = allDataAry[index];
            if (loadType) {
                if ([maxPage integerValue] - [minPage integerValue]>2) {
                    for (int i = 0; i<16; i++) {
                        [pgAry removeObjectAtIndex:0];
                    }
                    NSString *minp = [NSString stringWithFormat:@"%ld",(long)[minPageAry[index] integerValue]+1];
                    [minPageAry replaceObjectAtIndex:index withObject:minp];
                }
                for (int i = 0; i<ary.count; i++) {
                    NSDictionary *dic = ary[i];
                    shopModel *shModel = [[shopModel alloc]initWithContent:dic];
                    [pgAry addObject:shModel];
                }
            }
            else{
                if ([maxPage integerValue] - [minPage integerValue]>2) {
                    NSInteger leg = pgAry.count;
                    for (int i = 0 ; i<leg-32; i++) {
                        [pgAry removeLastObject];
                    }
                    NSString *maxp = [NSString stringWithFormat:@"%ld",(long)[maxPageAry[index] integerValue]-1];
                    [maxPageAry replaceObjectAtIndex:index withObject:maxp];
                }
                NSInteger j = 0;
                for(NSDictionary *dic in ary){
                    shopModel *shModel = [[shopModel alloc]initWithContent:dic];
                    [pgAry insertObject:shModel atIndex:j];
                    j++;
                }
            }
            [allDataAry replaceObjectAtIndex:index withObject:pgAry];
            [leftCollecView reloadData];
            //            if ([maxPage integerValue] - [minPage integerValue]>2) {
            //                NSIndexPath *idnexPa = [NSIndexPath indexPathForRow:26 inSection:0];
            //                [leftCollecView scrollToItemAtIndexPath:idnexPa atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            //            }
        }
        else{
            if (loadType) {
                NSString *maxp = [NSString stringWithFormat:@"%ld",(long)[maxPage integerValue]-1];
                [maxPageAry replaceObjectAtIndex:index withObject:maxp];
                MBProgressHUD *mbd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbd.mode = MBProgressHUDModeCustomView;
                mbd.labelText = @"已经到底了";
                mbd.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbd showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else{
                NSString *minp = [NSString stringWithFormat:@"%ld",(long)[minPage integerValue]-1];
                [minPageAry replaceObjectAtIndex:index withObject:minp];
                MBProgressHUD *mbd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbd.mode = MBProgressHUDModeCustomView;
                mbd.labelText = @"已经到顶了";
                mbd.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbd showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
        [self endRefresh:loadType];
    } failure:^(NSError *error) {
        [self endRefresh:loadType];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误5";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//滑动改变类别
-(void)loadTypData:(NSString *)tpd direct:(NSString *)dir
{
    MyLog(@"loadTypData");
    NSString *tyVal;
    if ([tpd isEqualToString:@"热销专区"]){
        tyVal = @"1";
    }
    else
    {
        tyVal = tpd;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_shopId,@"pageNum":@"1",@"leibei":tyVal,@"userid":user_id}];
    [HTTPTool getWithUrl:@"shangpingshow1.action" params:param success:^(id json) {
        NSDictionary *dc = (NSDictionary *)json;
        NSMutableArray *ary = [dc valueForKey:@"shoplist"];
        if (ary.count >0){
            NSMutableArray *dty = [[NSMutableArray alloc]init];
            for (int i = 0; i<ary.count; i++) {
                NSDictionary *dic = ary[i];
                shopModel *shModel = [[shopModel alloc]initWithContent:dic];
                [dty addObject:shModel];
            }
            if ([dir isEqualToString:@"0"]) {
                [allDataAry replaceObjectAtIndex:typeNum-1 withObject:dty];
                if (typeNum==13) {
                    [listCollecView reloadData];
                }
                else
                    [leftCollecView reloadData];
            }
            else if ([dir isEqualToString:@"1"]){
                [allDataAry replaceObjectAtIndex:typeNum+1 withObject:dty];
                [rightCollecView reloadData];
            }
            else{
                [allDataAry replaceObjectAtIndex:typeNum+1 withObject:dty];
                [listCollecView reloadData];
            }
        }
        if (typeNum==0) {
            bckScrollview.contentOffset = CGPointMake(0, 0);
        }
        else if(typeNum == allDataAry.count-1){
            bckScrollview.contentOffset = CGPointMake(2*kDeviceWidth, 0);
        }
        else
        {
            bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误6";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

//点击选择类型
-(void)tapLoadTypeData:(NSString *)typ
{
    NSString *tyVal;
    if ([typ isEqualToString:@"热销专区"]){
        tyVal = @"1";
    }
    else
    {
        tyVal = typ;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_shopId,@"pageNum":@"1",@"leibei":tyVal,@"userid":user_id}];
    [HTTPTool getWithUrl:@"shangpingshow1.action" params:param success:^(id json) {
        NSDictionary *dc = (NSDictionary *)json;
        NSMutableArray *ary = [dc valueForKey:@"shoplist"];
        if (ary.count >0){
            NSMutableArray *dty = [[NSMutableArray alloc]init];
            for (int i = 0; i<ary.count; i++) {
                NSDictionary *dic = ary[i];
                shopModel *shModel = [[shopModel alloc]initWithContent:dic];
                [dty addObject:shModel];
            }
            [allDataAry replaceObjectAtIndex:typeNum withObject:dty];
        }
        [leftCollecView reloadData];
        [listCollecView reloadData];
        [rightCollecView reloadData];
        if (typeNum==0) {
            bckScrollview.contentOffset = CGPointMake(0, 0);
        }
        else if(typeNum == allDataAry.count-1){
            bckScrollview.contentOffset = CGPointMake(2*kDeviceWidth, 0);
        }
        else
        {
            bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误7";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(NSInteger)getAryIndex:(NSString *)typeName
{
    NSInteger index = 0;
    NSInteger i = 0;
    for(NSString *str in shopTypeDataAyr){
        if ([str isEqualToString:typeName]) {
            index = i;
            typeIndex = index;
            return index;
        }
        i++;
    }
    return index;
}
-(void)carNumData
{
    NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyuseridsid.action" params:pramDic success:^(id json) {
        if ([[json valueForKey:@"massage"]integerValue]==1) {//没商品
            [self footViewState:0];
        }
        else{
            [self footViewState:1];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误8";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)footViewState:(NSInteger)state
{
    if (!state) {
        whiteCar.image = [UIImage imageNamed:@"购物车-无"];
        whiteCar.userInteractionEnabled = NO;
        carEmptyImg.alpha = 1;
        numLabel.alpha = 0;
        totlMoney.alpha = 0;
        youhuiLabel.alpha = 0;
        chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
        chooseBtnView.userInteractionEnabled = NO;
    }
    else{
        whiteCar.image = [UIImage imageNamed:@"购物车-有"];
        whiteCar.userInteractionEnabled = YES;
        carEmptyImg.alpha = 0;
        numLabel.alpha = 1;
        totlMoney.alpha = 1;
        youhuiLabel.alpha = 1;
        chooseBtnView.image = [UIImage imageNamed:@"选好了红色"];
        chooseBtnView.userInteractionEnabled = YES;
    }
}
//获取购物车数量 及总价
-(void)relodCarData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id,@"car.dianpuid":_shopId}];
    [HTTPTool getWithUrl:@"dianpuprice.action" params:pram success:^(id json) {
        numLabel.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"shuliangs"]];
        totlMoney.text = [NSString stringWithFormat:@"¥%.2f",[[json valueForKey:@"totalPrice"] floatValue]];
        CGSize tolSize = [totlMoney.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15], NSFontAttributeName,nil] context:nil].size;
        totlMoney.frame = CGRectMake(95*MCscale, 10, tolSize.width, 30);
        if ([[json valueForKey:@"jianmoneys"] integerValue]==0) {
            if ([[json valueForKey:@"cha"] integerValue]==0) {
                youhuiLabel.alpha = 0;
            }
            else
                if ([[json valueForKey:@"totalPrice"] floatValue]<=0) {
                    youhuiLabel.alpha = 0;
                }
                else{
                    youhuiLabel.alpha = 1;
                    youhuiLabel.text = [NSString stringWithFormat:@"还差¥%@",[json valueForKey:@"cha"]];
                }
        }
        else{
            youhuiLabel.alpha = 1;
            youhuiLabel.text = [NSString stringWithFormat:@"优惠¥%@",[json valueForKey:@"jianmoneys"]];
        }
        CGSize yhSize = [youhuiLabel.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_7], NSFontAttributeName,nil] context:nil].size;
        youhuiLabel.frame = CGRectMake(totlMoney.right+2, 17, yhSize.width, 20);
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误9";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//遮罩层
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightMaskdisms)];
    [maskView addGestureRecognizer:tap];
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.headerReferenceSize = CGSizeMake(kDeviceWidth, 15);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(kDeviceWidth, 15);
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout2.headerReferenceSize = CGSizeMake(kDeviceWidth, 15);
    if ([[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        leftCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout1];
        listCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout];
        rightCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(kDeviceWidth*2, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout2];
    }
    else{
        leftCollecView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout1];
        listCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout];
        rightCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(kDeviceWidth*2, 0, kDeviceWidth, bckScrollview.frame.size.height) collectionViewLayout:flowLayout2];
    }
    //左侧
    leftCollecView.delegate = self;
    leftCollecView.dataSource = self;
    leftCollecView.alwaysBounceVertical = YES;
    leftCollecView.backgroundColor = [UIColor whiteColor];
    [bckScrollview addSubview:leftCollecView];
    [leftCollecView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    [leftCollecView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusablView"];
    //中间
    listCollecView.delegate = self;
    listCollecView.dataSource = self;
    listCollecView.alwaysBounceVertical = YES;
    listCollecView.backgroundColor = [UIColor whiteColor];
    [bckScrollview addSubview:listCollecView];
    [listCollecView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [listCollecView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusablView"];
    //右侧
    rightCollecView.delegate = self;
    rightCollecView.dataSource = self;
    rightCollecView.alwaysBounceVertical = YES;
    rightCollecView.backgroundColor = [UIColor whiteColor];
    [bckScrollview addSubview:rightCollecView];
    [rightCollecView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
    [rightCollecView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusablView"];
}
-(void)initHeadView
{
    if (![[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        activityView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, SCTypeHeight+5*MCscale)];
    }
    else{
        activityView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 35*MCscale+SCTypeHeight+5*MCscale)];
    }
    activityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:activityView];
    UIView *actView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    actView.backgroundColor = [UIColor whiteColor];
    actView.tag = 1101;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activityAction:)];
    [actView addGestureRecognizer:tap];
    
    UILabel *activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 80*MCscale, 20)];
    activityLabel.text = @"置顶活动";
    activityLabel.textAlignment = NSTextAlignmentLeft;
    activityLabel.backgroundColor = [UIColor clearColor];
    activityLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    activityLabel.userInteractionEnabled = YES;
    [actView addSubview:activityLabel];
    UILabel *ttle = [[UILabel alloc]initWithFrame:CGRectMake(activityLabel.right, 8, 200*MCscale, 20)];
    ttle.text = @"";
    ttle.tag = 1090;
    ttle.textColor = textBlackColor;
    ttle.textAlignment = NSTextAlignmentLeft;
    ttle.backgroundColor = [UIColor clearColor];
    ttle.font = [UIFont systemFontOfSize:MLwordFont_7];
    ttle.userInteractionEnabled = YES;
    [actView addSubview:ttle];
    topDirection = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-25, 8, 15, 20)];
    topDirection.backgroundColor = [UIColor clearColor];
    topDirection.image = [UIImage imageNamed:@"下拉键"];
    [actView addSubview:topDirection];
    
    activityPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 94, kDeviceWidth, kDeviceHeight-94)];
    activityPopView.alpha = 0;
    activityPopView.backgroundColor = [UIColor whiteColor];
    activityPopView.layer.cornerRadius = 15.0;
    activityPopView.layer.shadowRadius = 5.0;
    activityPopView.layer.shadowOpacity = 0.5;
    activityPopView.layer.shadowOffset = CGSizeMake(0, 0);
    
    topActivity = [[UIView alloc]initWithFrame:CGRectMake(0, 94, kDeviceWidth, 200)];
    topActivity.alpha = 0;
    activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, topActivity.height) style:UITableViewStyleGrouped];
    activityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    activityTable.delegate = self;
    activityTable.dataSource = self;
    activityTable.backgroundColor = [UIColor clearColor];
    activityPopView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *disTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiViewDiss)];
    [activityPopView addGestureRecognizer:disTap];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, actView.bottom, kDeviceWidth, 3)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = lineColor;
    if ([[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        [activityView addSubview:actView];
        [activityView addSubview:line];
        line2.frame = CGRectMake(0, 39+SCTypeHeight,kDeviceWidth , 1);
    }
    else{
        line2.frame = CGRectMake(0, SCTypeHeight+6,kDeviceWidth , 1);
    }
    [activityView addSubview:line2];
}
-(void)headTypeView
{
    MyLog(@"headTypeView");
    UIView *btnView = [[UIView alloc]init];
    if ([[NSString stringWithFormat:@"%@",_isHuodong] isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
        btnView.frame = CGRectMake(0, 38, kDeviceWidth, SCTypeHeight);
    }
    else
    {
        btnView.frame = CGRectMake(0, 5, kDeviceWidth, SCTypeHeight);
    }
    btnView.backgroundColor = [UIColor whiteColor];
    [activityView addSubview:btnView];
    scrol = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCTypeHeight)];
    scrol.backgroundColor = [UIColor clearColor];
    
    CGFloat countLength;
    countLength = 0;
    for (int i = 0; i<shopTypeDataAyr.count; i++) {
        NSString *str = shopTypeDataAyr[i];
        CGSize size = [str boundingRectWithSize:CGSizeMake(250, SCTypeHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_4],NSFontAttributeName, nil] context:nil].size;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5+countLength, 0, size.width+8, SCTypeHeight)];
        NSString *tywid = [NSString stringWithFormat:@"%lf",size.width+8];
        [allTypeWidths addObject:tywid];
        title.tag = i+1;
        title.userInteractionEnabled = YES;
        if(i==0){
            title.backgroundColor = txtColors(67, 205, 166, 1);
            title.textColor = [UIColor whiteColor];
        }
        else{
            title.backgroundColor = [UIColor clearColor];
            title.textColor = textColors;
        }
        title.textAlignment = NSTextAlignmentCenter;
        title.text = shopTypeDataAyr[i];
        title.font = [UIFont systemFontOfSize:MLwordFont_4];
        [scrol addSubview:title];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectItem:)];
        [title addGestureRecognizer:tap];
        countLength +=size.width+8;
    }
    scrol.contentSize = CGSizeMake(countLength+20, SCTypeHeight);
    scrol.showsHorizontalScrollIndicator = NO;
    [btnView addSubview:scrol];
}
-(void)popView
{
    bubbleView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20, 50,97*MCscale ,126*MCscale)];
    bubbleView.alpha = 0;
    bubbleView.userInteractionEnabled = YES;
    bubbleView.image = [UIImage imageNamed:@"菜单"];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(22*MCscale, 32*MCscale+i*35*MCscale, kDeviceWidth*2/5.0-22*MCscale, 30*MCscale);
        btn.tag = 10+i;
        [self customButton:btn];
        [bubbleView addSubview:btn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(22*MCscale,btn.bottom, kDeviceWidth*2/5.0-22*MCscale,1)];
        line.backgroundColor = lineColor;
        [bubbleView addSubview:line];
    }
}
-(void)customButton:(UIButton *)sender
{
    sender.imageEdgeInsets = UIEdgeInsetsMake(6*MCscale,15*MCscale,6*MCscale,95*MCscale);
    sender.titleEdgeInsets = UIEdgeInsetsMake(0,0*MCscale,0, 0);
    sender.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    sender.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sender setTitleColor:txtColors(100, 100, 100, 1) forState:UIControlStateNormal];
    NSInteger index = sender.tag - 10;
    sender.backgroundColor = [UIColor clearColor];
    [sender setTitle:titleArray[index] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [sender setImage:[UIImage imageNamed:imageArray[index]] forState:UIControlStateNormal];
    
}

//初始化底部视图
-(void)initfootView
{
    fotView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    fotView.backgroundColor = txtColors(25, 182, 133, 0.8);
    [self.view addSubview:fotView];
    whiteCar = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale, -15, 60*MCscale, 60*MCscale)];
    whiteCar.backgroundColor = [UIColor clearColor];
    whiteCar.image = [UIImage imageNamed:@"购物车-无"];
    whiteCar.tag = 1001;
    whiteCar.userInteractionEnabled = NO;
    [fotView addSubview:whiteCar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteCarAction)];
    [whiteCar addGestureRecognizer:tap];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(43*MCscale, 14*MCscale, 16*MCscale, 16*MCscale)];
    numLabel.tag = 1002;
    numLabel.backgroundColor = txtColors(237, 58, 76, 1);
    numLabel.layer.cornerRadius = 8.0;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = @"0";
    numLabel.alpha = 0;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    numLabel.layer.masksToBounds = YES;
    [whiteCar addSubview:numLabel];
    //购物车无商品
    carEmptyImg = [[UIImageView alloc]initWithFrame:CGRectMake(whiteCar.right, 15, 150*MCscale, 20)];
    carEmptyImg.alpha = 0;
    carEmptyImg.backgroundColor = [UIColor clearColor];
    carEmptyImg.image = [UIImage imageNamed:@"empty"];
    [fotView addSubview:carEmptyImg];
    
    totlMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    totlMoney.backgroundColor = [UIColor clearColor];
    totlMoney.textColor = txtColors(237, 58, 76, 1);
    totlMoney.textAlignment = NSTextAlignmentLeft;
    totlMoney.alpha = 0;
    totlMoney.font = [UIFont systemFontOfSize:MLwordFont_15];
    [fotView addSubview:totlMoney];
    //优惠
    youhuiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    youhuiLabel.text = @"";
    youhuiLabel.alpha = 0;
    youhuiLabel.textAlignment = NSTextAlignmentLeft;
    youhuiLabel.textColor = textBlackColor;
    youhuiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [fotView addSubview:youhuiLabel];
    
    chooseBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-120*MCscale, 10, 100*MCscale, 30*MCscale)];
    chooseBtnView.backgroundColor = [UIColor clearColor];
    chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
    chooseBtnView.userInteractionEnabled = YES;
    [fotView addSubview:chooseBtnView];
    UITapGestureRecognizer *chosetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAction)];
    [chooseBtnView addGestureRecognizer:chosetap];
    [self carNumData];
}
#pragma mark ---UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topDataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identif = @"mcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
        image.backgroundColor =[UIColor clearColor];
        image.tag = 10011;
        [cell.contentView addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = txtColors(242, 61, 73, 1);
        label.font = [UIFont systemFontOfSize:MLwordFont_4];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 10012;
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectZero];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = textBlackColor;
        label1.font = [UIFont systemFontOfSize:MLwordFont_9];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.tag = 10013;
        [cell.contentView addSubview:label1];
    }
    if(topDataAry.count == 1){
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
        line.backgroundColor = lineColor;
        [cell addSubview:line];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height + 15*MCscale, kDeviceWidth, 1)];
        line1.backgroundColor = lineColor;
        [cell addSubview:line1];
    }
    else{
        if (indexPath.row == 0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
            line.backgroundColor = lineColor;
            [cell addSubview:line];
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale,cell.height + 15*MCscale, kDeviceWidth-20*MCscale, 0.5)];
            line1.backgroundColor = lineColor;
            [cell addSubview:line1];
        }
        else if (indexPath.row == topDataAry.count-1 )
        {
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height + 15*MCscale, kDeviceWidth, 1)];
            line1.backgroundColor = lineColor;
            [cell addSubview:line1];
        }
        else
        {
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale,cell.height + 15*MCscale, kDeviceWidth-20*MCscale, 0.5)];
            line1.backgroundColor = lineColor;
            [cell addSubview:line1];
        }
    }
    topActivityModel *topModel = topDataAry[indexPath.row];
    UIImageView *image = (UIImageView *)[cell viewWithTag:10011];
    image.frame = CGRectMake(20, 10, 40, 40);
    [image sd_setImageWithURL:[NSURL URLWithString:topModel.tupian] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10012];
    label.frame = CGRectMake(image.right+10, image.top, kDeviceWidth-80, 20);
    label.text = topModel.biaoti;
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:10013];
    label1.frame = CGRectMake(image.right+10, label.bottom, kDeviceWidth-80, 20);
    label1.text = topModel.jianjie;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*MCscale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self activiViewDiss];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (allDataAry.count>0) {
        if (collectionView == leftCollecView) {
            if (allDataAry.count>scroPage-1) {
                if (![allDataAry[scroPage-1] isEqual:nil]) {
                    NSMutableArray *ary = allDataAry[scroPage-1];
                    return ary.count;
                }
                else
                    return 0;
            }
            else
                return 0;
        }
        else if (collectionView == listCollecView){
            if (allDataAry.count>scroPage) {
                if (![allDataAry[scroPage] isEqual:nil]) {
                    NSMutableArray *ary = allDataAry[scroPage];
                    return ary.count;
                }
                else
                    return 0;
            }
            else
                return 0;
        }
        else{
            if (allDataAry.count>scroPage+1) {
                if (![allDataAry[scroPage+1] isEqual:nil]) {
                    NSMutableArray *ary = allDataAry[scroPage+1];
                    return ary.count;
                }
                else
                    return 0;
            }
            else
                return 0;
        }
    }
    else
        return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == leftCollecView) {
        static NSString *identifier = @"cell1";
        shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell sizeToFit];
        NSMutableArray *ary = allDataAry[scroPage-1];
        if(ary.count>0){
            shopModel *shModel = ary[indexPath.row];
            [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:shModel.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            NSString *biaoq = [NSString stringWithFormat:@"%@",shModel.biaoqian];
            if (![biaoq isEqualToString:@"1"] && ![biaoq isEqualToString:@""]) {
                MyLog(@"--- 111 --- ");
                [cell.shangbiao sd_setImageWithURL:[NSURL URLWithString:shModel.biaoqian]];
            }
            
            NSString *zhuangtai = [NSString stringWithFormat:@"%@",shModel.zhuangtai];
            NSLog(@"状态%@",zhuangtai);
            
            if (zhuangtai.length > 11) {
                cell.tishiLabel.text = zhuangtai;
                cell.tishiLabel.backgroundColor = [UIColor grayColor];
                cell.goinShopCar.hidden = YES;
            }
            else {
                if([zhuangtai isEqualToString:@"A"])
                {
                    
                }
                else if ([zhuangtai integerValue] < 1) {
                    cell.tishiLabel.text = @"已售完";
                    cell.tishiLabel.backgroundColor = [UIColor grayColor];
                    cell.goinShopCar.hidden = YES;
                }
            }
            
            cell.goodTitle.text = shModel.shangpinname;
            NSString *pric = [NSString stringWithFormat:@"%.2f",[shModel.xianjia floatValue]];
            cell.nowPrice.text =[NSString stringWithFormat:@"¥%@",pric] ;
            cell.oldPrice.text = [NSString stringWithFormat:@"原价:%.1f",[shModel.yuanjia floatValue]];
            if ([shModel.yuanjia floatValue] >0) {
                cell.oldPrice .alpha =1;
            }
            else
                cell.oldPrice.alpha = 0;
            CGSize size = [cell.oldPrice.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
            cell.oldPrice.size = CGSizeMake(size.width, 20);
            
            [cell.goinShopCar addTarget:self action:@selector(goinShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
            cell.goinShopCar.tag = indexPath.row;
            [btnArray addObject:cell.goinShopCar];
            cell.backgroundColor = [UIColor whiteColor];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"5网络连接错误10";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        return cell;
    }
    else if (collectionView == listCollecView){
        static NSString *identifier = @"cell";
        shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell sizeToFit];
        NSMutableArray *ary = allDataAry[scroPage];
        if(ary.count>0){
            shopModel *shModel = ary[indexPath.row];
            [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:shModel.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            NSString *biaoq = [NSString stringWithFormat:@"%@",shModel.biaoqian];
            if (![biaoq isEqualToString:@"0"]) {
                [cell.shangbiao sd_setImageWithURL:[NSURL URLWithString:shModel.biaoqian]];
            }
            
            NSString *zhuangtai = [NSString stringWithFormat:@"%@",shModel.zhuangtai];
            if (zhuangtai.length > 11) {
                cell.tishiLabel.text = zhuangtai;
                cell.tishiLabel.backgroundColor = [UIColor grayColor];
                cell.goinShopCar.hidden = YES;
            }
            else {
                if ([zhuangtai isEqualToString:@"0"]) {
                    cell.tishiLabel.text = @"已售完";
                    cell.tishiLabel.backgroundColor = [UIColor grayColor];
                    cell.goinShopCar.hidden = YES;
                }
            }
            
            cell.goodTitle.text = shModel.shangpinname;
            NSString *pric = [NSString stringWithFormat:@"%.2f",[shModel.xianjia floatValue]];
            cell.nowPrice.text =[NSString stringWithFormat:@"¥%@",pric] ;
            cell.oldPrice.text = [NSString stringWithFormat:@"原价:%.1f",[shModel.yuanjia floatValue]];
            if ([shModel.yuanjia floatValue] >0) {
                cell.oldPrice .alpha =1;
            }
            else
                cell.oldPrice.alpha = 0;
            CGSize size = [cell.oldPrice.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
            cell.oldPrice.size = CGSizeMake(size.width, 20);
            [cell.goinShopCar addTarget:self action:@selector(goinShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
            cell.goinShopCar.tag = indexPath.row;
            [btnArray addObject:cell.goinShopCar];
            cell.backgroundColor = [UIColor whiteColor];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"6网络连接错误11";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        return cell;
    }
    else{
        static NSString *identifier = @"cell2";
        shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell sizeToFit];
        NSMutableArray *ary = allDataAry[scroPage+1];
        if(ary.count>0){
            shopModel *shModel = ary[indexPath.row];
            [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:shModel.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
            NSString *biaoq = [NSString stringWithFormat:@"%@",shModel.biaoqian];
            if (![biaoq isEqualToString:@"0"]) {
                [cell.shangbiao sd_setImageWithURL:[NSURL URLWithString:shModel.biaoqian]];
            }
            
            NSString *zhuangtai = [NSString stringWithFormat:@"%@",shModel.zhuangtai];
            if (zhuangtai.length > 11) {
                cell.tishiLabel.text = zhuangtai;
                cell.tishiLabel.backgroundColor = [UIColor grayColor];
                cell.goinShopCar.hidden = YES;
            }
            else {
                if ([zhuangtai isEqualToString:@"0"]) {
                    cell.tishiLabel.text = @"已售完";
                    cell.tishiLabel.backgroundColor = [UIColor grayColor];
                    cell.goinShopCar.hidden = YES;
                }
            }
            cell.goodTitle.text = shModel.shangpinname;
            NSString *pric = [NSString stringWithFormat:@"%.2f",[shModel.xianjia floatValue]];
            cell.nowPrice.text =[NSString stringWithFormat:@"¥%@",pric] ;
            cell.oldPrice.text = [NSString stringWithFormat:@"原价:%.1f",[shModel.yuanjia floatValue]];
            if ([shModel.yuanjia floatValue] >0) {
                cell.oldPrice .alpha =1;
            }
            else
                cell.oldPrice.alpha = 0;
            CGSize size = [cell.oldPrice.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
            cell.oldPrice.size = CGSizeMake(size.width, 20);
            [cell.goinShopCar addTarget:self action:@selector(goinShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
            cell.goinShopCar.tag = indexPath.row;
            [btnArray addObject:cell.goinShopCar];
            cell.backgroundColor = [UIColor whiteColor];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误12";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        return cell;
    }
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
    GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
    NSMutableArray *ary = allDataAry[typeIndex];
    if (ary.count > 0) {
        shopModel *shModel = ary[indexPath.row];
        goodDetail.goodId = shModel.shanpinid;
        goodDetail.dianpuId = _shopId;
        goodDetail.godShequid = userShequ_id;
        goodDetail.goodtag = shModel.biaoqian;
        goodDetail.zhuangtai = shModel.zhuangtai;
        [self.navigationController pushViewController:goodDetail animated:YES];
    }
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *str = [NSString stringWithFormat:@"%.2f",scrollView.contentOffset.x];
    [xlengthsAry addObject:str];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //        bckScrollview.panGestureRecognizer.enabled = YES;
    NSString *fir = xlengthsAry[0];
    NSString *las = [xlengthsAry lastObject];
    CGFloat lw = fabs([las floatValue] - [fir floatValue]);
    if (!isRefresh && lw>200){
        isRefresh = 0;
        CGFloat allbtnWid = scrol.contentSize.width; //类型总长度
        NSInteger dataNum = allDataAry.count;
        CGFloat tyw = 0.0;
        for (int i = 0; i<=typeNum; i++){
            tyw = tyw + [allTypeWidths[i] floatValue];
        }
        //判断方向
        if(bckScrollview.contentOffset.x == 0 && scroPage>1){
            scroPage--;
            typeIndex = scroPage;
        }
        else if(bckScrollview.contentOffset.x == 2*kDeviceWidth && scroPage<dataNum-2){
            scroPage++;
            typeIndex = scroPage;
        }
        else{
            if (bckScrollview.contentOffset.x - lastoffl>=0 && bckScrollview.contentOffset.x>0) {
                if (typeNum<dataNum-1){
                    typeNum++;
                    typeIndex = typeNum;
                    if (typeNum+1<=dataNum-1){
                        NSArray *lary = allDataAry[typeNum+1];
                        if (lary.count == 0) {
                            NSString *sty= shopTypeDataAyr[typeNum+1];
                            [self loadTypData:sty direct:@"1"];
                        }
                    }
                    if(allbtnWid<=kDeviceWidth){
                        scrol.contentOffset = CGPointMake(0, 0);
                    }
                    else{
                        if(tyw < kDeviceWidth/2.0-60){
                            scrol.contentOffset = CGPointMake(0, 0);
                        }
                        else if ((tyw>=kDeviceWidth/2.0 - 60) && ((allbtnWid - tyw)>=kDeviceWidth)){
                            scrol.contentOffset = CGPointMake(tyw+60-kDeviceWidth/2.0, 0);
                        }
                        else if ((allbtnWid - tyw) < kDeviceWidth){
                            scrol.contentOffset = CGPointMake(allbtnWid-kDeviceWidth, 0);
                        }
                    }
                }
            }
            else{
                if (typeNum>0) {
                    typeNum--;
                    typeIndex = typeNum;
                    if (typeNum-1>1) {
                        NSArray *lary = allDataAry[typeNum-1];
                        if (lary.count == 0) {
                            NSString *sty= shopTypeDataAyr[typeNum-1];
                            [self loadTypData:sty direct:@"0"];
                        }
                    }
                    CGFloat remWit = allbtnWid-tyw;
                    if(allbtnWid<=kDeviceWidth){
                        scrol.contentOffset = CGPointMake(0, 0);
                    }
                    else{
                        if (remWit<kDeviceWidth/2.0-60) {
                            scrol.contentOffset = CGPointMake(allbtnWid-kDeviceWidth, 0);
                        }
                        else if (remWit>=kDeviceWidth/2.0-60 && tyw>= kDeviceWidth) {
                            scrol.contentOffset = CGPointMake(tyw-kDeviceWidth+60, 0);
                        }
                        else if ((tyw) < kDeviceWidth){
                            scrol.contentOffset = CGPointMake(0, 0);
                        }
                    }
                }
            }
            NSArray *lary = allDataAry[typeNum];
            if (lary.count == 0) {
                NSString *sty= shopTypeDataAyr[typeNum];
                [self tapLoadTypeData:sty];
            }
            if (lastBtnTag != typeNum+1){
                UILabel *nowLabel = (UILabel *)[scrol viewWithTag:typeNum+1];
                nowLabel.backgroundColor = txtColors(67, 205, 166, 1);
                nowLabel.textColor = [UIColor whiteColor];
                UILabel *lasLabel = (UILabel *)[scrol viewWithTag:lastBtnTag];
                lasLabel.backgroundColor = [UIColor whiteColor];
                lasLabel.textColor = textColors;
                lastBtnTag = typeNum+1;
            }
            [rightCollecView reloadData];
            if(typeNum <= allDataAry.count-2 && typeNum>=1){
                bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
            }
            [listCollecView setContentOffset:CGPointMake(0,0) animated:NO];
            [xlengthsAry removeAllObjects];
            return;
        }
        //滑动分类联动
        if (bckScrollview.contentOffset.x - lastoffl>=0 && bckScrollview.contentOffset.x>0) {
            if (typeNum<dataNum-1) {
                typeNum++;
                typeIndex = typeNum;
                if (typeNum+1<=dataNum-1){
                    NSArray *lary = allDataAry[typeNum+1];
                    if (lary.count == 0){
                        NSString *sty= shopTypeDataAyr[typeNum+1];
                        [self loadTypData:sty direct:@"1"];
                    }
                }
                if(allbtnWid<=kDeviceWidth){
                    scrol.contentOffset = CGPointMake(0, 0);
                }
                else{
                    if(tyw < kDeviceWidth/2.0-60){
                        scrol.contentOffset = CGPointMake(0, 0);
                    }
                    else if ((tyw>=kDeviceWidth/2.0 - 60) && ((allbtnWid - tyw)>=kDeviceWidth)){
                        scrol.contentOffset = CGPointMake(tyw+60-kDeviceWidth/2.0, 0);
                    }
                    else if ((allbtnWid -tyw) < kDeviceWidth){
                        scrol.contentOffset = CGPointMake(allbtnWid-kDeviceWidth, 0);
                    }
                }
            }
        }
        else{
            if (typeNum>0){
                typeNum--;
                if (typeNum-1>1){
                    NSArray *lary = allDataAry[typeNum-1];
                    if (lary.count == 0) {
                        NSString *sty= shopTypeDataAyr[typeNum-1];
                        [self loadTypData:sty direct:@"0"];
                    }
                }
                CGFloat remWit = allbtnWid-tyw;
                if(allbtnWid<=kDeviceWidth){
                    scrol.contentOffset = CGPointMake(0, 0);
                }
                else{
                    if (remWit<kDeviceWidth/2.0-60){
                        scrol.contentOffset = CGPointMake(allbtnWid-kDeviceWidth, 0);
                    }
                    else if (remWit>=kDeviceWidth/2.0-60 && tyw>= kDeviceWidth) {
                        scrol.contentOffset = CGPointMake(tyw-kDeviceWidth+60, 0);
                    }
                    else if ((tyw) < kDeviceWidth){
                        scrol.contentOffset = CGPointMake(0, 0);
                    }
                }
            }
        }
        NSArray *lary = allDataAry[typeNum];
        if (lary.count == 0) {
            NSString *sty= shopTypeDataAyr[typeNum];
            [self tapLoadTypeData:sty];
        }
        if (lastBtnTag != typeNum+1){
            UILabel *nowLabel = (UILabel *)[scrol viewWithTag:typeNum+1];
            nowLabel.backgroundColor = txtColors(67, 205, 166, 1);
            nowLabel.textColor = [UIColor whiteColor];
            UILabel *lasLabel = (UILabel *)[scrol viewWithTag:lastBtnTag];
            lasLabel.backgroundColor = [UIColor whiteColor];
            lasLabel.textColor = textColors;
            lastBtnTag = typeNum+1;
        }
        lastoffl = bckScrollview.contentOffset.x;
        bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
        [leftCollecView reloadData];
        [listCollecView reloadData];
        [rightCollecView reloadData];
        [listCollecView setContentOffset:CGPointMake(0,0) animated:NO];
    }
    if(typeNum <= allDataAry.count-2 && typeNum>=1){
        bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
    }
    isRefresh = 0;
    [xlengthsAry removeAllObjects];
}

#pragma mark -- btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (btn.tag == 1002) {
        if (ritBtnBol == 0) {
            ritBtnBol =1;
            [UIView animateWithDuration:0.3 animations:^{
                [self.navigationController.view addSubview:bubbleView];
                [self.view addSubview:maskView];
                bubbleView.alpha = 0.95;
                bubbleView.frame = CGRectMake(kDeviceWidth*3/5.0-27, 52, kDeviceWidth*5/11.0, 220*MCscale);
            }];
        }
        else{
            ritBtnBol = 0;
            [UIView animateWithDuration:0.3 animations:^{
                bubbleView.frame = CGRectMake(kDeviceWidth-30, 50, 0, 0);
                bubbleView.alpha = 0;
                [maskView removeFromSuperview];
            }];
            [self performSelector:@selector(removeViews) withObject:nil afterDelay:0.3];
        }
    }
}
-(void)removeViews
{
    [bubbleView removeFromSuperview];
}
//弹框选项事件
-(void)popAction:(UIButton *)btn
{
    if(btn.tag ==10 ){
        searchViewController *search = [[searchViewController alloc]init];
        search.viewTag = 2;
        search.dianpuId = self.shopId;
        [self.navigationController pushViewController:search animated:YES];
    }
    else if (btn.tag == 11) {
        [self receiveNewGift];
    }
    else if (btn.tag == 12) {
        ShopDetailViewController *shop = [[ShopDetailViewController alloc]init];
        shop.dianpuId = _shopId;
        [self.navigationController pushViewController:shop animated:YES];    }
    else{
        [self addShopShouCang];
    }
    ritBtnBol = 0;
    [UIView animateWithDuration:0.3 animations:^{
        bubbleView.frame = CGRectMake(kDeviceWidth-30, 50, 0, 0);
        bubbleView.alpha = 0;
        [maskView removeFromSuperview];
    }];
    [self performSelector:@selector(removeViews) withObject:nil afterDelay:0.3];
}
#pragma mark -- 添加收藏
-(void)addShopShouCang
{
    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
    if ([sdf integerForKey:@"isLogin"]==1) {
        [bubbleView removeFromSuperview];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shoucang.userid":user_id,@"shoucang.shoucangtype":@"0",@"shoucang.shopid":@"0",@"shoucang.shequid":userShequ_id,@"shoucang.dianpuid":_shopId}];
        [HTTPTool getWithUrl:@"shoucang.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                MBProgressHUD *bHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bHud.mode = MBProgressHUDModeText;
                bHud.labelText = @"收藏成功";
                [bHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                NSNotification *goodPageNotification = [NSNotification notificationWithName:@"shopAddShoucang" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:goodPageNotification];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shopAddShoucang" object:nil];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误13";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    else{
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"登录后才可以收藏店铺";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark 分享店铺
-(void)receiveNewGift
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":_shopId}];
    [HTTPTool getWithUrl:@"shareShop.action" params:pram success:^(id json) {
        NSLog(@"分享店铺 %@",json);
        
        if([[json valueForKey:@"message"] integerValue]==1){
            NSString *urll= @"http://www.m1ao.com/Mshc/register.jsp";
            NSString *imagePath = [NSString stringWithFormat:@"%@",[json valueForKey:@"dianpulogo"]];
            NSString *hongMessage = [json valueForKey:@"dianpuname"];
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
                                                 [self requestNetworkWrong:@"分享成功"];
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
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误14";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

//置顶活动
-(void)activityAction:(UITapGestureRecognizer *)tap
{
    if (!topTapNum) {
        angle = 3.1415926*90/180.0;
        [UIView animateWithDuration:0.3 animations:^{
            [topDirection.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
            activityPopView.alpha = 0.95;
            [self.view addSubview:activityPopView];
            topActivity.alpha = 0.95;
            [self.view addSubview:topActivity];
        }];
        topTapNum = 1;
    }
    else{
        [self activiViewDiss];
    }
}
//置顶活动遮罩消失
-(void)activiViewDiss
{
    topTapNum = 0;
    angle = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [topDirection.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
        activityPopView.alpha = 0;
        [activityPopView removeFromSuperview];
        topActivity.alpha = 0;
        [topActivity removeFromSuperview];
    }];
}
//导航右面按钮遮罩
-(void)rightMaskdisms
{
    ritBtnBol = 0;
    [UIView animateWithDuration:0.3 animations:^{
        bubbleView.frame = CGRectMake(kDeviceWidth-30, 50, 0, 0);
        bubbleView.alpha = 0;
        [maskView removeFromSuperview];
    }];
    [self performSelector:@selector(removeViews) withObject:nil afterDelay:0.3];
}
//加入购物车
-(void)goinShoppingCar:(UIButton *)btn
{
    NSMutableArray *ary = allDataAry[typeIndex];
    shopModel *shModel = ary[btn.tag];
    NSString *goodId = [NSString stringWithFormat:@"%@",shModel.shanpinid];
    NSString *label = [NSString stringWithFormat:@"%@",shModel.biaoqian];
    if ([label isEqualToString:@"1"] || [label isEqualToString:@""]) {
        [self addcardAnimation:btn];
    }
    else{
        NSString *cutLabelStr = [label substringFromIndex:45];
        MyLog(@"%@",cutLabelStr);
        if ([cutLabelStr isEqualToString:@"tehui.png"]) {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shangpinid":goodId}];
            [HTTPTool getWithUrl:@"findbycarshop.action" params:pram success:^(id json) {
                NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
                if ([massage isEqualToString:@"3"]){//已存在该商品
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"该特惠商品购物车已存在";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else{
                    [self addcardAnimation:btn];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误15";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            [self addcardAnimation:btn];
        }
    }
}
-(void)addcardAnimation:(UIButton *)btn
{
    for (UIButton *btns in btnArray) {
        btns.userInteractionEnabled = NO;
    }
    [self addDataInCar:btn.tag];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [goodAry addObject:str];
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"购物车圆点"];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=CGRectMake(0, 0, 10, 10);
    imageView.hidden=YES;
    
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=imageView.layer.contents;
    anmiatorlayer.frame=imageView.frame;
    anmiatorlayer.opacity=1;
    [self.view.layer addSublayer:anmiatorlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/3;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=1;
    animation.delegate=self;
    animation.autoreverses= NO;
    [animation setValue:@"yingmeiji_buy" forKey:@"MyAnimationType_yingmeiji"];
    [anmiatorlayer addAnimation:animation forKey:@"yingmiejibuy"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer];
        anmiatorlayer.hidden=YES;
        for (UIButton *btns in btnArray) {
            btns.userInteractionEnabled = YES;
        }
    }
}
#pragma mark -- 加入购物车数据
-(void)addDataInCar:(NSInteger )index
{
    NSMutableArray *ary = allDataAry[typeIndex];
    shopModel *shModel = ary[index];
    godId = shModel.shanpinid;
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shangpinid":godId,@"userid":user_id,@"shequid":userShequ_id,@"car.dianpuid":_shopId}];
    [HTTPTool getWithUrl:@"addcarone.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"]integerValue]==0) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"添加失败";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else if ([[json valueForKey:@"massages"]integerValue]==1 || [[json valueForKey:@"massages"]integerValue]==2) {
            [self relodCarData];
            [self footViewState:1];
            NSNotification *shopNotification = [NSNotification notificationWithName:@"shopAddGoods" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:shopNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shopAddGoods" object:nil];
        }
        //        else if ([[json valueForKey:@"massages"]integerValue]==2) {
        //
        //        }
        else if ([[json valueForKey:@"massages"]integerValue]==3) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"当前商品库存不足";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"当前数量已达到活动上限";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误16";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//选择类别
-(void)selectItem:(UITapGestureRecognizer *)tap
{
    isRefresh = 0;
    NSInteger btnTage = tap.view.tag;
    typeIndex = btnTage - 1;
    typeNum = typeIndex;
    if (typeNum == allDataAry.count-1) {
        lastoffl = 750.0;
    }
    if (typeIndex>=allDataAry.count-2) {
        scroPage = allDataAry.count-2;
    }
    else if (typeIndex <= 1){
        scroPage = 1;
    }
    else
    {
        scroPage = typeIndex;
    }
    if (lastBtnTag != btnTage) {
        UILabel *nowLabel = (UILabel *)[scrol viewWithTag:btnTage];
        nowLabel.backgroundColor = txtColors(67, 205, 166, 1);
        nowLabel.textColor = [UIColor whiteColor];
        UILabel *lasLabel = (UILabel *)[scrol viewWithTag:lastBtnTag];
        lasLabel.backgroundColor = [UIColor whiteColor];
        lasLabel.textColor = textColors;
        lastBtnTag = btnTage;
        NSMutableArray *ary = allDataAry[scroPage];
        if (ary.count>0) {
            if (typeNum==0) {
                bckScrollview.contentOffset = CGPointMake(0, 0);
            }
            else if(typeNum == allDataAry.count-1){
                bckScrollview.contentOffset = CGPointMake(2*kDeviceWidth, 0);
            }
            else
            {
                bckScrollview.contentOffset = CGPointMake(kDeviceWidth, 0);
            }
            [leftCollecView reloadData];
            [listCollecView reloadData];
            [rightCollecView reloadData];
        }
        else{
            [self tapLoadTypeData:nowLabel.text];
        }
        if(typeNum+1<=shopTypeDataAyr.count-1){
            NSArray *ary = allDataAry[typeNum+1];
            if (ary.count==0) {
                [self loadTypData:shopTypeDataAyr[typeNum+1] direct:@"1"];
            }
        }
        if (typeNum-1>1){
            NSArray *ary = allDataAry[typeNum-1];
            if (ary.count==0) {
                [self loadTypData:shopTypeDataAyr[typeNum-1] direct:@"0"];
            }
        }
    }
}
//选好了按钮事件
-(void)chooseAction
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyuseridsid.action" params:pramDic success:^(id json) {
        [Hud hide:YES];
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"购物车还是空的!先加件商品再试试!";
            [mud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else if ([[json valueForKey:@"massage"]integerValue]==2){
            
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":userShequ_id,@"address.tel":user_id}];
            
            [HTTPTool getWithUrl:@"defaultAddress.action" params:pram success:^(id json) {
                
                if (![[json valueForKey:@"address"]isEqual:[NSNull null]]) {
                    
                    NSArray *ary = [json valueForKey:@"address"];
                    
                    userAddressModel * addressModel = [[userAddressModel  alloc]init];
                    NSDictionary *addDic = ary[0];
                    [addressModel setValuesForKeysWithDictionary:addDic];
                    addressModel.qiehuan = [json valueForKey:@"qiehuan"];
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 0;
                        [mask removeFromSuperview];
                        newAddressPop.alpha = 0;
                        [newAddressPop removeFromSuperview];
                    }];
                    if ([user_id isEqualToString:userSheBei_id]) {
                        SureOrderViewController *vc = [[SureOrderViewController alloc]init];
                        vc.shequ_id = userShequ_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        UserOrderViewController *vc = [[UserOrderViewController alloc]init];
                        vc.shequ_id = userShequ_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                else{
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 1;
                        [self .view addSubview:mask];
                        newAddressPop.alpha = 0.95;
                        [self.view addSubview:newAddressPop];
                    }];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误17";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else if ([[json valueForKey:@"massage"]integerValue]==4){
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"商品收藏到购物车,商家休息中无法接收订单";
            [mud showWhileExecuting:@selector(showTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"购物车暂无当前社区商品!";
            [mud showWhileExecuting:@selector(showTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误18";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//使用新地址
-(void)initNewAddressPop
{
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 120*MCscale, kDeviceWidth*9/10.0,340*MCscale)];
    newAddressPop.alpha = 0;
    newAddressPop.addresPopdelegate = self;
    //    [self.view addSubview:newAddressPop];
}
#pragma mark -- NewAddresDelegate
-(void)newAddressView:(NewAddresPopView *)popView Andvalue:(NSInteger)index
{
    if (index == 2) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"地址添加成功";
        [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            newAddressPop.alpha = 0;
            [newAddressPop removeFromSuperview];
        }];
        if ([user_id isEqualToString:userSheBei_id]) {
            SureOrderViewController *vc = [[SureOrderViewController alloc]init];
            vc.shequ_id = userShequ_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            UserOrderViewController *vc = [[UserOrderViewController alloc]init];
            vc.shequ_id = userShequ_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (index == 3)
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 1;
            [self .view addSubview:mask];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,155*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            orderPrompt.cancalBtn.hidden = YES;
            orderPrompt.line2.hidden = YES;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
    else if (index == 4)
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 1;
            [self .view addSubview:mask];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,220*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            //                    orderPrompt.alpha = 0;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
}
//弹框遮罩
-(void)maskView
{
    mask = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    mask.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
}
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        newAddressPop.alpha = 0;
        orderPrompt.alpha = 0;
        [self.view endEditing:YES];
        [newAddressPop removeFromSuperview];
        [orderPrompt removeFromSuperview];
    }];
}
#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if (textView.text.length >50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}

//点击底部白色购物车 进入购物车
-(void)whiteCarAction
{
    CarViewController *car = [[CarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}
//错误提示
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
-(void)showTask
{
    sleep(2.5);
}
-(void)refresh
{
    //下拉刷新
    [leftCollecView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [leftCollecView addFooterWithTarget:self action:@selector(footRefreshing)];
    leftCollecView.headerPullToRefreshText = @"下拉刷新数据";
    leftCollecView.headerReleaseToRefreshText = @"松开刷新";
    leftCollecView.headerRefreshingText = @"拼命加载中";
    leftCollecView.footerPullToRefreshText = @"上拉加载数据";
    leftCollecView.footerReleaseToRefreshText = @"松开加载数据";
    leftCollecView.footerRefreshingText = @"拼命加载中";
    
    //下拉刷新
    [listCollecView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [listCollecView addFooterWithTarget:self action:@selector(footRefreshing)];
    listCollecView.headerPullToRefreshText = @"下拉刷新数据";
    listCollecView.headerReleaseToRefreshText = @"松开刷新";
    listCollecView.headerRefreshingText = @"拼命加载中";
    listCollecView.footerPullToRefreshText = @"上拉加载数据";
    listCollecView.footerReleaseToRefreshText = @"松开加载数据";
    listCollecView.footerRefreshingText = @"拼命加载中";
    
    //下拉刷新
    [rightCollecView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [rightCollecView addFooterWithTarget:self action:@selector(footRefreshing)];
    rightCollecView.headerPullToRefreshText = @"下拉刷新数据";
    rightCollecView.headerReleaseToRefreshText = @"松开刷新";
    rightCollecView.headerRefreshingText = @"拼命加载中";
    rightCollecView.footerPullToRefreshText = @"上拉加载数据";
    rightCollecView.footerReleaseToRefreshText = @"松开加载数据";
    rightCollecView.footerRefreshingText = @"拼命加载中";
    
}
-(void)headReFreshing
{
    loadType = 0;
    isRefresh = 1;
    if(minPageAry.count >0){
        if ([minPageAry[typeNum] integerValue] == 1) {
            MBProgressHUD *mbd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbd.mode = MBProgressHUDModeCustomView;
            mbd.labelText = @"已经到顶了";
            mbd.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbd showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            if(typeNum ==allDataAry.count-1 && allDataAry.count>=3){
                [rightCollecView headerEndRefreshing];
            }
            else if (typeNum == 0){
                [leftCollecView headerEndRefreshing];
            }
            else
                [listCollecView headerEndRefreshing];
        }
        else{
            NSString *minp = [NSString stringWithFormat:@"%ld",(long)[minPageAry[typeNum] integerValue]-1];
            [minPageAry replaceObjectAtIndex:typeNum withObject:minp];
            NSString *typ = shopTypeDataAyr[typeNum];
            [self typeRefreshData:typ];
        }
    }
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    if (maxPageAry.count>0) {
        NSString *maxp = [NSString stringWithFormat:@"%ld",(long)[maxPageAry[typeNum] integerValue]+1];
        [maxPageAry replaceObjectAtIndex:typeNum withObject:maxp];
        NSString *typ = shopTypeDataAyr[typeNum];
        [self typeRefreshData:typ];
    }
}
-(void)endRefresh:(BOOL)success
{
    if (success) {
        if(typeNum ==allDataAry.count-1 && allDataAry.count>=3){
            [rightCollecView footerEndRefreshing];
        }
        else if (typeNum == 0){
            [leftCollecView footerEndRefreshing];
        }
        else
            [listCollecView footerEndRefreshing];
    }
    else{
        if(typeNum ==allDataAry.count-1 && allDataAry.count>=3){
            [rightCollecView headerEndRefreshing];
        }
        else if (typeNum == 0){
            [leftCollecView headerEndRefreshing];
        }
        else
            [listCollecView headerEndRefreshing];
    }
}
#pragma mark -- 键盘
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    NSDictionary *userInfo = [notifaction userInfo];
    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [userValue CGRectValue];
    CGRect fram = newAddressPop.frame;
    fram.origin.y = keyboardRect.origin.y-fram.size.height+20*MCscale;
    newAddressPop.frame = fram;
}
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    if(!IPHONE_Plus){
        CGRect fram = newAddressPop.frame;
        fram.origin.y = 120*MCscale;
        newAddressPop.frame = fram;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(!IPHONE_Plus){
        [super viewWillDisappear:animated];
        ritBtnBol = 0;
        [UIView animateWithDuration:0.3 animations:^{
            bubbleView.alpha = 0;
            bubbleView.frame = CGRectMake(kDeviceWidth-30, 50, 0, 0);
        }];
    }
}

#pragma mark -- UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 || textField.tag == 2) {
        if (textField.text.length == 0) {
            return YES;
        }
        //限制最多输入6位
        NSInteger exitLength = textField.text.length;
        NSInteger selectLength = range.length;
        NSInteger replaceLength = string.length;
        if (exitLength - selectLength +replaceLength>6) {
            return NO;
        }
    }
    if (textField.tag == 1011) {
        if (textField.text.length == 0) {
            return YES;
        }
        //限制最多输入11位
        NSInteger exitLength = textField.text.length;
        NSInteger selectLength = range.length;
        NSInteger replaceLength = string.length;
        if (exitLength - selectLength +replaceLength>11) {
            return NO;
        }
    }
    return YES;
}
#pragma mark OrderPromptViewDelegate
-(void)OrderPromptView:(OrderPromptView *)orderView AndButton:(UIButton *)button
{
    if (button == orderView.sureBtn) {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            newAddressPop.alpha = 0;
            orderPrompt.alpha = 0;
            [newAddressPop removeFromSuperview];
            [orderPrompt removeFromSuperview];
        }];
    }
    else
    {
        //2.1  修改购物车中特惠商品选中状态
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id}];
        [HTTPTool postWithUrl:@"changeCarTehui.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"地址添加成功";
                [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 0;
                    [mask removeFromSuperview];
                    newAddressPop.alpha = 0;
                    [orderPrompt removeFromSuperview];
                    [newAddressPop removeFromSuperview];
                }];
                NSNotification *newAddressPopSave = [NSNotification notificationWithName:@"newAddressPop" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:newAddressPopSave];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newAddressPop" object:nil];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误19";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
@end

