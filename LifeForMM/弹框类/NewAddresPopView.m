//
//  NewAddresPopView.m
//  LifeForMM
//
//  Created by HUI on 16/3/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "NewAddresPopView.h"
@implementation NewAddresPopView
{
    NSMutableDictionary *locationDic;//存放坐标地址
    BOOL isLocat;//是否定位过
    NSString *address;
    BMKGeoCodeSearch *_codeSearch;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        address = @"";
        isLocat = 1;
        locationDic = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAddressNews) name:@"newAddressPop" object:nil];
        [self initSubViews];
        [self initSearch];
    }
    return self;
}
-(void)initSubViews
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.tag = 101;
    label.text = @"联系人:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:MLwordFont_2];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    _receiver = [[UITextField alloc]initWithFrame:CGRectZero];
    _receiver.tag = 102;
    _receiver.textColor = [UIColor blackColor];
    _receiver.textAlignment= NSTextAlignmentLeft;
    _receiver.font = [UIFont systemFontOfSize:MLwordFont_2];
    _receiver.placeholder = @"请填写收货人姓名";
    _receiver.delegate = self;
    _receiver.backgroundColor = [UIColor clearColor];
    [self addSubview:_receiver];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectZero];
    line1.tag = 103;
    line1.backgroundColor= lineColor;
    [self addSubview:line1];
    
    UIView *menView = [[UIView alloc]initWithFrame:CGRectZero];//先生
    menView.backgroundColor = [UIColor clearColor];
    menView.tag = 104;
    [self addSubview:menView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSexAction:)];
    [menView addGestureRecognizer:tap1];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectZero];
    image1.backgroundColor = [UIColor clearColor];
    image1.userInteractionEnabled = YES;
    image1.tag = 1001;
    image1.image = [UIImage imageNamed:@"选择"];
    [menView addSubview:image1];
    
    UILabel *sexLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
    sexLabel1.textAlignment = NSTextAlignmentLeft;
    sexLabel1.tag = 1002;
    sexLabel1.text = @"先生";
    sexLabel1.textColor = [UIColor blackColor];
    sexLabel1.backgroundColor = [UIColor clearColor];
    sexLabel1.font = [UIFont systemFontOfSize:MLwordFont_2];
    sexLabel1.userInteractionEnabled = YES;
    [menView addSubview:sexLabel1];
    
    UIView *womanView = [[UIView alloc]initWithFrame:CGRectZero];//女士
    womanView.backgroundColor = [UIColor clearColor];
    womanView.tag = 105;
    [self addSubview:womanView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSexAction:)];
    [womanView addGestureRecognizer:tap2];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectZero];
    image2.backgroundColor = [UIColor clearColor];
    image2.userInteractionEnabled = YES;
    image2.tag = 1003;
    image2.image = [UIImage imageNamed:@"选中"];
    [womanView addSubview:image2];
    
    UILabel *sexLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
    sexLabel2.textAlignment = NSTextAlignmentLeft;
    sexLabel2.text = @"女士";
    sexLabel2.tag = 1004;
    sexLabel2.textColor = [UIColor blackColor];
    sexLabel2.backgroundColor = [UIColor clearColor];
    sexLabel2.font = [UIFont systemFontOfSize:MLwordFont_2];
    sexLabel2.userInteractionEnabled = YES;
    [womanView addSubview:sexLabel2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectZero];
    line2.tag = 106;
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    numLabel.text = @"手机号码:";
    numLabel.tag = 107;
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = [UIColor blackColor];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self addSubview:numLabel];
    
    
    _receiVerTel = [[UITextField alloc]initWithFrame:CGRectZero];
    _receiVerTel.tag = 108;
    _receiVerTel.delegate = self;
    NSString *telString = [NSString stringWithFormat:@"%@",userName_tel];
    NSString *sbId = [NSString stringWithFormat:@"%@",userSheBei_id];
    NSString *usId = [NSString stringWithFormat:@"%@",user_id];
    
    NSInteger isLogn = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLogin"];
    if(![sbId isEqualToString:usId] && isLogn == 1){
        _receiVerTel.placeholder =telString;
    }
    else
        _receiVerTel.placeholder =@"请填写手机号";
    _receiVerTel.keyboardType = UIKeyboardTypeNumberPad;
    _receiVerTel.textAlignment = NSTextAlignmentLeft;
    _receiVerTel.textColor = [UIColor blackColor];
    _receiVerTel.backgroundColor = [UIColor clearColor];
    _receiVerTel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self addSubview:_receiVerTel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectZero];
    line3.tag = 109;
    line3.backgroundColor = lineColor;
    [self addSubview:line3];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    label2.tag = 110;
    label2.text = @"收货地址:";
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:MLwordFont_2];
    label2.backgroundColor = [UIColor clearColor];
    [self addSubview:label2];
    
    _addresTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _addresTextView.tag = 111;
    _addresTextView.delegate = self;
    _addresTextView.textAlignment = NSTextAlignmentLeft;
    _addresTextView.textColor = txtColors(194, 195, 196, 1);
    
    if (userLastAddress) {
        address = userLastAddress;
    }
    else
    {
        address = @"例:北京市朝阳区**小区";
    }
    _addresTextView.text = address;
    _addresTextView.font = [UIFont systemFontOfSize:MLwordFont_4];
    _addresTextView.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
    _addresTextView.tag = 10003;
    [self addSubview:_addresTextView];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectZero];
    line4.tag = 112;
    line4.backgroundColor = lineColor;
    [self addSubview:line4];
    
    UILabel *menpaiLab = [[UILabel alloc]initWithFrame:CGRectZero];
    menpaiLab.tag = 113;
    menpaiLab.text = @"楼-门牌号:";
    menpaiLab.textAlignment = NSTextAlignmentLeft;
    menpaiLab.textColor = [UIColor blackColor];
    menpaiLab.font = [UIFont systemFontOfSize:MLwordFont_4];
    menpaiLab.backgroundColor = [UIColor clearColor];
    [self addSubview:menpaiLab];
    
    _houseNum = [[UITextField alloc]initWithFrame:CGRectZero];
    _houseNum.tag = 114;
    _houseNum.delegate = self;
    _houseNum.placeholder = @"例如:12号楼1201室";
    _houseNum.tag = 10004;
    _houseNum.textAlignment = NSTextAlignmentLeft;
    _houseNum.font = [UIFont systemFontOfSize:MLwordFont_2];
    _houseNum.textColor = [UIColor blackColor];
    _houseNum.backgroundColor = [UIColor clearColor];
    [self addSubview:_houseNum];
    _isWoman = 1;
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.tag = 115;
    popBtn.backgroundColor = redTextColor;
    [popBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    popBtn.layer.cornerRadius = 3.0;
    popBtn.layer.masksToBounds = YES;
    popBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [popBtn setTitle:@"保存" forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(saveAddressNews) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:popBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UILabel *label = (UILabel *)[self viewWithTag:101]; // 联系人
    label.frame = CGRectMake(20*MCscale, 30*MCscale, 70*MCscale, 20*MCscale);
    //收货人
    _receiver.frame = CGRectMake(label.right+5, label.top, 180, 20*MCscale);
    
    UIView *line1 = [self viewWithTag:103];
    line1.frame = CGRectMake(label.right, _receiver.bottom+5, self.width-40-label.width, 1);
    //先生
    UIView *menView = [self viewWithTag:104];
    menView.frame = CGRectMake(label.right, line1.bottom+7*MCscale, 68*MCscale, 30*MCscale);
    UIImageView *image1 = (UIImageView *)[menView viewWithTag:1001];
    image1.frame = CGRectMake(0, 4*MCscale, 22*MCscale, 22*MCscale);
    UILabel *sexLabel1 = (UILabel *)[menView viewWithTag:1002];
    sexLabel1.frame = CGRectMake(image1.right+5, image1.top,60*MCscale, 20*MCscale);
    //女士
    UIView *womanView = [self viewWithTag:105];
    womanView.frame = CGRectMake(label.right+100*MCscale, line1.bottom+7*MCscale, 68*MCscale, 30*MCscale);
    UIImageView *image2 = (UIImageView *)[womanView viewWithTag:1003];
    image2.frame = CGRectMake(0, 4*MCscale, 22*MCscale, 22*MCscale);
    UILabel *sexLabel2 = (UILabel *)[womanView viewWithTag:1004];
    sexLabel2.frame = CGRectMake(image2.right+5, image2.top,60*MCscale, 20*MCscale);
    
    UIView *line2 = [self viewWithTag:106];
    line2.frame = CGRectMake(5*MCscale, line1.bottom+52*MCscale, self.width-10, 1);
    //收货人电话
    UILabel *numLabel = (UILabel *)[self viewWithTag:107];
    numLabel.frame = CGRectMake(20*MCscale, line2.bottom+15, 90*MCscale_1, 20*MCscale);
    _receiVerTel.frame = CGRectMake(numLabel.right+5*MCscale, numLabel.top, 180*MCscale, 20*MCscale);
    UIView *line3 = [self viewWithTag:109];
    line3.frame = CGRectMake(5, numLabel.bottom+15*MCscale, self.width-10*MCscale, 1);
    //收货地址
    UILabel *label2 = (UILabel *)[self viewWithTag:110];
    label2.frame = CGRectMake(20*MCscale, line3.bottom+15*MCscale, 90*MCscale_1, 20*MCscale);
    
    _addresTextView.frame = CGRectMake(label2.right+5*MCscale, label2.top, 210*MCscale, 50*MCscale);
    UIView *line4 = [self viewWithTag:112];
    line4.frame = CGRectMake(5, _addresTextView.bottom, self.width-10, 1);
    //门牌号
    UILabel *menpaiLab = (UILabel *)[self viewWithTag:113];
    menpaiLab.frame = CGRectMake(20*MCscale, line4.bottom+10, 100*MCscale_1, 20*MCscale);
    
    _houseNum.frame = CGRectMake(menpaiLab.right, line4.bottom+10, 210*MCscale, 20*MCscale);
    //保存按钮
    UIButton *btn = (UIButton *)[self viewWithTag:115];
    btn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    btn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}

-(void)searchTipsWithKey:(NSString *)key
{
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

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"%@  %f  %f",result.address,result.location.longitude,result.location.latitude);
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSString *latitu = [NSString stringWithFormat:@"%lf",result.location.latitude];
        NSString *longitu = [NSString stringWithFormat:@"%lf",result.location.longitude];
        [locationDic setValue:latitu forKey:@"address.y"]; //纬度
        [locationDic setValue:longitu forKey:@"address.x"]; //经度
        if (!isLocat) {
            [self newAdresSureAction];
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


//初始化search
-(void)initSearch
{
    _codeSearch =[[BMKGeoCodeSearch alloc]init];
    _codeSearch.delegate = self;
}
-(void)saveAddressNews
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"请确认已开启定位服务";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        if (locationDic.count == 0) {
            isLocat = 0;
            [self searchTipsWithKey:self.addresTextView.text];
        }
        else{
            isLocat = 1;
            [self newAdresSureAction];
        }
        [self endEditing:YES];
    }
}
//使用新址确定
-(void)newAdresSureAction
{
    MBProgressHUD *adresBub = [MBProgressHUD showHUDAddedTo:self animated:YES];
    adresBub.mode = MBProgressHUDModeIndeterminate;
    adresBub.delegate = self;
    adresBub.labelText = @"请稍等...";
    [adresBub show:YES];
    NSString *weidu = [locationDic valueForKey:@"address.y"];
    NSString *jingdu = [locationDic valueForKey:@"address.x"];
    
    NSString *menpaihao = self.houseNum.text ? self.houseNum.text :0;
    NSString *userTelStr,*userTrueTelStr;
    NSInteger isLogn = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLogin"];
    
    if ([self.receiVerTel.text isEqualToString:@""] && isLogn==1) {
        userTelStr = [NSString stringWithFormat:@"%@",userName_tel];
    }
    else
    {
        userTelStr = self.receiVerTel.text;
    }
    if (userTelStr.length != 11)
    {
        [adresBub hide:YES];
        MBProgressHUD *mbud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mbud.mode = MBProgressHUDModeText;
        mbud.labelText = @"请输入正确的手机号";
        [mbud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else if (userTelStr.length == 11)
    {
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[7,5])|(17[0,3,6,7,8]))\\d{8}$";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        BOOL isMatch = [phoneTest evaluateWithObject:userTelStr];
        if(isMatch){
            userTrueTelStr = userTelStr;
            if ([_receiver.text isEqualToString:@""]||[self.addresTextView.text isEqualToString:@"例:北京市朝阳区**小区"]) {
                [locationDic removeAllObjects];
                
                [adresBub hide:YES];
                MBProgressHUD *mbud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                mbud.mode = MBProgressHUDModeText;
                mbud.labelText = @"请完善信息后再试";
                [mbud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else{
                NSString *sex = @"女士";
                if (self.isWoman == 0) {
                    sex = @"男士";
                }
                
                if ([self.addresTextView.text isEqualToString:[NSString stringWithFormat:@"%@",userLastAddress]])
                {
                    jingdu = [NSString stringWithFormat:@"%@",userLongitude];
                    weidu = [NSString stringWithFormat:@"%@",userLatitude];
                }
                
                NSString *usName = [NSString stringWithFormat:@"%@(%@)",self.receiver.text,sex];
                NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":userShequ_id,@"address.tel":user_id,@"address.x":jingdu,@"address.y":weidu, @"address.name":usName,@"address.haoma":userTrueTelStr,@"address.address":self.addresTextView.text,@"address.menpai":menpaihao}];
                [HTTPTool postWithUrl:@"saveAddress.action" params:pram success:^(id json) {
                    [locationDic removeAllObjects];
                    [adresBub hide:YES];
                    if ([[json valueForKey:@"message"]integerValue]==2) {
                        if ([self.addresPopdelegate respondsToSelector:@selector(newAddressView:Andvalue:)]) {
                            [self.addresPopdelegate newAddressView:self Andvalue:[[json valueForKey:@"message"]integerValue]];
                        }
                    }
                    else if ([[json valueForKey:@"message"]integerValue]==3) {
                        if ([self.addresPopdelegate respondsToSelector:@selector(newAddressView:Andvalue:)]) {
                            [self.addresPopdelegate newAddressView:self Andvalue:[[json valueForKey:@"message"]integerValue]];
                        }
                    }
                    else if ([[json valueForKey:@"message"]integerValue]==4) {
                        if ([self.addresPopdelegate respondsToSelector:@selector(newAddressView:Andvalue:)]) {
                            [self.addresPopdelegate newAddressView:self Andvalue:[[json valueForKey:@"message"]integerValue]];
                        }
                    }
                    else{
                        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self animated:YES];
                        hub.mode = MBProgressHUDModeText;
                        hub.labelText = @"地址超出配送范围!请重新填写";
                        [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }
                } failure:^(NSError *error) {
                    [adresBub hide:YES];
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"网络连接错误";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }];
            }
        }
        else
        {
            [adresBub hide:YES];
            MBProgressHUD *mbud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            mbud.mode = MBProgressHUDModeText;
            mbud.labelText = @"请输入正确的手机号";
            [mbud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    }
}
- (void)myTask {
    sleep(1.5);
}

-(void)chooseSexAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 104) {
        UIView *manView = [self viewWithTag:104];
        UIImageView *image1 = (UIImageView *)[manView viewWithTag:1001];
        image1.image = [UIImage imageNamed:@"选中"];
        UIView *womanView = [self viewWithTag:105];
        UIImageView *image2 = (UIImageView *)[womanView viewWithTag:1003];
        image2.image = [UIImage imageNamed:@"选择"];
        _isWoman = 0;
    }
    else{
        UIView *manView = [self viewWithTag:104];
        UIImageView *image1 = (UIImageView *)[manView viewWithTag:1001];
        image1.image = [UIImage imageNamed:@"选择"];
        UIView *womanView = [self viewWithTag:105];
        UIImageView *image2 = (UIImageView *)[womanView viewWithTag:1003];
        image2.image = [UIImage imageNamed:@"选中"];
        _isWoman = 1;
    }
}


#pragma mark -- UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0) {
        return YES;
    }
    NSInteger exitLength = textField.text.length;
    NSInteger selectLength = range.length;
    NSInteger replaceLength = string.length;
    if (exitLength - selectLength +replaceLength>11) {
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _receiver) {
        if ([textField.text isEqualToString:@""]|| [user_id isEqualToString:userSheBei_id]) {
            textField.placeholder = @"请填写收货人的姓名";
        }
    }
    else if (textField == _receiVerTel)
    {
        if ([textField.text isEqualToString:@""] && ![user_id isEqualToString:userSheBei_id]) {
            textField.placeholder = [NSString stringWithFormat:@"%@",userName_tel];
        }
        else
            textField.placeholder = @"请填写手机号";
    }
    else
    {
        if ([textField.text isEqualToString:@""]||[user_id isEqualToString:userSheBei_id]) {
            textField.placeholder = @"例如:12号楼1201室";
        }
    }
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:address]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@""]) {
        textView.text = address;
        textView.textColor = txtColors(194, 195, 196, 1);
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_receiver resignFirstResponder];
    [_receiVerTel resignFirstResponder];
    [_addresTextView resignFirstResponder];
    [_houseNum resignFirstResponder];
}

@end
