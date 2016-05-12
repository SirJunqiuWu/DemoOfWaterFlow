//
//  WaterCollectionViewCell.h
//  DemoOfWaterfallFlow
//
//  Created by 吴 吴 on 16/5/12.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterCollectionViewCell : UICollectionViewCell
{
    /**
     *  数据源
     */
    NSDictionary *dataDic;
}

- (void)initCellWithDic:(NSDictionary *)dic;

@end
