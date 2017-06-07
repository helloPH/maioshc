//
//  SecuritySetself.m
//  LifeForMM
//
//  Created by MIAO on 16/8/5.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SecuritySetCell.h"
#import "Header.h"
#import "safeSetingModel.h"
@implementation SecuritySetCell
{
    NSIndexPath *indexPath;
    BOOL isshebei;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self SubViews];
    }
    return self;
}

-(void)SubViews
{
    UILabel *title = [[UILabel alloc]init];
    title.tag = 201;
    title.textAlignment = NSTextAlignmentLeft;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = txtColors(113, 114, 115, 1);
    title.font = [UIFont systemFontOfSize:MLwordFont_3];
    [self addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.tag = 202;
    subTitle.textColor = txtColors(113, 114, 115, 0.9);
    subTitle.textAlignment = NSTextAlignmentRight;
    subTitle.backgroundColor = [UIColor clearColor];
    subTitle.font = [UIFont systemFontOfSize:MLwordFont_12];
    [self addSubview:subTitle];
    
    UILabel *usePhoneLabel = [[UILabel alloc]init];
    usePhoneLabel.tag = 204;
    usePhoneLabel.textColor = lineColor;
    usePhoneLabel.textAlignment = NSTextAlignmentLeft;
    usePhoneLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    usePhoneLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:usePhoneLabel];
    UIImageView *arrowImage = [[UIImageView alloc]init];
    arrowImage.tag = 203;
    arrowImage.image = [UIImage imageNamed:@"下拉键"];
    arrowImage.backgroundColor = [UIColor clearColor];
    [self addSubview:arrowImage];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    if (isshebei == 1) {
        if (indexPath.row <5 ) {
            line .frame = CGRectMake(10*MCscale, self.height+15*MCscale, kDeviceWidth - 20*MCscale, 1);
        }
        else if (indexPath.row == 5)
        {
            line .frame = CGRectMake(10*MCscale, self.height+15*MCscale, kDeviceWidth - 20*MCscale, 0.5);
        }
        else if (indexPath.row  == 7)
        {
            line.frame = CGRectMake(10*MCscale, self.height, kDeviceWidth - 20*MCscale, 1);
        }
        else
        {
            line.frame = CGRectMake(10*MCscale, self.height, kDeviceWidth - 20*MCscale, 0.5);
        }
    }
    else
    {
        if (indexPath.row <4 ) {
            line .frame = CGRectMake(10*MCscale, self.height+15*MCscale, kDeviceWidth - 20*MCscale, 1);
        }
        else if (indexPath.row == 4)
        {
            line .frame = CGRectMake(10*MCscale, self.height+15*MCscale, kDeviceWidth - 20*MCscale, 0.5);
        }
        else if (indexPath.row  == 6)
        {
            line.frame = CGRectMake(10*MCscale, self.height, kDeviceWidth - 20*MCscale, 1);
        }
        else
        {
            line.frame = CGRectMake(10*MCscale, self.height, kDeviceWidth - 20*MCscale, 0.5);
        }
    }
}


-(void)loadDataWithIndexPath:(NSIndexPath *)indexpath AndIsSheBei:(BOOL)isSheBei AndsetingArray:(NSMutableArray *)setingDataAry AndphoneArray:(NSMutableArray *)phoneLbaelAry AndsafeDataArray:(NSMutableArray *)safeData AndemailArray:(NSMutableArray *)emailLabelAry AndisRenZhen:(BOOL)isrenzhen
{
    indexPath = indexpath;
    isshebei = isSheBei;
    
    if (isshebei == 1) {
        NSArray *titleArray = @[@"已绑定手机号",@"登陆密码",@"支付密码",@"绑定邮箱",@"更换绑定设备"];
        NSArray *rzArray = @[@"未认证",@"认证"];
        if(indexPath.row <5){
            UILabel *label = (UILabel *)[self viewWithTag:201];
            CGSize lbsize = [titleArray[indexPath.row] boundingRectWithSize:CGSizeMake(130*MCscale, 40*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_3],NSFontAttributeName, nil] context:nil].size;
            label.frame = CGRectMake(20*MCscale, 10*MCscale, lbsize.width, 40*MCscale);
            label.text = titleArray[indexPath.row];
            UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
            arrowImage.frame = CGRectMake(kDeviceWidth-25*MCscale, 20*MCscale, 15*MCscale, 20*MCscale);
            UILabel *subLabel = (UILabel *)[self viewWithTag:202];
            if(setingDataAry.count > 0){
                subLabel.text = setingDataAry[indexPath.row];
            }
            subLabel.frame = CGRectMake(kDeviceWidth-70*MCscale, 15*MCscale, 40*MCscale, 30*MCscale);
            if (indexPath.row == 0) {
                UILabel *usePhoneLabel = (UILabel *)[self viewWithTag:204];
                usePhoneLabel.frame = CGRectMake(label.right+5*MCscale, label.top+13*MCscale, 105*MCscale, 20*MCscale);
                NSString *ttel;
                if(![userName_tel isEqualToString:userSheBei_id]){
                    ttel = [userName_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                }
                usePhoneLabel.textColor = lineColor;
                usePhoneLabel.text = ttel;
                if (phoneLbaelAry.count == 0) {
                    [phoneLbaelAry addObject:usePhoneLabel];
                }
            }
            if(indexPath.row == 3){
                if (safeData.count >0) {
                    safeSetingModel *modl = safeData[0];
                    NSString *emails;
                    if ([modl.emailnum integerValue]!=1) {
                        emails =[NSString stringWithFormat:@"%@",modl.emailnum];
                        NSString *eml;
                        NSRange rang = [emails rangeOfString:@"@"];
                        NSInteger length = rang.location;
                        UILabel *useEmailLabel = (UILabel *)[self viewWithTag:204];
                        useEmailLabel.frame = CGRectMake(label.right+5*MCscale, label.top+13*MCscale, 145*MCscale, 20*MCscale);
                        eml = [emails stringByReplacingCharactersInRange:NSMakeRange(3, length-3) withString:@"*****"];
                        useEmailLabel.textColor = lineColor;
                        useEmailLabel.text = eml;
                        if (emailLabelAry.count == 0) {
                            [emailLabelAry addObject:useEmailLabel];
                        }
                    }
                }
            }
        }
        else if (indexPath.row == 5){
            UIImageView *rzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 15*MCscale, 28*MCscale, 28*MCscale)];\
            rzImageView.tag = 10010;
            rzImageView.image = [UIImage imageNamed:rzArray[isrenzhen]];
            [self addSubview:rzImageView];
            UILabel *label = (UILabel *)[self viewWithTag:201];
            label.frame = CGRectMake(rzImageView.right+8*MCscale, 10*MCscale, 150*MCscale, 40*MCscale);
            label.text = @"实名认证";
            UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
            arrowImage.frame = CGRectMake(kDeviceWidth-25*MCscale, 20*MCscale, 15*MCscale, 20*MCscale);
            UILabel *subLabel = (UILabel *)[self viewWithTag:202];
            if (!isrenzhen) {
                subLabel.text = @"完善信息加密帐号安全";
            }
            else
            {
                subLabel.text = @"";
                UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
                [arrowImage removeFromSuperview];
                
            }
            subLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
            subLabel.frame = CGRectMake(kDeviceWidth-200*MCscale, 15*MCscale, 170*MCscale, 30*MCscale);
        }
        else if (indexPath.row ==6){
            if (isrenzhen){
                safeSetingModel *modl = safeData[0];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(57*MCscale, 20*MCscale, 40*MCscale, 30*MCscale)];
                title.textAlignment = NSTextAlignmentLeft;
                title.text = @"姓名:";
                title.textColor = txtColors(113, 114, 115, 1);
                title.font = [UIFont systemFontOfSize:MLwordFont_6];
                title.backgroundColor = [UIColor clearColor];
                [self addSubview:title];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.right+5*MCscale, 20*MCscale, 50*MCscale, 30*MCscale)];
                if (![modl.realname isEqualToString:@""]) {
                    nameLabel.text = [modl.realname stringByReplacingCharactersInRange:NSMakeRange(1, [modl.realname length]-1) withString:@"**"];
                }
                nameLabel.textColor = txtColors(113, 114, 115, 1);
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
                nameLabel.backgroundColor = [UIColor clearColor];
                [self addSubview:nameLabel];
            }
        }
        else{
            if (isrenzhen) {
                safeSetingModel *modl = safeData[0];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(57*MCscale, 20*MCscale, 70*MCscale, 30*MCscale)];
                title.textAlignment = NSTextAlignmentLeft;
                title.text = @"身份证号:";
                title.textColor = txtColors(113, 114, 115, 1);
                title.font = [UIFont systemFontOfSize:MLwordFont_6];
                title.backgroundColor = [UIColor clearColor];
                [self addSubview:title];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.right+5, 20*MCscale, 150*MCscale, 30*MCscale)];
                if (![modl.shenfenzhenghao isEqualToString:@"0"]) {
                    nameLabel.text = [modl.shenfenzhenghao stringByReplacingCharactersInRange:NSMakeRange(4, 12) withString:@"************"];
                }
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.textColor = txtColors(113, 114, 115, 1);
                nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
                nameLabel.backgroundColor = [UIColor clearColor];
                [self addSubview:nameLabel];
            }
        }
    }
    else
    {
        NSArray *titleArray = @[@"已绑定手机号",@"登陆密码",@"支付密码",@"绑定邮箱"];
        NSArray *rzArray = @[@"未认证",@"认证"];
        if(indexPath.row <4){
            UILabel *label = (UILabel *)[self viewWithTag:201];
            CGSize lbsize = [titleArray[indexPath.row] boundingRectWithSize:CGSizeMake(130*MCscale, 40*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_3],NSFontAttributeName, nil] context:nil].size;
            label.frame = CGRectMake(20*MCscale, 10*MCscale, lbsize.width, 40*MCscale);
            label.text = titleArray[indexPath.row];
            UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
            arrowImage.frame = CGRectMake(kDeviceWidth-25*MCscale, 20*MCscale, 15*MCscale, 20*MCscale);
            UILabel *subLabel = (UILabel *)[self viewWithTag:202];
            if(setingDataAry.count > 0){
                subLabel.text = setingDataAry[indexPath.row];
            }
            subLabel.frame = CGRectMake(kDeviceWidth-70*MCscale, 15*MCscale, 40*MCscale, 30*MCscale);
            if (indexPath.row == 0) {
                UILabel *usePhoneLabel = (UILabel *)[self viewWithTag:204];
                usePhoneLabel.frame = CGRectMake(label.right+5*MCscale, label.top+13*MCscale, 105*MCscale, 20*MCscale);
                NSString *ttel;
                if(![userName_tel isEqualToString:userSheBei_id]){
                    ttel = [userName_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                }
                usePhoneLabel.textColor = lineColor;
                usePhoneLabel.text = ttel;
                if (phoneLbaelAry.count == 0) {
                    [phoneLbaelAry addObject:usePhoneLabel];
                }
            }
            if(indexPath.row == 3){
                if (safeData.count >0) {
                    safeSetingModel *modl = safeData[0];
                    NSString *emails;
                    if ([modl.emailnum integerValue]!=1) {
                        emails =[NSString stringWithFormat:@"%@",modl.emailnum];
                        NSString *eml;
                        NSRange rang = [emails rangeOfString:@"@"];
                        NSInteger length = rang.location;
                        UILabel *useEmailLabel = (UILabel *)[self viewWithTag:204];
                        useEmailLabel.frame = CGRectMake(label.right+5*MCscale, label.top+13*MCscale, 145*MCscale, 20*MCscale);
                        eml = [emails stringByReplacingCharactersInRange:NSMakeRange(3, length-3) withString:@"*****"];
                        useEmailLabel.textColor = lineColor;
                        useEmailLabel.text = eml;
                        if (emailLabelAry.count == 0) {
                            [emailLabelAry addObject:useEmailLabel];
                        }
                    }
                }
            }
        }
        else if (indexPath.row == 4){
            UIImageView *rzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 15*MCscale, 28*MCscale, 28*MCscale)];
            rzImageView.tag = 10010;
            rzImageView.image = [UIImage imageNamed:rzArray[isrenzhen]];
            [self addSubview:rzImageView];
            UILabel *label = (UILabel *)[self viewWithTag:201];
            label.frame = CGRectMake(rzImageView.right+8*MCscale, 10*MCscale, 150*MCscale, 40*MCscale);
            label.text = @"实名认证";
            UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
            arrowImage.frame = CGRectMake(kDeviceWidth-25*MCscale, 20*MCscale, 15*MCscale, 20*MCscale);
            UILabel *subLabel = (UILabel *)[self viewWithTag:202];
            if (!isrenzhen) {
                subLabel.text = @"完善信息加密帐号安全";
            }
            else
            {
                subLabel.text = @"";
                UIImageView *arrowImage = (UIImageView *)[self viewWithTag:203];
                [arrowImage removeFromSuperview];
                
            }
            subLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
            subLabel.frame = CGRectMake(kDeviceWidth-200*MCscale, 15*MCscale, 170*MCscale, 30*MCscale);
        }
        else if (indexPath.row ==5){
            if (isrenzhen){
                safeSetingModel *modl = safeData[0];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(57*MCscale,20*MCscale, 40*MCscale, 30*MCscale)];
                title.tag = 10011;
                title.textAlignment = NSTextAlignmentLeft;
                title.text = @"姓名:";
                title.textColor = txtColors(113, 114, 115, 1);
                title.font = [UIFont systemFontOfSize:MLwordFont_6];
                title.backgroundColor = [UIColor clearColor];
                [self addSubview:title];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.right+5*MCscale, 20*MCscale, 50*MCscale, 30*MCscale)];
                nameLabel.tag = 10012;
                if (![modl.realname isEqualToString:@""]) {
                    nameLabel.text = [modl.realname stringByReplacingCharactersInRange:NSMakeRange(1, [modl.realname length]-1) withString:@"**"];
                }
                nameLabel.textColor = txtColors(113, 114, 115, 1);
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
                nameLabel.backgroundColor = [UIColor clearColor];
                [self addSubview:nameLabel];
            }
        }
        else{
            if (isrenzhen) {
                safeSetingModel *modl = safeData[0];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(57*MCscale,20*MCscale, 70*MCscale, 30*MCscale)];
                title.textAlignment = NSTextAlignmentLeft;
                title.text = @"身份证号:";
                title.textColor = txtColors(113, 114, 115, 1);
                title.font = [UIFont systemFontOfSize:MLwordFont_6];
                title.backgroundColor = [UIColor clearColor];
                [self addSubview:title];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.right+5, 20*MCscale, 150*MCscale, 30*MCscale)];
                if (![modl.shenfenzhenghao isEqualToString:@"0"]) {
                    nameLabel.text = [modl.shenfenzhenghao stringByReplacingCharactersInRange:NSMakeRange(4, 12) withString:@"************"];
                }
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.textColor = txtColors(113, 114, 115, 1);
                nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
                nameLabel.backgroundColor = [UIColor clearColor];
                [self addSubview:nameLabel];
            }
        }
}
}

-(void)prepareForReuse
{
    UIImageView *rzImageView = [self viewWithTag:10010];
    rzImageView.image = nil;
    
    UILabel *title = [self viewWithTag:10011];
    title.frame = CGRectZero;
    
    UILabel *nameLabel = [self viewWithTag:10011];
    nameLabel.frame = CGRectZero;
    
}

@end
