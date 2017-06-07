//
//  orderMoreArginController.m
//  LifeForMM
//
//  Created by HUI on 15/12/4.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "orderMoreArginController.h"
#import "Header.h"
#import "MaskView.h"
#import "PopView.h"
#import "orderDetailViewController.h"
#import "orderModel.h"
#import "userAddressModel.h"
#import "orderMoney.h"
#import "orderAgnGoodModle.h"
#import "youhuiModel.h"
#import "agnAdresModel.h"
#import "Order.h"
#import "DataSigner.h"
#import "addressCell.h"
#import "OnLinePayView.h"
#import "NewAddresPopView.h"
#import "PaymentPasswordView.h"
#import "SetPaymentPasswordView.h"
#import "LoginPasswordView.h"
#import "SelectedTimeView.h"

@interface orderMoreArginController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,PopViewDelegate,UITextViewDelegate,addressDelegate,MBProgressHUDDelegate,UITextFieldDelegate,OnLinePayViewDelegate,newAddresPopDelegate,PaymentPasswordViewDelegate,SetPaymentPasswordViewDelegate,LoginPasswordViewDelegate,SelectedTimeViewDelegate>
{
    UILabel *coupon,*moneyLabel;//以优惠  总价钱
    UIButton *goToOrder;//去下单
    UITableView *orderTableView;
    NSMutableArray *choosePayArray;//选择付款方式
    NSInteger lastChoosePay;//前一次付款方式
    NSInteger cellCount;//0区单元格个数
    UIView *maskView;//余额输入遮罩
    UIView *moneyPop;//优惠券弹框
    SelectedTimeView *DatePackView;//选择时间弹框
    MaskView *mask;//弹框遮罩层
    NSInteger popViewTag;//popView的Tag
    NSInteger lastChoose;//上次选择使用额优惠券
    NSInteger labelTextAlignment;//使用的优惠券
    PopView *billHeadPop,*orderRemarkPop;//订单备注 发票票头
    PaymentPasswordView *passPopView;//密码输入
    NSInteger lastChooseSex;//上次选中的性别
    UIView *changeAddressPopView;//更换地址
    NSInteger lastChooseAddress;//上次选中地址
    NSMutableArray *subTimeAry,*subBeizhuAry,*subOrderHeadAry;//存放送达时间 订单备注 发票台头label
    UITextView *billTextView,*remainTextView;//发票台头 订单备注
    NSMutableArray *maskImageArray;//要隐藏的image
    NSMutableArray *dataArray;//存放所有数据
    NSMutableArray *addresDataAry;//更换地址数据
    NSMutableArray *youhAry;//不同店铺优惠
    NSMutableArray *xiaojiAry;//小计钱数
    NSMutableArray *headViewsAry;//存放头部视图内控件
    NSMutableArray *newAddViewsAry;//存放新地址
    NSMutableArray *orderModleAry;//存放价格 优惠 model
    NSInteger isYouhuiquan;
    NSMutableArray *orderGoodDataAry;//商品数据
    NSMutableArray *youhuidataAry;//优惠数组
    NSMutableDictionary *ppmdic;
    NSString *zhangdanyue; //账单余额
    NSInteger godCount;
    BOOL isqiehuan;//是否可以切换地址
    NSInteger getDataNum;//
    LoginPasswordView *newPayPas;//支付密码
    SetPaymentPasswordView *nextPayPas;//支付密码下一步
    NSString *shouhuodizhi,*shouhuoren,*dianhua,*zhifumima;//是否设置支付密码 1未设置 2已设置
    UIButton *changeBtn;//更换按钮
    NSString *choseYouh;//选择的优惠
    UITableView *addressTable;
    NSString *defaultdizId;//
    NSString *sendTimes,*orderbzhuStr,*orderheadStr;//配送时间 备注 发票头
    MBProgressHUD *allBub;
    OnLinePayView *onLinePayView;//充值金额
    NSString *payMonyeNumStr;
    UIView *payMask;//充值遮罩
    BOOL isChooseYh;
    UIView *onlinePayWayPop; // 在线支付选择支付方式
    NSMutableDictionary *wxPaymessage;
    BOOL isRecharge;
    BOOL isWx;
    NewAddresPopView *newAddressPop;//新地址
    NSDictionary *dict;
}
@end

@implementation orderMoreArginController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(maskDisMiss) name:@"cancleBtnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:@"weixinzhifu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RechargSuccess) name:@"RechargSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
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
    lastChoosePay = godCount=1;
    lastChooseSex = 2;
    cellCount = 4;
    lastChoose =10;
    labelTextAlignment = isYouhuiquan = getDataNum = 0;
    choseYouh = @"0";
    isChooseYh = 0;
    lastChooseAddress = -1;
    popViewTag = -1;
    isRecharge = 0;
    isWx = 0;
    choosePayArray = [[NSMutableArray alloc]initWithCapacity:2];
    subTimeAry = [[NSMutableArray alloc]init];
    subBeizhuAry = [[NSMutableArray alloc]init];
    subOrderHeadAry = [[NSMutableArray alloc]init];
    maskImageArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    youhuidataAry = [[NSMutableArray alloc]init];
    youhAry = [[NSMutableArray alloc]init];
    xiaojiAry = [[NSMutableArray alloc]init];
    addresDataAry = [[NSMutableArray alloc]init];
    headViewsAry = [[NSMutableArray alloc]init];
    newAddViewsAry = [[NSMutableArray alloc]init];
    orderModleAry = [[NSMutableArray alloc]init];
    orderGoodDataAry = [[NSMutableArray alloc]init];
    wxPaymessage = [[NSMutableDictionary alloc]init];
    [self initNavigation];
    [self initTableView];
    [self reldData];
    [self initMaskView];
    [self initPopView];
}
#pragma mark -- 获取列表数据
-(void)reldData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.delegate = self;
    mbHud.labelText = @"请稍等...";
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"dindan.danhao":_danhao}];
    [HTTPTool getWithUrl:@"showdingdan.action" params:pram success:^(id json) {
        MyLog(@"-----下单----%@",json);
        [mbHud hide:YES];
        NSDictionary *dic = [json valueForKey:@"diandanlist"];
        zhangdanyue = [NSString stringWithFormat:@"%@",[json valueForKey:@"zhuanghuyue"]];
        zhifumima = [NSString stringWithFormat:@"%@",[json valueForKey:@"zhifumima"]];
        agnAdresModel *model = [[agnAdresModel alloc]initWithContent:dic];
        [dataArray addObject:model];
        NSArray *ary = [dic valueForKey:@"shangpi"];
        for(NSDictionary *dc in ary){
            orderAgnGoodModle *modl = [[orderAgnGoodModle alloc]initWithContent:dc];
            [orderGoodDataAry addObject:modl];
        }
        if ([model.fapiao integerValue]==1) {
            godCount = 2;
        }
        [self initTableCellData];
        [self reloadMoneys];
        [self initDefaulAddressData];
    } failure:^(NSError *error) {
        //(@"--------%@",error);
        [mbHud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//获取各种金额 优惠
-(void)reloadMoneys
{
    agnAdresModel *model = dataArray[0];
    NSString *yh = @"0";
    if (isYouhuiquan) {
        youhuiModel *mod = youhuidataAry[lastChoose-10];
        yh = [NSString stringWithFormat:@"%@",mod.jine];
    }
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":_danhao,@"shequid":model.shequid,@"youhuijuan":yh,@"shdzid":@"-1"}];
    [HTTPTool getWithUrl:@"dingdanjine.action" params:pram success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        orderMoney *ormodl = [[orderMoney alloc]initWithContent:dic];
        [orderModleAry addObject:ormodl];
        [self loadFootView];
        [self initTableCellData];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//获取默认地址
-(void)initDefaulAddressData
{
    UILabel *name = headViewsAry[0];
    UILabel *dianh = headViewsAry[1];
    UILabel *addres = headViewsAry[2];
    agnAdresModel *model = dataArray[0];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":model.shequid,@"address.tel":user_id}];
    [HTTPTool getWithUrl:@"defaultAddress.action" params:pram success:^(id json) {
        if (![[json valueForKey:@"address"]isEqual:[NSNull null]]) {
            NSArray *ary = [json valueForKey:@"address"];
            NSDictionary *addDic = ary[0];
            shouhuodizhi = [addDic valueForKey:@"address"];
            shouhuoren = [addDic valueForKey:@"name"];
            dianhua = [addDic valueForKey:@"haoma"];
            defaultdizId =[NSString stringWithFormat:@"%@",[addDic valueForKey:@"dizhiId"]];
            if([[json valueForKey:@"qiehuan"] integerValue] == 1){
                isqiehuan = 1; //不可切换地址
                changeBtn.alpha = 0;
            }
            else{
                isqiehuan = 0; //可切换地址
                changeBtn.alpha = 1;
            }
            if (shouhuoren) {
                NSRange range = [shouhuoren rangeOfString:@"("];
                if (range.location == NSNotFound) {
                    name.text = shouhuoren;
                }
                else{
                    NSString *pystr = [shouhuoren substringWithRange:NSMakeRange(0, range.location)];
                    name.text = pystr;
                }
            }
            if (dianhua) {
                dianh.text = dianhua;
            }
            if (shouhuodizhi) {
                addres.text = shouhuodizhi;
            }
            [self initAllAddressData];
        }
    } failure:^(NSError *error) {
        //(@"--error -- %@",error);
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//获取section(shopIdArry元素个数即section)
-(void)initTableCellData
{
    if(orderGoodDataAry.count>0 && orderModleAry.count>0){
        NSString *message = @"立即配送";
        for (int i= 0; i<dataArray.count; i++) {
            agnAdresModel *model = dataArray[i];
            NSString *st = [NSString stringWithFormat:@"%@",model.appointmentMessage];
            if(![st isEqualToString:@"0"]){
                message = st;
            }
        }
        sendTimes = message;
        orderbzhuStr = @"可输入特殊要求";
        orderheadStr = @"填写发票台头";
        [orderTableView reloadData];
        [self relodYouh];
    }
}

//获取优惠券
-(void)relodYouh
{
    if (!isChooseYh) {
        agnAdresModel *model = dataArray[0];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":userName_tel,@"shequid":model.shequid,@"dianpuid":model.dianpuid}];
        [HTTPTool getWithUrl:@"useYouhui.action" params:pram success:^(id json) {
            MyLog(@"---json %@",json);
            if ([[json valueForKey:@"massages"]integerValue]!=1) {
                NSArray *ary = [json valueForKey:@"youhuiquan"];
                for(NSDictionary *dic in ary){
                    youhuiModel *mod = [[youhuiModel alloc]initWithContent:dic];
                    [youhuidataAry addObject:mod];
                }
                [self initCoupon];
                UILabel *labl = maskImageArray[1];
                labl.text = [NSString stringWithFormat:@"有%@张优惠券可用",[json valueForKey:@"totalcount"]];
            }
        } failure:^(NSError *error) {
            //(@"--error %@",error);
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    else{
        UILabel *labl = maskImageArray[1];
        UIImageView *image = maskImageArray[0];
        youhuiModel *mod = youhuidataAry[lastChoose-10];
        labl.text = [NSString stringWithFormat:@"%@元",mod.jine];
        image.alpha = 0;
    }
}

//获取切换地址数据
-(void)initAllAddressData
{
    agnAdresModel *model = dataArray[0];
    if (!isqiehuan) {
        if (getDataNum==0) {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":model.shequid,@"address.tel":user_id}];
            [HTTPTool getWithUrl:@"showAddress.action" params:pram success:^(id json) {
                //(@"-(-)-json %@",json);
                if(![[json valueForKey:@"address"]isEqual:[NSNull null]]){
                    NSArray *ary = (NSArray *)[json valueForKey:@"address"];
                    if (ary.count>0) {
                        NSInteger i= 0;
                        for(NSDictionary *dic in ary){
                            userAddressModel *modl = [[userAddressModel alloc]initWithContent:dic];
                            NSString *dzid = [NSString stringWithFormat:@"%@",modl.dizhiId];
                            NSString *dzidasdf = [NSString stringWithFormat:@"%@",defaultdizId];
                            if ([dzid isEqualToString:dzidasdf]) {
                                lastChooseAddress = i;
                            }
                            i++;
                            [addresDataAry addObject:modl];
                        }
                    }
                }
                [addressTable reloadData];
            } failure:^(NSError *error) {
                //(@"-(_)-error %@",error);
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
    }
}
-(void)initNavigation
{
    self.navigationItem.title = @"确认订单";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
//列表
-(void)initTableView
{
    orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    orderTableView.backgroundColor = [UIColor whiteColor];
    orderTableView.delegate =self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initTableHeadView];
    [self.view addSubview:orderTableView];
}
//表头
-(void)initTableHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100*MCscale)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(25, 15*MCscale, 60, 20*MCscale)];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:MLwordFont_7];
    name.text = @"";
    [headView addSubview:name];
    [headViewsAry addObject:name];
    //电话
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(name.right+5, 15*MCscale, 110*MCscale, 20*MCscale)];
    account.textAlignment = NSTextAlignmentLeft;
    account.textColor = [UIColor blackColor];
    account.backgroundColor = [UIColor clearColor];
    account.font = [UIFont systemFontOfSize:MLwordFont_7];
    account.text = @"";
    [headView addSubview:account];
    [headViewsAry addObject:account];
    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame =CGRectMake(kDeviceWidth-80, 15*MCscale, 60, 30);
    changeBtn.backgroundColor = [UIColor clearColor];
    changeBtn.tag = 1002;
    changeBtn.alpha = 0;
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"[更换]" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [changeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:changeBtn];
    
    UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(25, name.bottom+2, kDeviceWidth-40, 20*MCscale)];
    address.textColor = [UIColor blackColor];
    address.font = [UIFont systemFontOfSize:MLwordFont_7];
    address.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:address];
    address.text = @"";
    [headViewsAry addObject:address];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 60*MCscale, kDeviceWidth-40, 1)];
    line2.backgroundColor = lineColor;
    [headView addSubview:line2];
    UIImageView *chooseAddress = [[UIImageView alloc]initWithFrame:CGRectMake(20, line2.bottom+5, 23*MCscale, 23*MCscale)];
    chooseAddress.image = [UIImage imageNamed:@"选择"];
    chooseAddress.backgroundColor = [UIColor clearColor];
    chooseAddress.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddressAction:)];
    [chooseAddress addGestureRecognizer:tap];
    [headView addSubview:chooseAddress];
    
    UILabel *newAddress = [[UILabel alloc]initWithFrame:CGRectMake(chooseAddress.right+5, line2.bottom+5, 80, 20*MCscale)];
    newAddress.text = @"[用新地址]";
    newAddress.textAlignment = NSTextAlignmentLeft;
    newAddress.textColor = [UIColor blackColor];
    newAddress.font = [UIFont systemFontOfSize:MLwordFont_7];
    newAddress.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddressAction:)];
    [newAddress addGestureRecognizer:labelTap];
    [headView addSubview:newAddress];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 95*MCscale, kDeviceWidth, 5)];
    line4.backgroundColor = txtColors(231, 232, 234, 0.8);
    [headView addSubview:line4];
    orderTableView.tableHeaderView = headView;
}
-(void)headSetData
{
    UILabel *name = headViewsAry[0];
    UILabel *tel = headViewsAry[1];
    UILabel *address = headViewsAry[2];
    userAddressModel *model = [addresDataAry lastObject];
    name.text = model.name;
    tel.text = model.haoma;
    address.text = model.address;
}

#pragma mark --初始化弹框
-(void)initPopView
{
    [self maskView];
    [self ChooseSendTime];
    [self orderRemarkPop];
    [self billHeadPop];
    [self inputPass];
    [self initNewAddressPop];
    [self initChangeAddressPop];
    [self changePayPassword];
    [self payMaskView];
    [self initOnlPayWayAction];
}
//手势遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [maskView addGestureRecognizer:tap];
}
//使用新地址
-(void)initNewAddressPop
{
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 100, kDeviceWidth*9/10.0,340*MCscale)];
    newAddressPop.tag = 111;
    newAddressPop.alpha = 0;
    newAddressPop.addresPopdelegate = self;
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
        changeBtn.alpha = 1;
        isqiehuan = 0;
        [addresDataAry removeAllObjects];
        [self newAdresLaterAction];
        [self addNewAddresMoney];
    }
    else if (index == 3 || index == 4)
    {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"保存失败";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
//增加地址后刷新数据
-(void)newAdresLaterAction
{
    agnAdresModel *model = dataArray[0];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":model.shequid,@"address.tel":user_id}];
    [HTTPTool getWithUrl:@"showAddress.action" params:pram success:^(id json) {
        if(![[json valueForKey:@"address"]isEqual:[NSNull null]]){
            NSArray *ary = (NSArray *)[json valueForKey:@"address"];
            if (ary.count>0) {
                for(NSDictionary *dic in ary){
                    userAddressModel *modl = [[userAddressModel alloc]initWithContent:dic];
                    [addresDataAry addObject:modl];
                }
                lastChooseAddress = 0;
                userAddressModel *model = addresDataAry[0];
                defaultdizId = model.dizhiId;
                UILabel *name = headViewsAry[0];
                UILabel *dianh = headViewsAry[1];
                UILabel *addres = headViewsAry[2];
                NSString *sexName = [NSString stringWithFormat:@"%@",model.name];
                NSRange range = [sexName rangeOfString:@"("];
                if (range.location == NSNotFound) {
                    name.text = sexName;
                }
                else{
                    NSString *nameStr = [sexName substringWithRange:NSMakeRange(0, range.location)];
                    name.text = nameStr;
                }
                dianh.text = model.haoma;
                addres.text = model.address;
            }
        }
        [addressTable reloadData];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//添加新地址 获取金额
-(void)addNewAddresMoney
{
    [orderModleAry removeAllObjects];
    NSString *youh = @"0";
    if (youhuidataAry.count >0) {
        youhuiModel *mod = youhuidataAry[lastChoose-10];
        youh = [NSString stringWithFormat:@"%@",mod.jine];
    }
    agnAdresModel *model = dataArray[0];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":_danhao,@"shequid":model.shequid}];
    [HTTPTool getWithUrl:@"dingdanjine.action" params:pram success:^(id json) {
        //(@"---json==%@",json);
        NSDictionary *dic = (NSDictionary *)json;
        orderMoney *moneyModel = [[orderMoney alloc]initWithContent:dic];
        [orderModleAry addObject:moneyModel];
        [self initTableCellData];
        [self changeFootData];
    } failure:^(NSError *error) {
        //(@"----error==%@",error);
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//更换地址
-(void)initChangeAddressPop
{
    changeAddressPopView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 100*MCscale, kDeviceWidth*9/10.0, 268*MCscale)];
    changeAddressPopView.backgroundColor = [UIColor whiteColor];
    changeAddressPopView.tag = 107;
    changeAddressPopView.alpha = 0;
    changeAddressPopView.layer.cornerRadius = 15.0;
    changeAddressPopView.layer.shadowRadius = 5.0;
    changeAddressPopView.layer.shadowOpacity = 0.5;
    changeAddressPopView.layer.shadowOffset = CGSizeMake(0, 0);
    addressTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, changeAddressPopView.width, changeAddressPopView.height-30) style:UITableViewStylePlain];
    addressTable.delegate = self;
    addressTable.dataSource = self;
    addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [changeAddressPopView addSubview:addressTable];
}
//切换地址获取金额优惠
-(void)changeRelodMoey:(NSString *)adresId
{
    [orderModleAry removeAllObjects];
    NSString *youh = @"0";
    if (youhuidataAry.count >0) {
        youhuiModel *mod = youhuidataAry[lastChoose-10];
        youh = [NSString stringWithFormat:@"%@",mod.jine];
    }
    agnAdresModel *model = dataArray[0];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":_danhao,@"shequid":model.shequid,@"shdzid":adresId,@"youhuijuan":youh}];
    [HTTPTool getWithUrl:@"dingdanjine.action" params:pram success:^(id json) {
        //(@"---json==%@",json);
        NSDictionary *dic = (NSDictionary *)json;
        orderMoney *moneyModel = [[orderMoney alloc]initWithContent:dic];
        [orderModleAry addObject:moneyModel];
        [self initTableCellData];
        [self changeFootData];
    } failure:^(NSError *error) {
        //(@"----error==%@",error);
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)changeFootData
{
    orderMoney *model = orderModleAry[orderModleAry.count-1];
    NSString *couStr = [NSString stringWithFormat:@"%@",model.youhuis];
    if ([couStr floatValue]>0) {
        coupon.text = [NSString stringWithFormat:@"已优惠¥%@",model.youhuis];
        coupon.alpha = 1;
    }
    else
        coupon.alpha = 0;
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.totalPrices floatValue]];
    CGSize  size = [moneyLabel.text boundingRectWithSize:CGSizeMake(140*MCscale, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15],NSFontAttributeName, nil] context:nil].size;
    moneyLabel.frame = CGRectMake(25*MCscale, 12, size.width+10, 30);
}
//使用优惠
-(void)initCoupon
{
    moneyPop = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 200*MCscale)];
    moneyPop.backgroundColor = [UIColor whiteColor];
    moneyPop.tag = 101;
    moneyPop.alpha = 0;
    moneyPop.layer.cornerRadius = 15.0;
    moneyPop.layer.shadowRadius = 5.0;
    moneyPop.layer.shadowOpacity = 0.5;
    moneyPop.layer.shadowOffset = CGSizeMake(0, 0);
    UIScrollView *scrolv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15, moneyPop.width, moneyPop.height-30)];
    scrolv.backgroundColor = [UIColor clearColor];
    scrolv.tag = 110011;
    [moneyPop addSubview:scrolv];
    for (int i = 0; i<youhuidataAry.count; i++) {
        youhuiModel *mod = youhuidataAry[i];
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 56*i, scrolv.width, 56*MCscale)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.tag = 10+i;
        [scrolv addSubview:backgroundView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCouponAction:)];
        [backgroundView addGestureRecognizer:tap];
        
        UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(moneyPop.width*2/7.0, 10*MCscale, 22*MCscale, 22*MCscale)];
        chooseImage.backgroundColor = [UIColor clearColor];
        chooseImage.image = [UIImage imageNamed:@"选择"];
        chooseImage.tag = 1;
        chooseImage.userInteractionEnabled = YES;
        [backgroundView addSubview:chooseImage];
        UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(chooseImage.right+15, chooseImage.top, 180*MCscale, 20*MCscale)];
        money.textColor  = txtColors(248, 53, 74, 1);
        money.textAlignment = NSTextAlignmentLeft;
        money.font = [UIFont systemFontOfSize:MLwordFont_2];
        money.text =[NSString stringWithFormat:@"%@元 %@",mod.jine,mod.hongbaotype];
        money.tag = 2;
        money.userInteractionEnabled = YES;
        [backgroundView addSubview:money];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, chooseImage.bottom+18*MCscale, moneyPop.width-20, 1)];
        line.backgroundColor = lineColor;
        [backgroundView addSubview:line];
    }
    scrolv.contentSize = CGSizeMake(moneyPop.width, 56*youhuidataAry.count);
}

//选中送货时间
-(void)ChooseSendTime
{
    DatePackView = [[SelectedTimeView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-(218+25*MCscale), kDeviceWidth, 218+25*MCscale)];
    DatePackView.tag =102;
    DatePackView.selectedTimeDelegate = self;
}

#pragma mark SelectedTimeDelegate
-(void)selectedTimeWithTag:(NSInteger)tag AndDate:(NSString *)datestr
{
    [UIView animateWithDuration:0.3 animations:^{
        DatePackView.alpha = 0;
        [DatePackView removeFromSuperview];
    }];
    UILabel *label = subTimeAry[tag-1];
    label.text = datestr;
    sendTimes = datestr;
}
//支付遮罩
-(void)payMaskView
{
    payMask = [[UIView alloc]initWithFrame:self.view.bounds];
    payMask.backgroundColor = [UIColor clearColor];
    payMask.alpha = 0;
    UITapGestureRecognizer *payTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payMaksAction)];
    [payMask addGestureRecognizer:payTap];
}
//订单备注
-(void)orderRemarkPop
{
    orderRemarkPop = [[PopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 224*MCscale)];
    orderRemarkPop.tag = 103;
    orderRemarkPop.btnTitle = @"保存";
    orderRemarkPop.delegate = self;
    orderRemarkPop.alpha = 0;
    remainTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20*MCscale, orderRemarkPop.width-20, 146*MCscale)];
    remainTextView.textAlignment = NSTextAlignmentLeft;
    remainTextView.backgroundColor = [UIColor clearColor];
    remainTextView.textColor = txtColors(194, 195, 196, 1);
    remainTextView.font = [UIFont systemFontOfSize:MLwordFont_2];
    remainTextView.text = @"请输入特殊要求（50字符）";
    remainTextView.delegate = self;
    remainTextView.tag = 10001;
    [orderRemarkPop addSubview:remainTextView];
}
//发票台头
-(void)billHeadPop
{
    billHeadPop = [[PopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 224*MCscale)];
    billHeadPop.tag = 104;
    billHeadPop.btnTitle = @"保存";
    billHeadPop.delegate = self;
    billHeadPop.alpha = 0;
    billTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, orderRemarkPop.width-20, 146*MCscale)];
    billTextView.textAlignment = NSTextAlignmentLeft;
    billTextView.backgroundColor = [UIColor clearColor];
    billTextView.textColor = txtColors(194, 195, 196, 1);
    billTextView.font = [UIFont systemFontOfSize:MLwordFont_2];
    billTextView.text = @"请填写发票台头名称";
    billTextView.delegate = self;
    billTextView.tag = 10002;
    [billHeadPop addSubview:billTextView];
}
//输入支付密码
-(void)inputPass
{
    passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
    passPopView.paymentPasswordDelegate = self;
    passPopView.alpha = 0;
}

#pragma mark  PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        payMask.alpha = 0;
        [payMask removeFromSuperview];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    [HTTPTool postWithUrl:@"saveagain.action" params:ppmdic success:^(id json) {
        NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
        if ([message isEqualToString:@"1"]) {
            NSNotification *notification = [NSNotification notificationWithName:@"orderCreatSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCreatSuccess" object:nil];
            NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
            [HTTPTool getWithUrl:@"savezhangdan.action" params:pramDic success:^(id json) {
            } failure:^(NSError *error) {
                [allBub hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
            [self chooseSeccJump];
        }
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}


#pragma mark-- footView
-(void)loadFootView
{
    orderMoney *model = orderModleAry[orderModleAry.count-1];
    //底部视图
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    footView.backgroundColor = txtColors(25, 182, 133, 0.8);
    
    //金额
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = txtColors(237, 58, 76, 1);
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.totalPrices floatValue]];
    CGSize  size = [moneyLabel.text boundingRectWithSize:CGSizeMake(140*MCscale, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15],NSFontAttributeName, nil] context:nil].size;
    moneyLabel.frame = CGRectMake(25*MCscale, 12, size.width+10, 30);
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_15];
    [footView addSubview:moneyLabel];
    
    //优惠
    coupon = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right, 18, 80, 20)];
    coupon.backgroundColor = [UIColor clearColor];
    coupon.textAlignment = NSTextAlignmentLeft;
    coupon.textColor = txtColors(237, 58, 76, 1);
    NSString *yyuu = [NSString stringWithFormat:@"%@",model.youhuis];
    if ([yyuu isEqualToString:@"0"]) {
        coupon.text = @"";
        coupon.alpha = 0;
    }
    else{
        coupon.alpha = 1;
        coupon.text = [NSString stringWithFormat:@"已优惠¥%@",model.youhuis];
    }
    coupon.font = [UIFont systemFontOfSize:MLwordFont_6];
    [footView addSubview:coupon];
    
    //去下单
    goToOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    goToOrder.frame = CGRectMake(kDeviceWidth-120*MCscale, 10, 100*MCscale, 30*MCscale);
    goToOrder.backgroundColor = [UIColor clearColor];
    [goToOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goToOrder setTitle:@"确认订单" forState:UIControlStateNormal];
    [goToOrder setBackgroundImage:[UIImage imageNamed:@"去下单"] forState:UIControlStateNormal];
    [goToOrder addTarget:self action:@selector(goToCheck) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:goToOrder];
    [self.view addSubview:footView];
}
//在线支付方式
-(void)initOnlPayWayAction
{
    onlinePayWayPop = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth*3/20.0, 330*MCscale, kDeviceWidth*7/10.0, 135*MCscale)];
    onlinePayWayPop.backgroundColor = [UIColor whiteColor];
    onlinePayWayPop.tag = 110;
    onlinePayWayPop.layer.cornerRadius = 15.0;
    onlinePayWayPop.layer.shadowRadius = 5.0;
    onlinePayWayPop.layer.shadowOpacity = 0.5;
    onlinePayWayPop.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5*MCscale, 15*MCscale, onlinePayWayPop.width-20*MCscale, 45*MCscale)];
    img.image = [UIImage imageNamed:@"支付宝"];
    img.backgroundColor = [UIColor clearColor];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.userInteractionEnabled = YES;
    img.tag = 101;
    [onlinePayWayPop addSubview:img];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureOnlPay:)];
    [img addGestureRecognizer:tap];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, img.bottom+5, onlinePayWayPop.width-10*MCscale, 1)];
    line.backgroundColor = lineColor;
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(5*MCscale, 75*MCscale, onlinePayWayPop.width-20*MCscale, 45*MCscale)];
    img1.image = [UIImage imageNamed:@"微支付"];
    img1.backgroundColor = [UIColor clearColor];
    img1.contentMode = UIViewContentModeScaleAspectFit;
    img1.userInteractionEnabled = YES;
    img1.tag = 102;
    [onlinePayWayPop addSubview:img1];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureOnlPay:)];
    [img1 addGestureRecognizer:tap1];
    
    [onlinePayWayPop addSubview:line];
}
//弹框遮罩
-(void)maskView
{
    mask = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    mask.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == addressTable) {
        return 1;
    }
    return dataArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == addressTable) {
        return addresDataAry.count;
    }
    else{
        if (section == 0) {
            return 4;
        }
        else{
            agnAdresModel *modl = dataArray[0];
            NSInteger cnum = 2;
            if ([modl.fapiao integerValue] == 1) {
                cnum = 3;
            }
            return orderGoodDataAry.count+cnum;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == orderTableView){
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            for (int i = 0; i<3; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
                label.tag = 1001+i;//1001 1002 1003
                label.alpha = 0;
                [cell.contentView addSubview:label];
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom ];
            btn.frame = CGRectZero;
            btn.tag = 1004;
            btn.alpha = 0;
            [cell.contentView addSubview:btn];
            for (int j = 0; j<2; j++) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
                image.tag = 1005+j;//1006 1005
                image.alpha = 0;
                [cell.contentView addSubview:image];
            }
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectZero];
            line1.tag = 1007;
            line1.alpha = 0;
            [cell.contentView addSubview:line1];
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectZero];
            line2.tag = 1008;
            line2.alpha = 0;
            [cell.contentView addSubview:line2];
        }
        NSArray *titleArray = @[@"使用优惠",@"货到付款",@"在线付款",@"余额支付"];
        NSArray *ary = @[@"送达时间",@"订单备注",@"需要发票"];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UILabel *title = (UILabel *)[cell viewWithTag:1001];
                title.frame = CGRectMake(30*MCscale, 18*MCscale, 80*MCscale, 20*MCscale);
                title.alpha = 1;
                title.text = titleArray[indexPath.row];
                title.textColor = [UIColor blackColor];
                title.textAlignment = NSTextAlignmentLeft;
                title.font = [UIFont systemFontOfSize:MLwordFont_4];
                UIImageView *tanhao = (UIImageView *)[cell viewWithTag:1005];
                if (isYouhuiquan == 0) {
                    tanhao.alpha = 1;
                }
                else
                    tanhao.alpha = 0;
                tanhao.frame =CGRectMake(kDeviceWidth-180*MCscale, 20*MCscale, 18*MCscale, 18*MCscale);
                tanhao.image= [UIImage imageNamed:@"叹号"];
                tanhao.backgroundColor = [UIColor clearColor];
                [maskImageArray addObject:tanhao];
                UILabel *couponLabel = (UILabel *)[cell viewWithTag:1002];
                couponLabel.alpha = 1;
                couponLabel.frame = CGRectMake(tanhao.right, 18*MCscale, 115*MCscale, 20*MCscale);
                if (isChooseYh) {
                    youhuiModel *mod = youhuidataAry[lastChoose-10];
                    couponLabel.text = [NSString stringWithFormat:@"%@元",mod.jine];
                    tanhao.alpha = 0;
                }
                else
                    couponLabel.text = @"暂无优惠券可用";
                couponLabel.textAlignment = NSTextAlignmentRight;
                couponLabel.textColor = redTextColor;
                couponLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
                couponLabel.userInteractionEnabled = YES;
                [maskImageArray addObject:couponLabel];
                UIImageView *direction =(UIImageView *)[cell viewWithTag:1006];
                direction.alpha = 1;;
                direction.userInteractionEnabled = YES;
                direction.frame = CGRectMake(kDeviceWidth-45*MCscale, 20*MCscale, 17*MCscale, 17*MCscale);
                direction.image = [UIImage imageNamed:@"下拉键"];
                direction.backgroundColor = [UIColor clearColor];
                UIView *line = (UIView *)[cell viewWithTag:1007];
                line.alpha = 1;
                line.frame = CGRectMake(0, 54*MCscale, kDeviceWidth, 0.5);
                line.backgroundColor = lineColor;
            }
            if(indexPath.row>0 && indexPath.row <4){
                UILabel *title = (UILabel *)[cell viewWithTag:1001];
                title.frame = CGRectMake(30*MCscale, 18*MCscale, 80*MCscale, 20*MCscale);
                title.alpha = 1;
                title.text = titleArray[indexPath.row];
                title.textColor = [UIColor blackColor];
                title.textAlignment = NSTextAlignmentLeft;
                title.font = [UIFont systemFontOfSize:MLwordFont_4];
                UIImageView *chooseImage = (UIImageView *)[cell viewWithTag:1006];
                chooseImage.alpha = 1;
                chooseImage.frame = CGRectMake(kDeviceWidth-50*MCscale, 16*MCscale, 22*MCscale, 22*MCscale);
                chooseImage.userInteractionEnabled = YES;
                if (indexPath.row == lastChoosePay) {
                    chooseImage.image = [UIImage imageNamed:@"选中"];
                }
                else{
                    chooseImage.image = [UIImage imageNamed:@"选择"];
                }
                chooseImage.backgroundColor = [UIColor clearColor];
                chooseImage.tag = indexPath.row;
                if (chooseImage !=nil) {
                    [choosePayArray addObject:chooseImage];
                }
                if (indexPath.row == 1) {
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.frame = CGRectMake(20, 54*MCscale, kDeviceWidth-40, 0.5);
                    line.backgroundColor = lineColor;
                }
                if (indexPath.row == 2){
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.frame = CGRectMake(20, 54*MCscale, kDeviceWidth-40, 0.5);
                    line.backgroundColor = lineColor;
                    UILabel *couponLabel = (UILabel *)[cell viewWithTag:1002];
                    couponLabel.alpha = 0;
                    couponLabel.userInteractionEnabled = YES;
                    couponLabel.frame = CGRectMake(title.right+30*MCscale, title.top+2, 80*MCscale, 20*MCscale);
                    couponLabel.text = @"支付宝";
                    couponLabel.textAlignment = NSTextAlignmentRight;
                    couponLabel.textColor = txtColors(248, 53, 74, 1);
                    couponLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
                    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(morewayTapAction)];
                    [couponLabel addGestureRecognizer:tp];
                    
                    UIImageView *jhImg = (UIImageView *)[cell viewWithTag:1005];
                    jhImg.frame = CGRectMake(couponLabel.right+5*MCscale, title.top+4*MCscale, 18*MCscale, 15*MCscale);
                    jhImg.alpha = 0;
                    jhImg.userInteractionEnabled = YES;
                    jhImg.image = [UIImage imageNamed:@"红色下拉键"];
                    jhImg.backgroundColor = [UIColor clearColor];
                    UITapGestureRecognizer *tpm = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(morewayTapAction)];
                    [jhImg addGestureRecognizer:tpm];
                }
                if (indexPath.row == 3) {
                    UILabel *subLabel = (UILabel *)[cell viewWithTag:1002];
                    subLabel.alpha = 1;
                    subLabel.backgroundColor = redTextColor;
                    subLabel.text = [NSString stringWithFormat:@"可用余额%.2f",[zhangdanyue floatValue]];
                    CGSize size = [subLabel.text boundingRectWithSize:CGSizeMake(150*MCscale, 15*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName,nil] context:nil].size;
                    subLabel.frame = CGRectMake(title.right, title.top+2, size.width, 15*MCscale);
                    subLabel.textColor = [UIColor whiteColor];
                    subLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
                    subLabel.textAlignment = NSTextAlignmentCenter;
                    
                    UILabel *ssubl = (UILabel *)[cell viewWithTag:1003];
                    ssubl.frame = CGRectMake(subLabel.right+15*MCscale, subLabel.top, 100*MCscale, 15*MCscale);
                    ssubl.alpha = 0;
                    ssubl.text = @"余额不足,去充值";
                    ssubl.textColor = txtColors(248, 53, 74, 1);
                    ssubl.textAlignment = NSTextAlignmentRight;
                    ssubl.backgroundColor = [UIColor clearColor];
                    ssubl.font = [UIFont systemFontOfSize:MLwordFont_9];
                    
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.backgroundColor = txtColors(231, 232, 234, 0.8);
                    line.frame = CGRectMake(0, cell.height -1*MCscale, kDeviceWidth, 1*MCscale);
                }
            }
        }
        else{
            agnAdresModel *modl = dataArray[0];
            NSInteger scnum = 2;
            if ([modl.fapiao integerValue]==1) {
                scnum = 3;
            }
            if (indexPath.row < scnum) {
                UILabel *title = (UILabel *)[cell viewWithTag:1001];
                title.alpha = 1;
                title.frame = CGRectMake(30*MCscale, 18*MCscale, 80*MCscale, 20*MCscale);
                title.text = ary[indexPath.row];
                title.textAlignment = NSTextAlignmentLeft;
                title.textColor = [UIColor blackColor];
                title.font = [UIFont systemFontOfSize:MLwordFont_4];
                UILabel *subtitlle = (UILabel *)[cell viewWithTag:1002];
                subtitlle.alpha = 1;
                subtitlle.frame = CGRectMake(kDeviceWidth-210*MCscale, 18*MCscale, 160*MCscale, 20*MCscale);
                subtitlle.textAlignment = NSTextAlignmentRight;
                subtitlle.textColor = textColors;
                subtitlle.font = [UIFont systemFontOfSize:MLwordFont_7];
                subtitlle.backgroundColor = [UIColor clearColor];
                subtitlle.userInteractionEnabled = YES;
                if (indexPath.row == 0) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendTimeAction:)];
                    [subtitlle addGestureRecognizer:tap];
                    if (subTimeAry.count < dataArray.count) {
                        [subTimeAry addObject:subtitlle];
                    }
                    subtitlle.text = sendTimes;
                    if ([subtitlle.text isEqualToString:@"立即配送"]) {
                        subtitlle.textColor = textColors;
                    }
                    else{
                        subtitlle.textColor = txtColors(236, 27, 60, 0.9);
                    }
                }
                else if (indexPath.row ==1) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderRemarkAction:)];
                    [subtitlle addGestureRecognizer:tap];
                    if (subBeizhuAry.count < dataArray.count) {
                        [subBeizhuAry addObject:subtitlle];
                    }
                    subtitlle.text = orderbzhuStr;
                }
                else{
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(billHeadAction:)];
                    [subtitlle addGestureRecognizer:tap];
                    if (subOrderHeadAry.count <= dataArray.count) {
                        [subOrderHeadAry addObject:subtitlle];
                    }
                    subtitlle.text = orderheadStr;
                }
                UIImageView *direction = (UIImageView *)[cell viewWithTag:1005];
                direction.alpha = 1;
                direction.frame = CGRectMake(kDeviceWidth-45*MCscale, 20*MCscale, 17*MCscale, 17*MCscale);
                direction.image = [UIImage imageNamed:@"下拉键"];
                direction.backgroundColor = [UIColor clearColor];
                direction.userInteractionEnabled = YES;
                if (indexPath.row == 0) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendTimeAction:)];
                    [direction addGestureRecognizer:tap];
                }
                else if (indexPath.row == 1){
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderRemarkAction:)];
                    [direction addGestureRecognizer:tap];
                }
                else{
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(billHeadAction:)];
                    [direction addGestureRecognizer:tap];
                }
                if (indexPath.row == 0) {
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.frame = CGRectMake(0, 0, kDeviceWidth, 1);
                    line.backgroundColor = lineColor;
                    UIView *line2 = (UIView *)[cell viewWithTag:1008];
                    line2.alpha = 1;
                    line2.frame = CGRectMake(20, 54*MCscale, kDeviceWidth-40, 0.5);
                    line2.backgroundColor = lineColor;
                }
                if (indexPath.row==1) {
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.frame = CGRectMake(20, 54*MCscale, kDeviceWidth-40, 0.5);
                    line.backgroundColor = lineColor;
                    UIView *line8 = (UILabel *)[cell viewWithTag:1008];
                    line8.alpha = 0;
                }
                if (indexPath.row == 2) {
                    UIView *line = (UIView *)[cell viewWithTag:1007];
                    line.alpha = 1;
                    line.frame =  CGRectMake(0, 54*MCscale, kDeviceWidth, 1);
                    line.backgroundColor = lineColor;
                    UIView *line8 = (UILabel *)[cell viewWithTag:1008];
                    line8.alpha = 0;
                }
            }
            else{
                if (indexPath.row <orderGoodDataAry.count+2) {
                    UIView *line = (UIView *)[cell viewWithTag:1008];
                    line.alpha = 1;
                    line.frame = CGRectMake(20, 34*MCscale, kDeviceWidth-40, 0.5);
                    line.backgroundColor = lineColor;
                }
                else{
                    UIView *line = (UIView *)[cell viewWithTag:1008];
                    line.alpha = 1;
                    line.frame = CGRectMake(0, 34*MCscale, kDeviceWidth, 1);
                    line.backgroundColor = lineColor;
                }
                orderAgnGoodModle *model = orderGoodDataAry[indexPath.row-scnum];
                UIImageView *logo = (UIImageView *)[cell viewWithTag:1005];
                logo.alpha = 1;
                logo.frame = CGRectMake(25*MCscale, 1, 30*MCscale, 30*MCscale);
                logo.contentMode = UIViewContentModeScaleAspectFit;
                [logo sd_setImageWithURL:[NSURL URLWithString:model.shopimg] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
                logo.backgroundColor = [UIColor clearColor];
                
                UILabel *subTitle = (UILabel *)[cell viewWithTag:1001];
                subTitle.alpha = 1;
                subTitle.frame = CGRectMake(logo.right+5, 8, 120*MCscale, 20*MCscale);
                subTitle.text = model.shopname;
                subTitle.textAlignment =NSTextAlignmentLeft;
                subTitle.font = [UIFont systemFontOfSize:MLwordFont_9];
                
                UILabel *numberLabel = (UILabel *)[cell viewWithTag:1002];
                numberLabel.alpha = 1;
                numberLabel.frame = CGRectMake(kDeviceWidth-150*MCscale, 8, 30*MCscale, 20*MCscale);
                numberLabel.text = [NSString stringWithFormat:@"X%@",model.shuliang];
                numberLabel.textAlignment = NSTextAlignmentRight;
                numberLabel.textColor = textColors;
                numberLabel.backgroundColor = [UIColor clearColor];
                numberLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
                
                UILabel *money = (UILabel *)[cell viewWithTag:1003];
                money.alpha = 1;
                money.frame = CGRectMake(kDeviceWidth-100*MCscale, 8, 80*MCscale, 20*MCscale);
                money.textAlignment = NSTextAlignmentRight;
                money.textColor = textColors;
                money.text = [NSString stringWithFormat:@"¥%.2f",[model.jiage floatValue]];
                money.font = [UIFont systemFontOfSize:MLwordFont_9];
                money.backgroundColor = [UIColor clearColor];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        addressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[addressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.modl = addresDataAry[indexPath.row];
        cell.delImage.tag = indexPath.row+1;
        if (indexPath.row == lastChooseAddress) {
            cell.choseImage.image = [UIImage imageNamed:@"选中"];
            cell.delImage.hidden = YES;
        }
        else{
            cell.choseImage.image = [UIImage imageNamed:@"选择"];
            cell.delImage.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == orderTableView){
        if (indexPath.section == 0) {
            if(indexPath.row == 0){
                [self chooseCouponAction];
            }
            else if(indexPath.row>0 && indexPath.row<4){
                [self choosePayAction:indexPath.row];
            }
        }
    }
    else{
        addressCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        NSIndexPath *lastIndePath = [NSIndexPath indexPathForRow:lastChooseAddress inSection:0];
        addressCell *lastCell = [tableView cellForRowAtIndexPath:lastIndePath];
        if(indexPath !=lastIndePath){
            newCell.choseImage.image = [UIImage imageNamed:@"选中"];
            newCell.delImage.hidden = YES;
            lastCell.choseImage.image = [UIImage imageNamed:@"选择"];
            lastCell.delImage.hidden = NO;
        }
        userAddressModel *model = addresDataAry[indexPath.row];
        NSString *shouhuodz = [NSString stringWithFormat:@"%@",model.dizhiId];
        UILabel *name = headViewsAry[0];
        UILabel *tel = headViewsAry[1];
        UILabel *adres = headViewsAry[2];
        NSString *sexName = [NSString stringWithFormat:@"%@",model.name];
        NSRange range = [sexName rangeOfString:@"("];
        if (range.location == NSNotFound) {
            name.text = sexName;
        }
        else{
            NSString *nameStr = [sexName substringWithRange:NSMakeRange(0, range.location)];
            name.text = nameStr;
        }
        tel.text = model.haoma;
        adres.text = model.address;
        defaultdizId = [NSString stringWithFormat:@"%@",model.dizhiId];
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            changeAddressPopView.alpha =0;
            [changeAddressPopView removeFromSuperview];
        }];
        [self changeRelodMoey:shouhuodz];
        lastChooseAddress = indexPath.row;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addressTable) {
        return 85*MCscale;
    }
    else{
        if (indexPath.section>=1 && indexPath.row >godCount) {
            return 35*MCscale;
        }
        return 55*MCscale;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 40*MCscale;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section!=0) {
        return 40*MCscale;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        orderModel *mod = dataArray[0];
        NSString *youh ;
        if (orderModleAry.count != 0) {
            orderMoney *mModel = orderModleAry[section-1];
            youh = [NSString stringWithFormat:@"%@",mModel.youhui];
        }
        else{
            youh = @"";
        }
        NSString *shopName = mod.dianpuname;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 4)];
        line.backgroundColor = txtColors(231, 232, 234, 0.8);
        [view addSubview:line];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, 160*MCscale, 20*MCscale)];
        title.text = shopName;
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = textColors;
        title.font = [UIFont systemFontOfSize:MLwordFont_4];
        [view addSubview:title];
        
        UILabel *youhui = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-142*MCscale, 10*MCscale, 40*MCscale, 20*MCscale)];
        youhui.textColor = textColors;
        youhui.text = @"优惠";
        youhui.textAlignment = NSTextAlignmentRight;
        youhui.font = [UIFont boldSystemFontOfSize:MLwordFont_4];
        [view addSubview:youhui];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(youhui.right+2, 15*MCscale, 15*MCscale, 15*MCscale)];
        image.image = [UIImage imageNamed:@"减1"];
        image.backgroundColor = [UIColor clearColor];
        [view addSubview:image];
        
        UILabel *cutMoney = [[UILabel alloc]initWithFrame:CGRectMake(image.right, 10, 60*MCscale, 20*MCscale)];
        cutMoney.textAlignment= NSTextAlignmentRight;
        cutMoney.text = [NSString stringWithFormat:@"-¥%@",youh];
        cutMoney.font = [UIFont systemFontOfSize:MLwordFont_7];
        cutMoney.textColor = textColors;
        cutMoney.backgroundColor = [UIColor clearColor];
        [view addSubview:cutMoney];
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section!=0) {
        orderMoney *mModel =orderModleAry[section-1];
        UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        fotView.backgroundColor = [UIColor whiteColor];
        
        UILabel *sendMoney = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80*MCscale, 20*MCscale)];
        if ([mModel.peisongmoney floatValue]>0) {
            sendMoney.text = [NSString stringWithFormat:@"配送费:%@",mModel.peisongmoney];
            sendMoney.alpha = 1;
        }
        else
            sendMoney.alpha = 0;
        sendMoney.textAlignment = NSTextAlignmentLeft;
        sendMoney.textColor = textColors;
        sendMoney.font = [UIFont systemFontOfSize:MLwordFont_7];
        [fotView addSubview:sendMoney];
        
        UILabel *fujiafei = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*MCscale, 20*MCscale)];
        fujiafei.center  = CGPointMake(kDeviceWidth/2.0, 15);
        if ([mModel.fujiamoney floatValue]>0) {
            fujiafei.text = [NSString stringWithFormat:@"附加费:%@",mModel.fujiamoney];
            fujiafei.alpha = 1;
        }
        else
            fujiafei.alpha = 0;
        fujiafei.textAlignment = NSTextAlignmentCenter;
        fujiafei.textColor = textColors;
        fujiafei.font = [UIFont systemFontOfSize:MLwordFont_7];
        [fotView addSubview:fujiafei];
        
        UILabel *totleMoney = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-180*MCscale, 5, 160*MCscale, 20*MCscale)];
        totleMoney.textColor = redTextColor;
        totleMoney.text =[NSString stringWithFormat:@"小计:%.2f",[mModel.totalPrice floatValue]];
        totleMoney.textAlignment = NSTextAlignmentRight;
        totleMoney.font = [UIFont boldSystemFontOfSize:MLwordFont_7];
        [fotView addSubview:totleMoney];
        
        return fotView;
    }
    return nil;
}
-(void)addressCell:(addressCell *)adresCell tapIndex:(NSInteger)index
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeIndeterminate;
    bud.delegate = self;
    bud.labelText = @"请稍等...";
    [bud show:YES];
    userAddressModel *modl = addresDataAry[index-1];
    NSString *dizhiId = [NSString stringWithFormat:@"%@",modl.dizhiId];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.id":dizhiId}];
    [HTTPTool getWithUrl:@"deletedizhi.action" params:pram success:^(id json) {
        [bud hide:YES];
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            UIScrollView *scrol = (UIScrollView *)[changeAddressPopView viewWithTag:1201];
            [scrol reloadInputViews];
            [addresDataAry removeObjectAtIndex:index-1];
            if (index-1 == lastChooseAddress) {
                lastChooseAddress = 0;
                userAddressModel *model = addresDataAry[0];
                NSString *shouhuodz = [NSString stringWithFormat:@"%@",model.dizhiId];
                UILabel *name = headViewsAry[0];
                UILabel *tel = headViewsAry[1];
                UILabel *adres = headViewsAry[2];
                name.text = model.name;
                tel.text = model.haoma;
                adres.text = model.address;
                defaultdizId = [NSString stringWithFormat:@"%@",model.dizhiId];
                [self changeRelodMoey:shouhuodz];
            }
            else{
                if (lastChooseAddress != addresDataAry.count) {
                    for (int i =0; i<addresDataAry.count; i++) {
                        userAddressModel *modl = addresDataAry[i];
                        NSString *dzId = [NSString stringWithFormat:@"%@",modl.dizhiId];
                        if ([dzId isEqualToString:defaultdizId]) {
                            lastChooseAddress = i;
                            continue;
                        }
                    }
                }
                else{
                    lastChooseAddress = lastChooseAddress-1;
                }
            }
            [addressTable reloadData];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"删除成功";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"删除失败";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [bud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark -- UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if ([textView.text isEqualToString:@"请输入特殊要求（50字符）"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    else if (textView.tag == 10002){
        if ([textView.text isEqualToString:@"请填写发票台头名称"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if ([textView.text isEqual:@""]) {
            textView.text = @"请输入特殊要求（50字符）";
            textView.textColor = txtColors(194, 195, 196, 1);
        }
    }
    else if(textView.tag == 10002){
        if ([textView.text isEqual:@""]) {
            textView.text = @"请填写发票台头名称";
            textView.textColor = txtColors(194, 195, 196, 1);
        }
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if (textView.text.length >50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}
#pragma mark -- UIButtonAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1002) {
        popViewTag = 107;
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 1;
            [self.view addSubview:mask];
            changeAddressPopView.alpha = 0.95;
            [self.view addSubview:changeAddressPopView];
        }];
    }
}
-(void)choosePayAction:(NSInteger)btnTag
{
    if (btnTag != lastChoosePay) {
        UIImageView *newImage = choosePayArray[btnTag-1];
        newImage.image = [UIImage imageNamed:@"选中"];
        UIImageView *lastImage = choosePayArray[lastChoosePay-1];
        lastImage.image = [UIImage imageNamed:@"选择"];
        lastChoosePay = btnTag;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [orderTableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = (UILabel *)[cell viewWithTag:1002];
    UIImageView *img = (UIImageView *)[cell viewWithTag:1005];
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell1 = [orderTableView cellForRowAtIndexPath:indexPath1];
    UILabel *lb1 = (UILabel *)[cell1 viewWithTag:1003];
    if (btnTag == 2) {
        lb.alpha = 1;
        img.alpha = 1;
    }
    else{
        lb.alpha = 0;
        img.alpha = 0;
    }
    if (btnTag == 3) {
        orderMoney *model = orderModleAry[orderModleAry.count-1];
        NSString *totlem = model.totalPrices;
        if ([totlem floatValue] > [zhangdanyue floatValue]) {
            [UIView animateWithDuration:0.3 animations:^{
                onLinePayView.alpha = 0.95;
                payMask.alpha = 1;
                [self.view addSubview:payMask];
                payMonyeNumStr = [NSString stringWithFormat:@"%.2f",[totlem floatValue]-[zhangdanyue floatValue]];
                onLinePayView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
                onLinePayView.isFrom = 4;
                onLinePayView.isFromSure = 1;
                onLinePayView.onLinePayDelegate = self;
                onLinePayView.moneyTextFiled.text = payMonyeNumStr;
                onLinePayView.shouldMoney = payMonyeNumStr;
                onLinePayView.yueZhifu.text = @"更多充值方式";
                [self.view addSubview:onLinePayView];
            }];
        }
        else{
            if ([zhifumima isEqualToString:@"1"]) {
                //未设置支付密码
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"还没有支付密码!请先设置一下吧";
                [bud showWhileExecuting:@selector(myTaskMore) onTarget:self withObject:nil animated:YES];
                [self performSelector:@selector(popPaswardView) withObject:self afterDelay:2.5];
            }
        }
    }
    else{
        lb1.alpha = 0;
    }
}
-(void)popPaswardView
{
    popViewTag = 108;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        newPayPas.alpha =1;
        [self.view addSubview:newPayPas];
    }];
}
//使用新地址
-(void)chooseAddressAction:(UITapGestureRecognizer *)tap
{
    popViewTag = 111;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        newAddressPop.alpha = 0.95;
        [self.view addSubview:newAddressPop];
    }];
}
//到付
-(void)daofuAction
{
    [HTTPTool postWithUrl:@"saveagain.action" params:ppmdic success:^(id json) {
        NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
        if ([message isEqualToString:@"1"]) {
            NSNotification *notification = [NSNotification notificationWithName:@"orderCreatSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCreatSuccess" object:nil];
            [self chooseSeccJump];
        }
        else{
            [allBub hide:YES];
            MBProgressHUD *mghud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mghud.mode = MBProgressHUDModeCustomView;
            mghud.labelText = @"下单失败!请稍后尝试";
            [mghud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}


-(void)goToCheck
{
    //-------->>>>>>>> 缺少优惠券 <<<<<<<<
    allBub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    allBub.mode = MBProgressHUDModeIndeterminate;
    allBub.delegate = self;
    allBub.labelText = @"请稍等...";
    [allBub show:YES];
    UILabel *nameL =  headViewsAry[0]; //收货人
    UILabel *telL =   headViewsAry[1]; //电话
    UILabel *adresL = headViewsAry[2]; //地址
    if ([nameL.text isEqualToString:@""] || [telL.text isEqualToString:@""] || [adresL.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"地址为空请完先善送货地址" preferredStyle:1];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSMutableArray *youhuiAry = [[NSMutableArray alloc]init]; //优惠
        NSMutableArray *yingfujineAry = [[NSMutableArray alloc]init]; //应付金额
        NSMutableArray *fujiafeiAry = [[NSMutableArray alloc]init]; //附加费
        NSMutableArray *peisongfiAry = [[NSMutableArray alloc]init];//配送费
        NSMutableArray *caiGouMoneyAry = [[NSMutableArray alloc]init];//采购费
        NSString *youhuiStr; //优惠 拼接
        NSString *xiaojiStr; //应付金额
        NSString *fujiafeiStr;//附加费
        NSString *shuliangStr;//数量
        NSString *peisongfeiStr;//配送费
        NSString *caiGouMoneyStr;//采购费
        for (int i =0; i<orderModleAry.count; i++) {
            orderMoney *mModel = orderModleAry[i];
            [youhuiAry addObject:mModel.youhui];
            [yingfujineAry addObject:mModel.totalPrice];
            [fujiafeiAry addObject:mModel.fujiamoney];
            [peisongfiAry addObject:mModel.peisongmoney];
            [caiGouMoneyAry addObject:mModel.caiguomoney];
        }
        agnAdresModel *model = dataArray[0];
        youhuiStr = [youhuiAry componentsJoinedByString:@","];     //优惠拼接字符串
        xiaojiStr = [yingfujineAry componentsJoinedByString:@","]; //应付金额字符串
        fujiafeiStr = [fujiafeiAry componentsJoinedByString:@","]; //附加费字符串
        peisongfeiStr = [peisongfiAry componentsJoinedByString:@","];  //配送费字符串
        caiGouMoneyStr = [caiGouMoneyAry componentsJoinedByString:@","]; //采购费字符串
        NSString *dianpuidStr =[NSString stringWithFormat:@"%@",model.dianpuid]; //店铺id 拼接
        NSString *bzstr = @"0";
        
        if ([orderbzhuStr isEqualToString:@"可输入特殊要求"]) {
            bzstr = @"0";
        }
        else
        {
            bzstr = orderbzhuStr;
        }
        
        NSString *fpStr =@"0" ;
        if ([orderheadStr isEqualToString:@"填写发票台头"]) {
            fpStr = @"0";
        }
        else
        {
         fpStr = orderheadStr;
        }
        NSString *dingdanTimeStr = sendTimes;//配送时间
        NSString *beizhuStr = bzstr;//备注
        NSString *fapiaotouStr = fpStr;//发票头
        NSInteger shul = 0;
        for (int j=0; j<orderGoodDataAry.count; j++) {
            orderAgnGoodModle *modl = orderGoodDataAry[j];
            shul = shul+[modl.shuliang integerValue];
        }
        shuliangStr = [NSString stringWithFormat:@"%ld",(long)shul]; //数量拼接字符串
        NSString *youHuimoney;
        if (youhuidataAry.count >0) {
            youhuiModel *yhmodl = youhuidataAry[lastChoose-10];
            if (isYouhuiquan) {
                youHuimoney = [NSString stringWithFormat:@"%@",yhmodl.hongbaoid];
            }
            else{
                youHuimoney = @"0";
            }
        }
        else
            youHuimoney = @"0";
        orderMoney *mMod = orderModleAry[0];
        NSString *jl = [NSString stringWithFormat:@"%@",mMod.juli];
        ppmdic = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"shequid":model.shequid,@"dipuids":dianpuidStr,@"dindan.shouhuoren":nameL.text,@"dindan.tel":telL.text,@"dindan.shouhuodizhi":adresL.text,@"dindan.zhifufangshi":[NSString stringWithFormat:@"%ld",(long)lastChoosePay],@"dindan.youhui":youhuiStr,@"dindan.yingfujine":xiaojiStr,@"dindan.yuyuesongdadate":dingdanTimeStr,@"dindan.fudongfei":fujiafeiStr,@"dindan.dindanbeizhu":beizhuStr, @"dindan.fapiaotaitou":fapiaotouStr,@"dindan.shuliang":shuliangStr,@"dindan.youhuijuan":youHuimoney,@"dindan.peisongfei":peisongfeiStr,@"dindan.danhao":_danhao,@"shdzid":jl,@"dindan.caigouchengben":caiGouMoneyStr}];
        
        NSLog(@"%@",ppmdic);
        
        //余额支付
        if (lastChoosePay == 3) {
            if ([zhifumima isEqualToString:@"2"]) {
                popViewTag = 105;
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 1;
                    [self.view addSubview:mask];
                    passPopView.alpha = 0.95;
                    [self.view addSubview:passPopView];
                }];
            }
            else{
                [allBub hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"还没有支付密码!请先设置一下吧";
                [bud showWhileExecuting:@selector(myTaskMore) onTarget:self withObject:nil animated:YES];
                [self performSelector:@selector(popPaswardView) withObject:self afterDelay:2.5];
            }
        }
        //支付宝
        else if (lastChoosePay == 2){
            [allBub hide:YES];
            if (!isWx) {
                [self zhifubaoAction];
            }
            else{
                isRecharge = 0;
                orderMoney *model = orderModleAry[orderModleAry.count-1];
                NSString *money = [NSString stringWithFormat:@"%@",model.totalPrices];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyMMddHHmmss"];
                NSString *dateTime = [formatter stringFromDate:[NSDate date]];
                NSString *orderid = [NSString stringWithFormat:@"%@%@",userShequ_id,dateTime];
                NSString *body = [NSString stringWithFormat:@"妙生活城+%@支付",orderid];
                [self WXpayAction:money bodying:body];
            }
        }
        //到付
        else{
            [self daofuAction];
        }
    }
}
//支付宝
-(void)zhifubaoAction
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequid":userShequ_id}];
    NSMutableDictionary *privateDic = [[NSMutableDictionary alloc]init];
    [HTTPTool getWithUrl:@"zhifu.action" params:pram success:^(id json) {
        if(json){
            [privateDic setValue:[json valueForKey:@"out_trade_no"] forKey:@"out_trade_no"];//单号
            [privateDic setValue:[json valueForKey:@"partner"] forKey:@"partner"];//appid
            [privateDic setValue:[json valueForKey:@"private_key"] forKey:@"private_key"];//私钥
            [privateDic setValue:[json valueForKey:@"seller_id"] forKey:@"seller_id"];//支付宝单号
            [self payMoney:privateDic];
        }
        else{
            [allBub hide:YES];
            MBProgressHUD *mghud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mghud.mode = MBProgressHUDModeCustomView;
            mghud.labelText = @"获取支付信息失败!请稍后尝试";
            [mghud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

#pragma  mark -- 支付宝跳转支付
-(void)payMoney:(NSMutableDictionary *)dic
{
    [allBub hide:YES];
    NSString *partner = [dic valueForKey:@"partner"];
    NSString *seller = [dic valueForKey:@"seller_id"];
    NSString *privateKey =[dic valueForKey:@"private_key"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *orderid = [NSString stringWithFormat:@"%@%@",userShequ_id,dateTime];    UILabel *telL =   headViewsAry[1]; //电话
    NSString *body;
    NSString *sbid = [NSString stringWithFormat:@"%@",userSheBei_id];
    NSString *usid = [NSString stringWithFormat:@"%@",user_id];
    if ([sbid isEqualToString:usid]) {
        body = telL.text;
    }
    else
        body = [NSString stringWithFormat:@"%@",user_id];
    orderMoney *model = orderModleAry[orderModleAry.count-1];
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderid; //订单ID(由商家□自□行制定)
    order.productName =[NSString stringWithFormat:@"妙生活城+%@支付",orderid]; //商品标题
    order.productDescription = body; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",model.totalPrices]; //商 品价格
    order.notifyURL = [NSString stringWithFormat:@"%@notify_url.jsp",HTTPHEADER]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    NSString *orderSpec = [order description];
    NSString *appScheme = @"alisdkdemo";
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *payState = [resultDic valueForKey:@"resultStatus"];
            if ([payState isEqualToString:@"9000"]) {
                [ppmdic setValue:orderid forKey:@"dindan.zhifufangshi"];
                [HTTPTool postWithUrl:@"saveagain.action" params:ppmdic success:^(id json) {
                    NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
                    if ([message isEqualToString:@"1"]) {
                        NSNotification *notification = [NSNotification notificationWithName:@"orderCreatSuccess" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCreatSuccess" object:nil];
                        NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
                        [HTTPTool getWithUrl:@"savezhangdan.action" params:pramDic success:^(id json) {
                        } failure:^(NSError *error) {
                        }];
                        [self chooseSeccJump];
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"网络连接错误";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else{
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"支付失败";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }];
    }
}

#pragma mark -- 微支付
-(void)WXpayAction:(NSString *)money bodying:(NSString *)body
{
    if (wxPaymessage.count == 0) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"total_fee":money,@"shequid":userShequ_id,@"body":body,@"userid":user_id}];
        [HTTPTool postWithUrl:@"weixingfangwen.action" params:pram success:^(id json) {
            MyLog(@"%@",json);
            [allBub hide:YES];
            [wxPaymessage setValue:[json valueForKey:@"dingdanhao"] forKey:@"dingdanhao"];
            [wxPaymessage setValue:[json valueForKey:@"noncestr"] forKey:@"noncestr"];
            [wxPaymessage setValue:[json valueForKey:@"package"] forKey:@"package"];
            [wxPaymessage setValue:[json valueForKey:@"partnerid"] forKey:@"partnerid"];
            [wxPaymessage setValue:[json valueForKey:@"prepayid"] forKey:@"prepayid"];
            [wxPaymessage setValue:[json valueForKey:@"sign"] forKey:@"sign"];
            [wxPaymessage setValue:[json valueForKey:@"timestamp"] forKey:@"timestamp"];
            MyLog(@"---%@",wxPaymessage);
            [self wzf:wxPaymessage];
        } failure:^(NSError *error) {
            MyLog(@"%@",error);
            [allBub hide:YES];
        }];
    }
    else
        [self wzf:wxPaymessage];
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
        }else{
            MyLog(@"retmsg%@",[dic objectForKey:@"retmsg"]);
        }
    }
}
-(void)wxPayResult:(NSNotification *)notifaction
{
    if (wxPaymessage) {
        MyLog(@"-- zhifuNO3 -- ");
        if (!isRecharge) {
            PayResp *resp = notifaction.object;
            NSString *orderid = [wxPaymessage valueForKey:@"dingdanhao"];
            if (resp.errCode == WXSuccess) {
                [ppmdic setValue:orderid forKey:@"dindan.zhifufangshi"];
                [HTTPTool postWithUrl:@"saveagain.action" params:ppmdic success:^(id json) {
                    MyLog(@"-- zhifu5 -- ");
                    NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
                    if ([message isEqualToString:@"1"]) {
                        NSNotification *notification = [NSNotification notificationWithName:@"orderCreatSuccess" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderCreatSuccess" object:nil];
                        [self chooseSeccJump];
                        MyLog(@"-- zhifu4 -- ");
                    }
                } failure:^(NSError *error) {
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
//                    bud.labelText = @"";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
            else{
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"支付失败";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
    }
    [wxPaymessage removeAllObjects];
}


#pragma mark -- OnLinePayViewDelegate
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money
{
    [self morePayWay];
}
//充值成功的通知
-(void)RechargSuccess
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeCustomView;
    mbHud.labelText = @"充值成功";
    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        payMask.alpha = 0;
        [payMask removeFromSuperview];
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell1 = [orderTableView cellForRowAtIndexPath:indexPath1];
    UILabel *lb1 = (UILabel *)[cell1 viewWithTag:1003];
    lb1.alpha =0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [orderTableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = (UILabel *)[cell viewWithTag:1002];
    lb.text = [NSString stringWithFormat:@"可用余额%.2f",[zhangdanyue floatValue]+[payMonyeNumStr floatValue]];
    CGSize size = [lb.text boundingRectWithSize:CGSizeMake(150*MCscale, 15*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName,nil] context:nil].size;
    lb.frame = CGRectMake(110*MCscale, 20*MCscale, size.width, 15*MCscale);
    
    [self performSelector:@selector(isSetPas) withObject:nil afterDelay:1.5];
    NSNotification *goodPageNotification = [NSNotification notificationWithName:@"chongzhiSueecss" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:goodPageNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chongzhiSueecss" object:nil];
}
-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        payMask.alpha = 0;
        [payMask removeFromSuperview];
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
}
//支付成功后下单跳转
-(void)chooseSeccJump
{
    MyLog(@"-- zhifu1 -- ");
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"pageNum":@"1"}];
    [HTTPTool getWithUrl:@"findjinqidingdan.action" params:pram success:^(id json) {
        MyLog(@"-- zhifu2 -- ");
        [allBub hide:YES];
        NSArray *ary = [json valueForKey:@"diangdanlist"];
        NSDictionary *dic = ary[0];
        NSString *dnhaol = [dic valueForKey:@"danhao"];
        NSNotification *goodPageNotification = [NSNotification notificationWithName:@"orderYouhActess" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:goodPageNotification];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderYouhActess" object:nil];
        orderDetailViewController *vc = [[orderDetailViewController alloc]init];
        vc.dingdanId = dnhaol;
        vc.isOrderAgn = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

//余额不足提示
-(void)notEnoughMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"账户余额不足是否充值" preferredStyle:1];
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        payMask.alpha = 1;
        [self.view addSubview:payMask];
        onLinePayView.alpha = 0.95;
        [self.view addSubview:onLinePayView];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIImageView *lastImage = choosePayArray[lastChoosePay-1];
        lastImage.image = [UIImage imageNamed:@"选择"];
        UIImageView *newImage = choosePayArray[0];
        newImage.image = [UIImage imageNamed:@"选中"];
        lastChoosePay = 1;
    }];
    [alert addAction:suerAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 弹框
//使用优惠弹框
-(void)chooseCouponAction
{
    popViewTag = 101;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        moneyPop.alpha = 0.95;
        [self.view addSubview:moneyPop];
    }];
}
//送达时间
-(void)sendTimeAction:(UITapGestureRecognizer *)tap
{
    UITableViewCell *cell =(UITableViewCell *)[tap.view superview].superview;
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    popViewTag = 102;
    [UIView animateWithDuration:0.3 animations:^{
        DatePackView.saveBtn.tag = section;
        [DatePackView addSubview:DatePackView.saveBtn];
        DatePackView.alpha = 0.95;
        [self.view addSubview:DatePackView];
    }];
}
//订单备注
-(void)orderRemarkAction:(UITapGestureRecognizer *)tap
{
    UITableViewCell *cell =(UITableViewCell *)[tap.view superview].superview;
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    popViewTag = 103;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        orderRemarkPop.alpha = 0.95;
        orderRemarkPop.popBtn.tag = section;
        [self.view addSubview:orderRemarkPop];
    }];
}
//填写发票台头
-(void)billHeadAction:(UITapGestureRecognizer *)tap
{
    UITableViewCell *cell =(UITableViewCell *)[tap.view superview].superview;
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    popViewTag = 104;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        billHeadPop.alpha = 0.95;
        billHeadPop.popBtn.tag = section;
        [self.view addSubview:billHeadPop];
    }];
}
//弹框遮罩
-(void)maskDisMiss
{
    UIView *pop = (UIView *)[self.view viewWithTag:popViewTag];
    if (popViewTag == 101 || popViewTag == 107 || popViewTag == 109 || popViewTag == 110) {
        UIView *pop = (UIView *)[self.view viewWithTag:popViewTag];
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            pop.alpha = 0;
            [self.view endEditing:YES];
            [pop removeFromSuperview];
        }];
    }
    else if(popViewTag == 108){
        [UIView animateWithDuration:0.3 animations:^{
            UIImageView *newImage = choosePayArray[0];
            newImage.image = [UIImage imageNamed:@"选中"];
            UIImageView *lastImage = choosePayArray[lastChoosePay-1];
            lastImage.image = [UIImage imageNamed:@"选择"];
            lastChoosePay = 1;
            mask.alpha = 0;
            [mask removeFromSuperview];
            pop.alpha = 0;
            [self.view endEditing:YES];
            [pop removeFromSuperview];
        }];
    }
    else if (popViewTag == 105){
        UIView *pop = (UIView *)[self.view viewWithTag:popViewTag];
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            pop.alpha = 0;
            [self.view endEditing:YES];
            [pop removeFromSuperview];
        }];
        [allBub hide:YES];
    }
    else if(popViewTag == 102){
        UIView *pop = (UIView *)[self.view viewWithTag:popViewTag];
        [UIView animateWithDuration:0.3 animations:^{
            pop.alpha = 0;
            [self.view endEditing:YES];
            [pop removeFromSuperview];
        }];
    }
    else if (popViewTag == 111)
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            newAddressPop.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            [newAddressPop removeFromSuperview];
        }];
        
    }
    else{
        PopView *pop = (PopView *)[self.view viewWithTag:popViewTag];
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            pop.alpha = 0;
            [self.view endEditing:YES];
            [pop removeFromSuperview];
        }];
    }
    [self.view endEditing:YES];
}

//选择优惠
-(void)chooseCouponAction:(UITapGestureRecognizer *)tap
{
    isYouhuiquan = 1;
    NSInteger btnTag = tap.view.tag;
    UIScrollView *scrol = (UIScrollView *)[moneyPop viewWithTag:110011];
    UIView *pop = (UIView *)[self.view viewWithTag:popViewTag];
    youhuiModel *yhmodl = youhuidataAry[btnTag-10];
    if (lastChoose !=btnTag) {
        UILabel *couponLabel = maskImageArray[1];
        couponLabel.text = [NSString stringWithFormat:@"%@元",yhmodl.jine];
        couponLabel.textAlignment = NSTextAlignmentRight;
        if(lastChoose !=0){
            UIView *view = [scrol viewWithTag:lastChoose];
            UIImageView *lasImage = (UIImageView *)[view viewWithTag:1];
            lasImage.image = [UIImage imageNamed:@"选择"];
        }
        UIImageView *image = maskImageArray[0];
        UIView *lview = [scrol viewWithTag:btnTag];
        UIImageView *nImage =(UIImageView *)[lview viewWithTag:1];
        nImage.image = [UIImage imageNamed:@"选中"];
        image.alpha = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        pop.alpha = 0;
        [self.view endEditing:YES];
        [pop removeFromSuperview];
    }];
    lastChoose = btnTag;
    [self refreshYouhuiMoney];
}
//选择优惠后传后他刷新数据
-(void)refreshYouhuiMoney
{
    [orderModleAry removeAllObjects];
    youhuiModel *mod = youhuidataAry[lastChoose-10];
    NSString *youh = [NSString stringWithFormat:@"%@",mod.jine];
    NSMutableArray *dpuid = [[NSMutableArray alloc]init];
    for (int i = 0; i<dataArray.count; i++) {
        NSArray *ary = dataArray[i];
        if (ary.count > 0) {
            orderModel *modl = ary[0];
            NSString *dianpu = [NSString stringWithFormat:@"%@",modl.dianpuid];
            [dpuid addObject:dianpu];
        }
    }
    agnAdresModel *model = dataArray[0];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":model.shequid,@"youhuijuan":youh}];
    [HTTPTool getWithUrl:@"dingdantotalprice.action" params:pram success:^(id json) {
        NSDictionary *dic = [json valueForKey:@"moneys"];
        for (int j = 0; j<dpuid.count; j++) {
            NSDictionary *dc = [dic valueForKey:dpuid[j]];
            orderMoney *ormodl = [[orderMoney alloc]initWithContent:dc];
            [orderModleAry addObject:ormodl];
        }
        orderMoney *moneyModel = [[orderMoney alloc]initWithContent:dic];
        [orderModleAry addObject:moneyModel];
        isChooseYh = 1;
        [self initTableCellData];
        [self changeFootData];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

#pragma mark -- PopViewDelegate
-(void)popBtnAction:(PopView *)pop atIndex:(NSInteger)index btnTag:(NSInteger)btag
{
       PopView *popv = (PopView *)[self.view viewWithTag:index];
    if(index !=108){
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            popv.alpha = 0;
            [popv removeFromSuperview];
        }];
    }
    if (index == 108){
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            pop.alpha = 0;
            [pop removeFromSuperview];
        }];
        if (index == 103) {
            UILabel *lab = subBeizhuAry[btag-1];
            if ([remainTextView.text isEqualToString:@"请输入特殊要求（50字符）"]) {
                lab.text = @"可输入特殊要求";
            }
            else{
                lab.text = remainTextView.text;
                orderbzhuStr = remainTextView.text;
                
            }
            remainTextView.text = @"请输入特殊要求（50字符）";
            remainTextView.textColor = txtColors(194, 195, 196, 1);
        }
        else if (index == 104){
            UILabel *lab = subOrderHeadAry[btag-1];
            if ([billTextView.text isEqualToString:@"请填写发票台头名称"]) {
                lab.text = @"填写发票台头";
            }
            else{
                lab.text = billTextView.text;
                orderheadStr = billTextView.text;
                
            }
            billTextView.text = @"请填写发票台头名称";
            billTextView.textColor = txtColors(194, 195, 196, 1);
        }
        else if (index == 106){
            UITextField *nameFiled = newAddViewsAry[0];
            UITextField *telFiled = newAddViewsAry[1];
            UITextField *adresFiled = newAddViewsAry[2];
            UILabel *nameLabel = headViewsAry[0];
            UILabel *telLabel = headViewsAry[1];
            UILabel *adresLabel = headViewsAry[2];
            nameLabel.text = nameFiled.text;
            telLabel.text = telFiled.text;
            adresLabel.text = adresFiled.text;
        }
    }
    [self.view endEditing:YES];
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(void)isSetPas
{
    if ([zhifumima isEqualToString:@"1"]) {
        //未设置支付密码
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"还没有支付密码!请先设置一下吧";
        [bud showWhileExecuting:@selector(myTaskMore) onTarget:self withObject:nil animated:YES];
        [self performSelector:@selector(popPaswardView) withObject:self afterDelay:2.5];
    }
}
//支付密码
-(void)changePayPassword
{
    //短信验证码
    newPayPas = [[LoginPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    newPayPas.tag = 108;
    //    newPayPas.delegate = self;
    newPayPas.alpha = 0;
    
    //设置支付密码
    nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    nextPayPas.setPaymentDelegate = self;
    nextPayPas.alpha = 0;
    nextPayPas.tag = 109;
}

#pragma mark LoginPasswordViewDelegate
-(void)LoginPasswordViewSuccessWithIndex:(NSInteger)index;
{
    [UIView animateWithDuration:0.3 animations:^{
        popViewTag = 109;
        newPayPas.alpha = 0;
        [newPayPas removeFromSuperview];
        nextPayPas.alpha = 0.95;
        nextPayPas.isFrom = 2;
        NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
        [nextPayPas getTextFieldPlaceholderWithArray:array];
        [self.view addSubview:nextPayPas];
    }];
}

#pragma mark SetPaymentPasswordViewDelegate
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改密码成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            nextPayPas.alpha = 0;
            [nextPayPas removeFromSuperview];
        }];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改失败!请稍后再试";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
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
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
-(void)myTaskMore
{
    sleep(2.5);
}
//选择在线支付方式
-(void)morewayTapAction
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self.view addSubview:mask];
        popViewTag = 110;
        onlinePayWayPop.alpha = 0.95;
        [self.view addSubview:onlinePayWayPop];
    }];
}
-(void)sureOnlPay:(UITapGestureRecognizer *)tap
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell1 = [orderTableView cellForRowAtIndexPath:indexPath1];
    UILabel *lb1 = (UILabel *)[cell1 viewWithTag:1002];
    if (tap.view.tag == 101) {
        lb1.text = @"支付宝";
        isWx = 0;
    }
    else if (tap.view.tag == 102){
        lb1.text = @"微信支付";
        isWx = 1;
    }
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onlinePayWayPop.alpha = 0;
        [onlinePayWayPop removeFromSuperview];
    }];
}
//选择更多充值方法
-(void)morePayWay
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeText;
    mbHud.labelText = @"暂无更多的充值方式";
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

//支付遮罩事件
-(void)payMaksAction
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell1 = [orderTableView cellForRowAtIndexPath:indexPath1];
    UILabel *lb1 = (UILabel *)[cell1 viewWithTag:1003];
    lb1.alpha = 0 ;
    [UIView animateWithDuration:0.3 animations:^{
        payMask.alpha = 0;
        [payMask removeFromSuperview];
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
    UIImageView *lastImage = choosePayArray[lastChoosePay-1];
    lastImage.image = [UIImage imageNamed:@"选择"];
    UIImageView *newImage = choosePayArray[0];
    newImage.image = [UIImage imageNamed:@"选中"];
    lastChoosePay = 1;
}
#pragma mark --键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    PopView *pop = [self.view viewWithTag:popViewTag];
    NSDictionary *userInfo = [notifaction userInfo];
    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [userValue CGRectValue];
    CGRect fram = pop.frame;
    fram.origin.y = keyboardRect.origin.y-fram.size.height+20*MCscale;
    pop.frame = fram;
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{   PopView *pop = [self.view viewWithTag:popViewTag];
    CGRect fram = pop.frame;
    fram.origin.y = 120*MCscale;
    pop.frame = fram;
}

@end

