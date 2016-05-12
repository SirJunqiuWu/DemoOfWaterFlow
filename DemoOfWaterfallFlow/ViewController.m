//
//  ViewController.m
//  DemoOfWaterfallFlow
//
//  Created by 吴 吴 on 16/5/12.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "ViewController.h"
#import <UIView+Addition.h>
#import <NSDictionary+Addition.h>
#import "WaterFlowLayout.h"
#import "WaterCollectionViewCell.h"

/**
 *  屏幕宽度
 */
#define klScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 *  屏幕高度
 */
#define klScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *infoCollectionView;
    NSMutableArray   *dataArray;
}

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"瀑布流";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupUI];
    [self uploadDataReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc]init];
    flowLayout.columnNum = 2;
    flowLayout.horizontalItemSpacing = 6;
    flowLayout.verticalItemSpacing = 6;
    flowLayout.contentInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerHeight = 6.0;
    
    infoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,klScreenWidth,klScreenHeight) collectionViewLayout:flowLayout];
    infoCollectionView.backgroundColor = [UIColor clearColor];
    infoCollectionView.showsVerticalScrollIndicator = YES;
    infoCollectionView.alwaysBounceVertical = YES;
    infoCollectionView.delegate = self;
    infoCollectionView.dataSource = self;
    [infoCollectionView registerClass:[WaterCollectionViewCell class] forCellWithReuseIdentifier:@"WaterCollectionViewCell"];
    [self.view addSubview:infoCollectionView];
    
    /**
     *  Test openURL
     */
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
}

#pragma mark - 数据请求

- (void)uploadDataReq {
    dataArray = [NSMutableArray array];
    for (int i = 0; i <100; i ++) {
        int height = arc4random()%250;
        if (height<100)
        {
            height = 100;
        }
        NSDictionary *dic0 = @{@"image_width":@"150",
                               @"image_height":[NSString stringWithFormat:@"%i",height]};
        [dataArray addObject:dic0];
    }
    [infoCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"WaterCollectionViewCell";
    WaterCollectionViewCell *cell = (WaterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WaterCollectionViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tpDic = [dataArray objectAtIndex:indexPath.row];
    CGSize imageSize = [self getImageSize:tpDic];
    return imageSize;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [((WaterCollectionViewCell *)cell)initCellWithDic:dataArray[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"当前点击item索引 %ld",(long)indexPath.row);
}

- (CGSize)getImageSize:(NSDictionary *)dic {
    CGFloat tpWidth = [[dic getStringValueForKey:@"image_width"]floatValue];
    CGFloat tpHeight = [[dic getStringValueForKey:@"image_height"]floatValue];
    CGSize imageSize = CGSizeMake(tpWidth, tpHeight);
    return imageSize;
}


@end
