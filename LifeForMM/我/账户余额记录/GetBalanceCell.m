//
//  GetBalanceCell.m
//  LifeForMM
//
//  Created by MIAO on 16/5/31.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GetBalanceCell.h"
#import "Header.h"
@implementation GetBalanceCell

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
    self.bindingTypeLabel = [[UILabel alloc]init];
    self.bindingTypeLabel.textColor = textColors;
    self.bindingTypeLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    self.bindingTypeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.bindingTypeLabel];
    
    self.accountNumberLabel = [[UILabel alloc]init];
    self.accountNumberLabel.textAlignment= NSTextAlignmentLeft;
    self.accountNumberLabel.textColor = lineColor;
    self.accountNumberLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.contentView addSubview:self.accountNumberLabel];
    
    self.selectedBtn = [[UIButton alloc]init];
    [self.selectedBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.selectedBtn];
    
    self.changeBtn = [[UIButton alloc]init];
    [self.changeBtn setTitle:@"更换" forState:UIControlStateNormal];
    [self.changeBtn setImage:[UIImage imageNamed:@"下拉键"] forState:UIControlStateNormal];
    [self.changeBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 50, 5, 3)];
    [self.changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-40, 0, 0)];
    [self.changeBtn.titleLabel setFont:[UIFont systemFontOfSize:MLwordFont_2]];
    [self.changeBtn setTitleColor:lineColor forState:UIControlStateNormal];
    [self.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.changeBtn];
}

-(void)loadDataForCellWithModel:(BindAccountModel *)model
{
    self.selectedBtn.selected = YES;
    //不可点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bindingTypeLabel.text = model.name;
    if (model.zhanghao.length == 11) {
        self.accountNumberLabel.text = [model.zhanghao stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"****"];
    }
    else
    {
        NSString *eml;
        NSRange rang = [model.zhanghao rangeOfString:@"@"];
        NSInteger length = rang.location;
        eml = [model.zhanghao stringByReplacingCharactersInRange:NSMakeRange(3, length-3) withString:@"****"];
        self.accountNumberLabel.text = eml;
    }
}

-(void)changeBtnClick:(UIButton *)button
{
    if (button == self.changeBtn) {
        if ([self.balanceDelegate respondsToSelector:@selector(changeAccountForBalance)]) {
            [self.balanceDelegate changeAccountForBalance];
        }
    }
    else
    {
        button.selected = !button.selected;
        if ([self.balanceDelegate respondsToSelector:@selector(changeSeletedForButton:)]) {
            [self.balanceDelegate changeSeletedForButton:button];
        }
    }
    
}

-(void)layoutSubviews
{
//self.bindingTypeLabel
    [self.bindingTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //左
        make.left.equalTo(self.mas_left).offset(10*MCscale);
        //居中
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //self.accountNumberLabel
    [self.accountNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //居中
        make.centerY.equalTo(self.bindingTypeLabel.mas_centerY);
        //居中
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //self.selectedBtn
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //左
        make.right.equalTo(self.changeBtn.mas_left).offset(10*MCscale);
        //居中
        make.centerY.equalTo(self.accountNumberLabel.mas_centerY);
        
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    
    //self.changeBtn
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //左
        make.right.equalTo(self.mas_right).offset(5*MCscale);
        //居中
        make.centerY.equalTo(self.selectedBtn.mas_centerY);
    }];
    
}

@end
