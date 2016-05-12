//
//  WaterCollectionViewCell.m
//  DemoOfWaterfallFlow
//
//  Created by 吴 吴 on 16/5/12.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "WaterCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIView+Addition.h>

@implementation WaterCollectionViewCell
{
    UIImageView *icon;
    UILabel *nameLbl;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    icon = [[UIImageView alloc]init];
    icon.backgroundColor = [UIColor clearColor];
    icon.userInteractionEnabled = YES;
    [self.contentView addSubview:icon];
    
    nameLbl = [[UILabel alloc]init];
    nameLbl.backgroundColor = [UIColor blackColor];
    nameLbl.alpha = 0.6;
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.font = [UIFont systemFontOfSize:14];
    nameLbl.textAlignment = NSTextAlignmentJustified;
    [icon addSubview:nameLbl];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGes:)];
    longPressGes.minimumPressDuration = 0.5;
    [icon addGestureRecognizer:longPressGes];
}

#pragma mark - 数据源

- (void)initCellWithDic:(NSDictionary *)dic {
    dataDic = [NSDictionary dictionaryWithDictionary:dic];
    [icon sd_setImageWithURL:[NSURL URLWithString:@"https://gw.alicdn.com/bao/uploaded/TB1uZDjJFXXXXbVXFXXSutbFXXX.jpg"] placeholderImage:nil];
    
    nameLbl.text = @"夏季新款";
}

#pragma mark - 点击事件

- (void)longPressGes:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CATransform3D tpTransform3D = CATransform3DIdentity;
            tpTransform3D = CATransform3DScale(tpTransform3D, 0.9, 0.9, 1);
            icon.layer.transform = tpTransform3D;
        } completion:^(BOOL finished) {
            CATransform3D tpTransform3D = CATransform3DIdentity;
            tpTransform3D = CATransform3DScale(tpTransform3D, 0.9, 0.9, 1);
            icon.layer.transform = tpTransform3D;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            CATransform3D tpTransform3D = CATransform3DIdentity;
            tpTransform3D = CATransform3DScale(tpTransform3D, 1, 1, 1);
            icon.layer.transform = tpTransform3D;
        } completion:^(BOOL finished) {
            CATransform3D tpTransform3D = CATransform3DIdentity;
            tpTransform3D = CATransform3DScale(tpTransform3D, 1, 1, 1);
            icon.layer.transform = tpTransform3D;
        }];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    icon.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    nameLbl.frame = CGRectMake(0, icon.height-30, icon.width,30);
}

@end
