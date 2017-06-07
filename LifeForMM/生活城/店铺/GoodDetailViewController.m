//
//  GoodDetailViewController.m
//  LifeForMM
//
//  Created by MIAO on 16/11/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "Header.h"
#import "UserOrderViewController.h"
#import "SureOrderViewController.h"
#import "goodDeailModel.h"
#import "TGCenterLineLabel.h"
#import "CarViewController.h"
#import "MaskView.h"
#import "NewAddresPopView.h"
#import "OrderPromptView.h"
#import "userAddressModel.h"
@interface GoodDetailViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate,CAAnimationDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,newAddresPopDelegate,OrderPromptViewDelegate>

@end

@implementation GoodDetailViewController{
    UIScrollView *mainScrollView;
    UIView *footView;//底部视图
    NSMutableArray *chooseArray;//型号
    NSInteger lastChooseSize;//上次选择型号标记
    NSInteger goodCount;//数量
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    UIImageView *addCarImageView;//加入购物车原点
    NSMutableArray *colorsArray;//存放颜色image
    NSInteger lastColor;//上次选中的颜色
    UILabel *totlMoney;
    UILabel *numLabel;//购物车数量
    NSMutableArray *goodDataAry;//数据
    NSInteger cellCount;//单元格行数
    NSMutableArray *numLabelAry;//数量加减label
    NSMutableArray *cellHeighAry;//关联商品image
    NSMutableArray *aryForHeadViews;//存放头视图中子视图
    NSString *yanse;//选择的颜色
    NSString *xinghao;//型号
    NSMutableArray *dadangAry;//亲密搭档
    CGFloat tolMoney;//总价钱
    NSInteger shuliang;//从服务器获取的购物车数量
    CGFloat total;//从服务器获取的购物车总价
    UILabel *youhuiLabel;//优惠价格
    NewAddresPopView *newAddressPop;//新地址
    OrderPromptView *orderPrompt;//提示信息
    MaskView *mask;//弹框遮罩层
    UIImageView *whiteCar;//点击进入购物车
    UIImageView *chooseBtnView;//选好了按钮
    UILabel *carEmptyLab; //购物车-空
    UIImageView *carEmptyImg;//
    BOOL goodTehui; //1 是特惠商品
    NSUserDefaults *userDefault;
    UILabel *tishiLabel;
    UIButton *subtractBtn;//数量减
    UIButton *addBtn;//数量加
    UILabel *goodNumLabel;//数量显示
    UIButton *addCarBtn;//加入购物车按钮
    UIView *selectedColorView;//选择颜色
    UIImageView *detailImage;//商品图片
    CGFloat mainHeight;//高度
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"changeGoodsAnying" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"cardelNotification" object:nil];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    lastChooseSize = -1;
    goodCount = 1;
    lastColor = -1;
    cellCount = 0;
    tolMoney = 0.0;
    goodTehui = 1;
    goodDataAry = [[NSMutableArray alloc]init];
    numLabelAry = [[NSMutableArray alloc]init];
    cellHeighAry = [[NSMutableArray alloc]init];
    aryForHeadViews = [[NSMutableArray alloc]init];
    dadangAry = [[NSMutableArray alloc]init];
    yanse = @"0";
    xinghao = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavigation];
    [self initfootView];
    [self goodPropertydeal];
    [self relodCarDatas];
    [self initfootView];
    [self initNewAddressPop];
    [self maskView];
}
#pragma mark 导航栏
-(void)initNavigation
{
    self.navigationItem.title = @"商品详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"主页"] forState:UIControlStateNormal];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark -- 详情页添加数据/购物车删除数据
-(void)notafitionAction
{
    [self carNumData];
    [self relodCarDatas];
}

//特惠商品处理
-(void)goodPropertydeal
{
    if ([_goodtag isEqualToString:@"1"] || [_goodtag isEqualToString:@""]) {
        goodTehui = 0;
    }
    else{
        
        NSString *cutLabelStr = [_goodtag substringFromIndex:45];
        
        if ([cutLabelStr isEqualToString:@"tehui.png"]) {
            goodTehui = 1;
        }
        else{
            goodTehui = 0;
        }
    }
    [self loadListData];
}
#pragma mark -- 商品详情数据
-(void)loadListData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_goodId}];
    [HTTPTool getWithUrl:@"shangpinall.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSLog(@"-- 商品详情%@",json);
        NSDictionary *dic = [json valueForKey:@"shpxiangping"];
        if (dic.count !=0) {
            goodDeailModel *shModel = [[goodDeailModel alloc]initWithContent:dic];
            [goodDataAry addObject:shModel];
            [self totlTabelCellCount];
        }
        NSArray *ary = [dic valueForKey:@"guanlianpic"];
        if (ary.count>0) {
            for (int i =0; i<ary.count; i++) {
                [dadangAry addObject:@"-1"];
            }
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误1";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark -- 计算高度
-(void)totlTabelCellCount
{
    mainHeight = 320*MCscale;
    goodDeailModel *model = goodDataAry[0];
    if (![model.kexuanyanse[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight+40*MCscale;
    }
    if (![model.xinghao[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight+40*MCscale;
    }
    if(![model.guanxishangpin[0] isEqualToString:@"0"])
    {
        mainHeight = mainHeight+118*MCscale;
    }
    if (![model.shangpinjianjie[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight + model.shangpinjianjie.count*200*MCscale;
    }
    
    mainHeight = mainHeight +50*MCscale;
    
    [self initSubviews];
    
    [self createHeaderView];
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
        bud.labelText = @"网络连接错误2";
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
//购物车数量级及总价
-(void)relodCarDatas
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id,@"car.dianpuid":_dianpuId}];
    [HTTPTool getWithUrl:@"dianpuprice.action" params:pram success:^(id json) {
        numLabel.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"shuliangs"]];
        totlMoney.text = [NSString stringWithFormat:@"¥%.2f",[[json valueForKey:@"totalPrice"] floatValue]];
        CGSize tolSize = [totlMoney.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15], NSFontAttributeName,nil] context:nil].size;
        totlMoney.frame = CGRectMake(95*MCscale, 10, tolSize.width, 30);
        if ([[json valueForKey:@"jianmoneys"] integerValue]==0) {
            if ([[json valueForKey:@"cha"] floatValue]<=0) {
                youhuiLabel.alpha = 0;
            }
            else
                if ([[json valueForKey:@"totalPrice"] floatValue]<=0) {
                    youhuiLabel.alpha = 0;
                }
                else{
                    youhuiLabel.alpha = 1;
                    youhuiLabel.text = [NSString stringWithFormat:@"还差¥%.f",[[json valueForKey:@"cha"] floatValue]];
                }
        }
        else{
            youhuiLabel.text = [NSString stringWithFormat:@"优惠¥%@",[json valueForKey:@"jianmoneys"]];
        }
        CGSize yhSize = [youhuiLabel.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_7], NSFontAttributeName,nil] context:nil].size;
        youhuiLabel.frame = CGRectMake(totlMoney.right, 17, yhSize.width, 20);
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误3";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

-(void)initSubviews
{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight - 130*MCscale)];
    //滑屏
    mainScrollView.delegate = self;
    //滑动一页
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.contentSize = CGSizeMake(kDeviceWidth,mainHeight);
    //偏移量
    mainScrollView.contentOffset = CGPointMake(0, 0);
    //竖直方向不能滑动
    mainScrollView.alwaysBounceVertical = YES;
    //水平方向滑动
    mainScrollView.alwaysBounceHorizontal = NO;
    //滑动指示器
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    //无法超过边界
    mainScrollView.bounces = NO;
    //设置滑动时减速到0所用的时间
    mainScrollView.decelerationRate  = 1;
    [self.view addSubview:mainScrollView];
}

#pragma mark 头视图
-(void)createHeaderView
{
    goodDeailModel *model = goodDataAry[0];
#pragma mark 头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240*MCscale)];
    //商品图片
    detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth*2/5.0, kDeviceWidth*2/5.0)];
    detailImage.contentMode = UIViewContentModeScaleAspectFit;
    detailImage.tag = 101;
    detailImage.backgroundColor = [UIColor clearColor];
    [detailImage sd_setImageWithURL:[NSURL URLWithString:model.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    detailImage.center = CGPointMake(kDeviceWidth/2.0, kDeviceWidth/5.0 +10);
    [headView addSubview:detailImage];
    
    //提示label
    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,detailImage.center.y +20*MCscale, detailImage.width , 20*MCscale)];
    tishiLabel.alpha = 0.5;
    tishiLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
    tishiLabel.textColor = [UIColor clearColor];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [detailImage addSubview:tishiLabel];
    
    NSString *str = model.shangpinname;
    CGSize size = [str boundingRectWithSize:CGSizeMake(260*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
    //商品名
    UILabel *goodName = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, detailImage.bottom+15*MCscale, size.width, 20*MCscale)];
    goodName.text = str;
    goodName.font = [UIFont systemFontOfSize:MLwordFont_6];
    goodName.textColor = [UIColor blackColor];
    goodName.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:goodName];
    //价格
    UILabel *newMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    NSString *wpric = [NSString stringWithFormat:@"¥%.2f",[model.xianjia floatValue]];
    CGSize newPricSize = [wpric boundingRectWithSize:CGSizeMake(100, 30*MCscale) options: NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_11],NSFontAttributeName, nil] context:nil].size;
    newMoney.frame = CGRectMake(33*MCscale, goodName.bottom+2, newPricSize.width, 30*MCscale);
    newMoney.text = wpric;
    newMoney.textAlignment = NSTextAlignmentCenter;
    newMoney.textColor = txtColors(237, 58, 76, 1);
    newMoney.font = [UIFont systemFontOfSize:MLwordFont_11];
    newMoney.backgroundColor = [UIColor clearColor];
    [headView addSubview:newMoney];
    //原价
    TGCenterLineLabel *oldMoney = [[TGCenterLineLabel alloc]initWithFrame:CGRectZero];
    NSString *oldPric = [NSString stringWithFormat:@"原价%.2f",[model.yuanjia floatValue]];
    CGSize oldPricSize = [oldPric boundingRectWithSize:CGSizeMake(100, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    oldMoney.frame = CGRectMake(newMoney.right+8*MCscale, newMoney.top+5*MCscale, oldPricSize.width, 20*MCscale);
    oldMoney.text = oldPric;
    oldMoney.textAlignment = NSTextAlignmentCenter;
    oldMoney.textColor = textColors;
    oldMoney.font = [UIFont systemFontOfSize:MLwordFont_9];
    oldMoney.backgroundColor = [UIColor clearColor];
    if([model.yuanjia floatValue] > 0){
        [headView addSubview:oldMoney];
    }
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom-1, kDeviceWidth, 1)];
    line1.backgroundColor = lineColor;
    [headView addSubview:line1];
    
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //收藏
    if (!goodTehui) {
        collectBtn.frame = CGRectMake(kDeviceWidth-65*MCscale, detailImage.bottom+10*MCscale, 35*MCscale, 35*MCscale);
        collectBtn.backgroundColor = [UIColor clearColor];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"商品收藏"] forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(addCollection:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:collectBtn];
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def integerForKey:@"isLogin"] != 1) {
        collectBtn.hidden = YES;
    }
    
    NSString *zhuangtai = [NSString stringWithFormat:@"%@",self.zhuangtai];
    if (zhuangtai.length > 11) {
        tishiLabel.text = zhuangtai;
        tishiLabel.backgroundColor = [UIColor grayColor];
        collectBtn.hidden = YES;
    }
    else {
        if ([zhuangtai isEqualToString:@"0"]) {
            tishiLabel.text = @"已售完";
            tishiLabel.backgroundColor = [UIColor grayColor];
            collectBtn.hidden = YES;
        }
    }
    [mainScrollView addSubview:headView];
    
#pragma mark 可选颜色
    selectedColorView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, line1.bottom, kDeviceWidth - 40*MCscale, 40*MCscale)];
    selectedColorView.backgroundColor = [UIColor clearColor];
    
    UILabel *selectedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    selectedLabel.frame = CGRectMake(5*MCscale, 10*MCscale, 70, 20*MCscale);
    selectedLabel.text = @"可选颜色:";
    selectedLabel.textAlignment = NSTextAlignmentLeft;
    selectedLabel.textColor = [UIColor blackColor];
    selectedLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    selectedLabel.backgroundColor = [UIColor clearColor];
    [selectedColorView addSubview:selectedLabel];
    colorsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<model.kexuanyansepic.count; i++) {
        UIImageView *selectedColorImage = [[UIImageView alloc]initWithFrame:CGRectZero];;
        selectedColorImage.frame = CGRectMake(selectedLabel.right+4+40*i*MCscale, 1, 38*MCscale, 38*MCscale);
        [selectedColorImage sd_setImageWithURL:[NSURL URLWithString:model.kexuanyansepic[i]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        selectedColorImage.backgroundColor = [UIColor clearColor];
        selectedColorImage.layer.borderColor =txtColors(25, 182, 133, 1).CGColor;
        selectedColorImage.layer.masksToBounds = YES;
        selectedColorImage.layer.borderWidth = 0;
        selectedColorImage.userInteractionEnabled = YES;
        selectedColorImage.tag = 1000 +i;
        [selectedColorView addSubview:selectedColorImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseColor:)];
        [selectedColorImage addGestureRecognizer:tap];
        [colorsArray addObject:selectedColorImage];
    }
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,selectedColorView.height - 1, selectedColorView.width, 1)];
    line2.backgroundColor = lineColor;
    [selectedColorView addSubview:line2];
    
#pragma mark 型号
    UIView *xinghaoView = [[UIView alloc]initWithFrame:CGRectZero];
    xinghaoView.backgroundColor = [UIColor clearColor];
    
    UILabel *selectedXinghao = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 40*MCscale, 20*MCscale)];
    selectedXinghao.text = @"型号:";
    selectedXinghao.textAlignment = NSTextAlignmentLeft;
    selectedXinghao.textColor = [UIColor blackColor];
    selectedXinghao.font = [UIFont systemFontOfSize:MLwordFont_5];
    selectedXinghao.backgroundColor = [UIColor clearColor];\
    [xinghaoView addSubview:selectedXinghao];
    
    chooseArray = [[NSMutableArray alloc]init];
    CGFloat lengthX = 0;
    for (int j= 0; j<model.xinghao.count; j++) {
        UIImageView *xinghaoImage = [[UIImageView alloc]initWithFrame:CGRectMake(selectedXinghao.right+10*MCscale+lengthX+22*j*MCscale, 10*MCscale, 22*MCscale, 22*MCscale)];
        xinghaoImage.image= [UIImage imageNamed:@"选择"];
        xinghaoImage.backgroundColor = [UIColor clearColor];
        xinghaoImage.userInteractionEnabled = YES;
        [xinghaoView addSubview:xinghaoImage];
        xinghaoImage.tag = 1010+j;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSize:)];
        [xinghaoImage addGestureRecognizer:tap];
        [chooseArray addObject:xinghaoImage];
        
        CGSize size = [model.xinghao[j] boundingRectWithSize:CGSizeMake(60*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        
        UILabel *chooseSize = [[UILabel alloc]initWithFrame:CGRectMake(xinghaoImage.right, 11*MCscale, size.width+5, 20*MCscale)];
        lengthX = lengthX +size.width+5;
        chooseSize.textAlignment = NSTextAlignmentCenter;
        chooseSize.text = model.xinghao[j];
        chooseSize.textColor = textBlackColor;
        chooseSize.font = [UIFont systemFontOfSize:MLwordFont_5];
        chooseSize.backgroundColor = [UIColor clearColor];
        chooseSize.userInteractionEnabled = YES;
        chooseSize.tag = 1020+j;
        [xinghaoView addSubview:chooseSize];
        UITapGestureRecognizer *lbTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLbSize:)];
        [chooseSize addGestureRecognizer:lbTap];
    }
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectZero];
    line3.backgroundColor = lineColor;
    [xinghaoView addSubview:line3];
    
#pragma mark 购买数量
    UIView *numView = [[UIView alloc]initWithFrame:CGRectZero];
    numView.backgroundColor = [UIColor clearColor];
    
    UILabel *numLabelbuy = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 70, 20*MCscale)];
    numLabelbuy.text = @"购买数量:";
    numLabelbuy.backgroundColor = [UIColor clearColor];
    numLabelbuy.textAlignment = NSTextAlignmentLeft;
    numLabelbuy.textColor = [UIColor blackColor];
    numLabelbuy.font = [UIFont systemFontOfSize:MLwordFont_5];
    [numView addSubview:numLabelbuy];
    
    UIImageView *changeNumImage = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, numLabelbuy.bottom+8*MCscale, 110*MCscale, 30*MCscale)];
    changeNumImage.userInteractionEnabled = YES;
    [numView addSubview:changeNumImage];
    
    goodNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(changeNumImage.left+39*MCscale, changeNumImage.top, 37*MCscale, 30*MCscale)];
    goodNumLabel.backgroundColor = [UIColor clearColor];
    goodNumLabel.tintColor = [UIColor blackColor];
    goodNumLabel.textAlignment = NSTextAlignmentCenter;
    goodNumLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [numView addSubview:goodNumLabel];
    
    if (numLabelAry.count <1) {
        [numLabelAry addObject:goodNumLabel];
    }
    NSString *str2 = [NSString stringWithFormat:@"%ld",(long)goodCount];
    goodNumLabel.text = str2;
    if(goodTehui){
        changeNumImage.image= [UIImage imageNamed:@"框"];
    }
    else{
        changeNumImage.image= [UIImage imageNamed:@"加减框"];
        
        subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subtractBtn.frame = CGRectMake(changeNumImage.left, changeNumImage.top, 37*MCscale, 30*MCscale);
        [subtractBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
        subtractBtn.backgroundColor = [UIColor clearColor];
        [numView addSubview:subtractBtn];
        
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame =  CGRectMake(goodNumLabel.right+2, changeNumImage.top, 37*MCscale, 30*MCscale) ;
        [addBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.backgroundColor = [UIColor clearColor];
        [numView addSubview:addBtn];
        
    }
    addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCarBtn.frame = CGRectMake(kDeviceWidth-162*MCscale, changeNumImage.top, 112*MCscale, 30*MCscale);
    addCarBtn.backgroundColor = [UIColor clearColor];
    [addCarBtn setBackgroundImage:[UIImage imageNamed:@"加入购物车按钮"] forState:UIControlStateNormal];
    [addCarBtn addTarget:self action:@selector(addCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [numView addSubview:addCarBtn];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectZero];
    line4.backgroundColor = lineColor;
    
    if (zhuangtai.length > 11) {
        numLabelbuy.hidden = YES;
        changeNumImage.hidden = YES;
        goodNumLabel.hidden = YES;
        addCarBtn.hidden = YES;
        line4.hidden = YES;
    }
    else {
        if ([zhuangtai isEqualToString:@"0"]) {
            numLabelbuy.hidden = YES;
            changeNumImage.hidden = YES;
            goodNumLabel.hidden = YES;
            addCarBtn.hidden = YES;
            line4.hidden = YES;
        }
    }
    
#pragma mark 亲密搭档
    UIView *partnerView = [[UIView alloc]initWithFrame:CGRectZero];
    partnerView.backgroundColor = [UIColor clearColor];
    //
    
    UILabel *partnerLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 70*MCscale, 20*MCscale)];
    partnerLabel.backgroundColor = [UIColor clearColor];
    partnerLabel.text = @"亲密搭档";
    partnerLabel.textAlignment = NSTextAlignmentLeft;
    partnerLabel.textColor = [UIColor blackColor];
    partnerLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [partnerView addSubview:partnerLabel];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(partnerLabel.right+5*MCscale, 12*MCscale, 180*MCscale, 15*MCscale)];
    subTitle.text = @"(选中你喜欢的一起放进购物车吧)";
    subTitle.textAlignment = NSTextAlignmentLeft;
    subTitle.textColor = textColors;
    subTitle.backgroundColor = [UIColor clearColor];
    subTitle.font = [UIFont systemFontOfSize:MLwordFont_10];
    [partnerView addSubview:subTitle];
    
    for (int k = 0; k<model.guanlianpic.count; k++) {
        UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale+75*k*MCscale, partnerLabel.bottom+10*MCscale, 70*MCscale, 70*MCscale)];
        goodImage.backgroundColor = [UIColor clearColor];
        goodImage.contentMode = UIViewContentModeScaleAspectFit;
        [goodImage sd_setImageWithURL:[NSURL URLWithString:model.guanlianpic[k]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        goodImage.tag = 1050+k;
        goodImage.userInteractionEnabled = YES;
        [partnerView addSubview:goodImage];
        
        UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, 10*MCscale, 17*MCscale, 17*MCscale)];
        chooseImage.backgroundColor = [UIColor clearColor];
        chooseImage.image = [UIImage imageNamed:@"选中"];
        chooseImage.tag = 1060;
        chooseImage.alpha = 0;
        [goodImage addSubview:chooseImage];
        UITapGestureRecognizer *imagTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLikeGood:)];
        [goodImage addGestureRecognizer:imagTap];
    }
    UIView *line5 =[[UIView alloc]initWithFrame:CGRectZero];
    line5.backgroundColor = lineColor;
    //
#pragma mark frame
    if (![model.kexuanyansepic[0] isEqualToString:@"0"]){//有颜色
        [mainScrollView addSubview:selectedColorView];
        if (![model.xinghao[0] isEqualToString:@"0"]) {//有型号
            [mainScrollView addSubview:xinghaoView];
            xinghaoView.frame = CGRectMake(20*MCscale, selectedColorView.bottom, kDeviceWidth - 40*MCscale, 40*MCscale);
            line3.frame = CGRectMake(0, xinghaoView.height - 1, xinghaoView.width, 1);
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, xinghaoView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }            }
        }
        else//没有型号
        {
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, selectedColorView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
    }
    else//没有颜色
    {
        if (![model.xinghao[0] isEqualToString:@"0"]) {//有型号
            [mainScrollView addSubview:xinghaoView];
            xinghaoView.frame = CGRectMake(20*MCscale, headView.bottom, kDeviceWidth - 40*MCscale, 40*MCscale);
            line3.frame = CGRectMake(0, xinghaoView.height - 1, xinghaoView.width, 1);
            
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, xinghaoView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
        else//没有型号
        {
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, headView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shangpinjianjie[k]]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize imgSize = image.size;
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, imgSize.width, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
    }
}
#pragma mark 初始化底部视图
-(void)initfootView
{
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    footView.backgroundColor = txtColors(25, 182, 133, 0.8);
    [self.view addSubview:footView];
    //白色购物车
    whiteCar = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale, -15, 60*MCscale, 60*MCscale)];
    whiteCar.backgroundColor = [UIColor clearColor];
    whiteCar.tag = 1001;
    whiteCar.image = [UIImage imageNamed:@"购物车-无"];
    [footView addSubview:whiteCar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wentToVar)];
    [whiteCar addGestureRecognizer:tap];
    //购物车数量
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(43*MCscale, 14, 16*MCscale, 16*MCscale)];
    numLabel.tag = 1002;
    numLabel.backgroundColor =txtColors(237, 58,76, 1);
    numLabel.layer.cornerRadius = 8.0;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = @"0";
    numLabel.alpha = 0;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    numLabel.layer.masksToBounds = YES;
    [whiteCar addSubview:numLabel];
    //没有商品
    carEmptyImg = [[UIImageView alloc]initWithFrame:CGRectMake(whiteCar.right, 15, 150*MCscale, 20)];
    carEmptyImg.alpha = 0;
    carEmptyImg.backgroundColor = [UIColor clearColor];
    carEmptyImg.image = [UIImage imageNamed:@"empty"];
    [footView addSubview:carEmptyImg];
    
    //总价
    totlMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    totlMoney.backgroundColor = [UIColor clearColor];
    totlMoney.textColor = txtColors(237, 58, 76, 1);
    totlMoney.textAlignment = NSTextAlignmentLeft;
    totlMoney.alpha = 0;
    totlMoney.font = [UIFont systemFontOfSize:MLwordFont_15];
    [footView addSubview:totlMoney];
    
    //优惠
    youhuiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    youhuiLabel.alpha = 0;
    youhuiLabel.textAlignment = NSTextAlignmentLeft;
    youhuiLabel.textColor = textBlackColor;
    youhuiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [footView addSubview:youhuiLabel];
    //去下单按钮
    chooseBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-120*MCscale, 10, 100*MCscale, 30*MCscale)];
    chooseBtnView.backgroundColor = [UIColor clearColor];
    chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
    chooseBtnView.userInteractionEnabled = YES;
    [footView addSubview:chooseBtnView];
    UITapGestureRecognizer *chosetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAction)];
    [chooseBtnView addGestureRecognizer:chosetap];
    [self carNumData];
}

-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1002) {
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 1;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
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
                bud.labelText = @"网络连接错误4";
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
            [mud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误5";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//使用新地址
-(void)initNewAddressPop
{
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 100, kDeviceWidth*9/10.0,340*MCscale)];
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
        [self.view endEditing:YES];
        [newAddressPop removeFromSuperview];
    }];
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if (textView.text.length >50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}
//选择型号 - 点图片
-(void)chooseSize:(UITapGestureRecognizer *)tap
{
    NSInteger btTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (btTag -1010 != lastChooseSize) {
        UIImageView *newImage= chooseArray[btTag-1010];
        newImage.image = [UIImage imageNamed:@"选中"];
        if(lastChooseSize != -1){
            UIImageView *oldImage = chooseArray[lastChooseSize];
            oldImage.image = [UIImage imageNamed:@"选择"];
        }
    }
    lastChooseSize = btTag-1010;
    xinghao = model.xinghao[btTag - 1010];
}
//选择型号 - 点型号
-(void)chooseLbSize:(UITapGestureRecognizer *)tap
{
    NSInteger btTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (btTag -1020 != lastChooseSize) {
        UIImageView *newImage= chooseArray[btTag-1020];
        if(lastChooseSize != -1){
            UIImageView *oldImage = chooseArray[lastChooseSize];
            oldImage.image = [UIImage imageNamed:@"选择"];
        }
        newImage.image = [UIImage imageNamed:@"选中"];
    }
    lastChooseSize = btTag-1020;
    xinghao = model.xinghao[btTag - 1020];
}
//选中颜色
-(void)chooseColor:(UITapGestureRecognizer *)tap
{
    NSInteger tapTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (tapTag -1000!= lastColor) {
        UIImageView *newImage = colorsArray[tapTag-1000];
        [detailImage sd_setImageWithURL:[NSURL URLWithString:model.kexuanyansepic[tapTag-1000]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        if (lastColor != -1) {
            UIImageView *oldImage = colorsArray[lastColor];
            oldImage.layer.borderWidth = 0;
        }
        newImage.layer.borderWidth = 2.0;
    }
    lastColor = tapTag-1000;
    yanse =[NSString stringWithFormat:@"%@",model.kexuanyanse[tapTag -1000]];
}

//选择伴侣
-(void)chooseLikeGood:(UITapGestureRecognizer *)tap
{
    UIImageView *image =(UIImageView *)tap.view;
    UIImageView *chooseIm = (UIImageView *)[image viewWithTag:1060];
    goodDeailModel *model = goodDataAry[0];
    if (chooseIm.alpha == 0) {
        chooseIm.alpha =1;
        [dadangAry setObject:model.guanxishangpin[tap.view.tag-1050] atIndexedSubscript:tap.view.tag-1050];
    }
    else{
        chooseIm.alpha = 0;
        [dadangAry setObject:@"-1" atIndexedSubscript:tap.view.tag-1050];
    }
}
//商品数量
-(void)addOrSbutractAction:(UIButton *)btn
{
    if(btn == addBtn){
        goodCount ++;
    }
    else{
        if (goodCount>1) {
            goodCount--;
        }
    }
    NSString *gNum = [NSString stringWithFormat:@"%ld",(long)goodCount];
    goodNumLabel.text = gNum;
    
    NSString *zhuangtai = [NSString stringWithFormat:@"%@",self.zhuangtai];
    if (zhuangtai.length > 11) {
    }
    else {
        if ([zhuangtai isEqualToString:@"0"]) {
        }
        else if ([zhuangtai isEqualToString:@"A"])
        {
        }
        else
        {
            if (goodNumLabel.text.integerValue > zhuangtai.integerValue) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"当前商品库存不足";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                goodNumLabel.text = zhuangtai;
            }
        }
    }
}
//加入购物车
-(void)addCarAction:(UIButton *)btn
{
    if(goodTehui){
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shangpinid":_goodId}];
        [HTTPTool getWithUrl:@"findbycarshop.action" params:pram success:^(id json) {
            NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
            if ([massage isEqualToString:@"3"]){//已存在该商品
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"该特惠商品购物车已存在";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else{
                [self addCarAnimation:btn];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误6";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    else{
        [self addCarAnimation:btn];
    }
}
-(void)addCarAnimation:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    [self addToCardData];
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    addCarImageView=[[UIImageView alloc]init];
    addCarImageView.image = [UIImage imageNamed:@"购物车圆点"];
    addCarImageView.contentMode=UIViewContentModeScaleToFill;
    addCarImageView.frame=CGRectMake(0, 0, 10*MCscale, 10*MCscale);
    addCarImageView.hidden=YES;
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=addCarImageView.layer.contents;
    anmiatorlayer.frame=addCarImageView.frame;
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
    //    [addCarImageView removeFromSuperview];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer ];
        anmiatorlayer.hidden=YES;
        addCarBtn.userInteractionEnabled = YES;
    }
}
#pragma mark -- 加入购物车
-(void)addToCardData
{
    //数据model
    goodDeailModel *model = goodDataAry[0];
    NSInteger num = [goodNumLabel.text integerValue];
    NSString *shuli = [NSString stringWithFormat:@"%ld",(long)num]; //商品数量
    //商品id 数组
    NSMutableArray *shangpinidAry = [[NSMutableArray alloc]init];
    //商品颜色  数组
    NSMutableArray *shangpinYansAry = [[NSMutableArray alloc]init];
    //商品型号 数组
    NSMutableArray *shangpinXinghaoAry = [[NSMutableArray alloc]init];
    //商品数量 数组
    NSMutableArray *shangpinShuliangAry = [[NSMutableArray alloc]init];
    //先存放商品详情数据
    //商品id
    NSString *spid = [NSString stringWithFormat:@"%@",model.shangpinid];
    [shangpinidAry addObject:spid];
    //商品颜色
    [shangpinYansAry addObject:yanse];
    //商品型号
    [shangpinXinghaoAry addObject:xinghao];
    //商品数量
    [shangpinShuliangAry addObject:shuli];
    //添加关联商品信息
    for(NSString *st in dadangAry){
        if (![st isEqualToString:@"-1"]) {
            [shangpinidAry addObject:st];
        }
    }
    for (int i = 0; i<shangpinidAry.count-1; i++) {
        [shangpinYansAry addObject:@"0"];
        [shangpinXinghaoAry addObject:@"0"];
        [shangpinShuliangAry addObject:@"1"];
    }
    NSString *shangpinidStr; //id拼接字符串
    NSString *yanseStr; //颜色
    NSString *xinghaoStr; //型号
    NSString *shulingStr; //数量
    shangpinidStr = [shangpinidAry componentsJoinedByString:@","];
    yanseStr = [shangpinYansAry componentsJoinedByString:@","];
    xinghaoStr = [shangpinXinghaoAry componentsJoinedByString:@","];
    shulingStr = [shangpinShuliangAry componentsJoinedByString:@","];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id, @"shequid":userShequ_id,@"car.dianpuid":_dianpuId, @"shangpins":shangpinidStr,@"car.xinghao":xinghaoStr, @"car.yanse":yanseStr,@"shuliangs":shulingStr} ];
    [HTTPTool postWithUrl:@"addcars.action" params:pram success:^(id json) {
        NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        MyLog(@"-- -- %@",json);
        if (![message isEqualToString:@"0"]) {
            [self relodCarDatas];
            [self footViewState:1];
            NSNotification *goodPageNotification = [NSNotification notificationWithName:@"goodPageAddGoods" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:goodPageNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goodPageAddGoods" object:nil];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误7";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)addCollection:(UIButton *)btn
{
    goodDeailModel *model = goodDataAry[0];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithDictionary:@{@"shoucang.userid":user_id,@"shoucang.shoucangtype":@"1",@"shoucang.shopid": [NSString stringWithFormat:@"%@",model.shangpinid],@"shoucang.dianpuid":_dianpuId,@"shoucang.shequid":userShequ_id}];
    
    [HTTPTool getWithUrl:@"shoucang.action" params:parm success:^(id json) {
        if ([[json valueForKey:@"message"]integerValue]==2) {
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"收藏成功";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            NSNotification *goodPageNotification = [NSNotification notificationWithName:@"goodAddShoucang" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:goodPageNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goodAddShoucang" object:nil];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误8";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
    
}

//点击底部白色购物车跳转到购物车
-(void)wentToVar
{
    CarViewController *car = [[CarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}
#pragma mark -- UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 || textField.tag == 2) {
        if (textField.text.length == 0) {
            return YES;
        }
        NSInteger exitLength = textField.text.length;
        NSInteger selectLength = range.length;
        NSInteger replaceLength = string.length;
        if (exitLength - selectLength +replaceLength>6) {
            return NO;
        }
    }
    return YES;
}
//
//#pragma mark -- 键盘
//-(void)keyboardWillShow:(NSNotification *)notifaction
//{
//    NSDictionary *userInfo = [notifaction userInfo];
//    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [userValue CGRectValue];
//    CGRect fram = newAddressPop.frame;
//    fram.origin.y = keyboardRect.origin.y-fram.size.height+20*MCscale;
//    newAddressPop.frame = fram;
//}
//-(void)keyboardWillHide:(NSNotification *)notifaction
//{
//    CGRect fram = newAddressPop.frame;
//    fram.origin.y = 120*MCscale;
//    newAddressPop.frame = fram;
//}

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
            bud.labelText = @"网络连接错误9";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
- (void)myTask {
    sleep(1.5);
}
-(void)showTask
{
    sleep(2.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
