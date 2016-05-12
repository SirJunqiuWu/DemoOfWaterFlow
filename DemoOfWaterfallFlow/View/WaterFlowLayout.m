//
//  WaterFlowLayout.m
//  DemoOfWatterFlow
//
//  Created by JackWu on 16/3/7.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowModel : NSObject

/**
 *  列数
 */
@property (nonatomic , assign) NSInteger column;

/**
 *  高度
 */
@property (nonatomic , assign) CGFloat height;

+(instancetype)modelWithColumn:(NSInteger)column;

@end

@implementation WaterFlowModel

+(instancetype)modelWithColumn:(NSInteger)column
{
    WaterFlowModel *model = [[[self class]alloc]init];
    model.column = column;
    model.height = 0.0;
    return model;
}

@end

@interface WaterFlowLayout ()

@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,strong) NSDictionary *cellLayoutInfoDic;
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;
@property (nonatomic,strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;

@end

@implementation WaterFlowLayout

/**
 *  创建列的信息数组，内部是BGWaterFlowModel对象
 */
- (NSMutableArray *)columnInfoArray
{
    NSMutableArray *columnInfoArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.columnNum; i++)
    {
        WaterFlowModel *model = [WaterFlowModel modelWithColumn:i];
        [columnInfoArr addObject:model];
    }
    return columnInfoArr;
}

/**
 * 数组排序，由于每次只有第一个model的高度会发生变化，所以取出第一个model从后面往前面进行比较，直到找到比高度小于等于它的对象为止
 */
- (void)sortArrayByHeight:(NSMutableArray *)cellLayoutInfoArray{
    WaterFlowModel *firstModel = cellLayoutInfoArray.firstObject;
    //删除第一个对象
    [cellLayoutInfoArray removeObject:firstModel];
    
    //从后往前查找，查找到高度小于等于它的对象，则插入在这个对象之后
    NSInteger arrCount = cellLayoutInfoArray.count;
    NSInteger i = 0;
    for (i = arrCount - 1; i >= 0; i--)
    {
        WaterFlowModel *object = cellLayoutInfoArray[i];
        if(object.height <= firstModel.height)
        {
            [cellLayoutInfoArray insertObject:firstModel atIndex:i+1];
            break;
        }
    }
    
    //遍历完都没有找到，则插入在最前面
    if(i < 0)
    {
        [cellLayoutInfoArray insertObject:firstModel atIndex:0];
    }
}

#pragma mark - 重写父类方法

- (void)prepareLayout {
    [super prepareLayout];
    self.headerLayoutAttributes = nil;
    self.footerLayoutAttributes = nil;
    //计算宽度
    self.itemWidth = (self.collectionView.frame.size.width - (self.horizontalItemSpacing * (self.columnNum - 1)) - self.contentInset.left - self.contentInset.right) / self.columnNum;
    
    //头视图
    if(self.headerHeight > 0)
    {
        self.headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.headerLayoutAttributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.headerHeight);
    }
    
    NSMutableDictionary *cellLayoutInfoDic = [NSMutableDictionary dictionary];
    NSMutableArray *columnInfoArray = [self columnInfoArray];
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++)
        {
            //获取第一个model，以它的高作为y坐标
            WaterFlowModel *firstModel = columnInfoArray.firstObject;
            CGFloat y = firstModel.height;
            CGFloat x = self.contentInset.left + (self.horizontalItemSpacing + self.itemWidth) * firstModel.column;
            //获取item高度
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //获取item尺寸（实际）
            CGSize tpItemSize = [((id<WaterFlowLayoutDelegate>)self.collectionView.delegate) collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            //展示高度
            CGFloat itemHeight = [self getItemHeight:tpItemSize];
            //生成itemAttributes
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, y+self.contentInset.top+self.headerHeight, self.itemWidth, itemHeight);
            //保存新的列高，并进行排序
            firstModel.height += (itemHeight + self.verticalItemSpacing);
            [self sortArrayByHeight:columnInfoArray];
            
            //保存布局信息
            cellLayoutInfoDic[indexPath] = itemAttributes;
        }
    }
    
    //保存到全局
    self.cellLayoutInfoDic = [cellLayoutInfoDic copy];
    
    //内容尺寸
    WaterFlowModel *lastModel = columnInfoArray.lastObject;
    //尾部视图
    if(self.footerHeight > 0)
    {
        self.footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.footerLayoutAttributes.frame = CGRectMake(0, lastModel.height+self.headerHeight+self.contentInset.top+self.contentInset.bottom, self.collectionView.frame.size.width, self.footerHeight);
    }
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, lastModel.height+self.headerHeight+self.contentInset.top+self.contentInset.bottom+self.footerHeight);
}

/**
 *  获取item展示高度
 *
 *  @param itemSize item实际尺寸
 *
 *  @return item展示高度
 */
-(CGFloat)getItemHeight:(CGSize)itemSize
{
    CGFloat tpItemHeight = itemSize.height/itemSize.width*_itemWidth;
    return tpItemHeight;
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArrs = [NSMutableArray array];
    [self.cellLayoutInfoDic enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                                UICollectionViewLayoutAttributes *attributes,
                                                                BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame))
        {
            [attributesArrs addObject:attributes];
        }
    }];
    
    if (self.headerLayoutAttributes && CGRectIntersectsRect(rect, self.headerLayoutAttributes.frame))
    {
        [attributesArrs addObject:self.headerLayoutAttributes];
    }
    
    
    if (self.footerLayoutAttributes && CGRectIntersectsRect(rect, self.footerLayoutAttributes.frame))
    {
        [attributesArrs addObject:self.footerLayoutAttributes];
    }
    
    return attributesArrs;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    return attributes;
}

#pragma mark - Setter method

- (void)setHorizontalItemSpacing:(CGFloat)horizontalItemSpacing
{
    _horizontalItemSpacing = horizontalItemSpacing;
    [self invalidateLayout];
}

- (void)setVerticalItemSpacing:(CGFloat)verticalItemSpacing
{
    _verticalItemSpacing = verticalItemSpacing;
    [self invalidateLayout];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self invalidateLayout];
}

- (void)setColumnNum:(NSUInteger)columnNum
{
    _columnNum = columnNum;
    [self invalidateLayout];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    [self invalidateLayout];
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    [self invalidateLayout];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self invalidateLayout];
}


@end
