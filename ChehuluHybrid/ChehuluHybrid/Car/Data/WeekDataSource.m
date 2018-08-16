//
//  WeekDataSource.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "WeekDataSource.h"

@interface WeekDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifler;
@property (nonatomic, copy) CollectionViewCellConfigureBlock conflgureBlock;

@end

@implementation WeekDataSource

- (id)init{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifler = aCellIdentifier;
        self.conflgureBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

#pragma  mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifler forIndexPath:indexPath];
    id item = [self itemAthdexPath:indexPath];
    self.conflgureBlock(cell, item);
    return cell;
}

@end
