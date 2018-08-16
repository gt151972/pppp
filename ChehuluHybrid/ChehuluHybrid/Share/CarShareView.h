//
//  CarShareView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/13.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@interface CarShareView : BaseView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionView *collectionViewFooter;

@property (nonatomic, strong)NSArray *arrayHead;
@property (nonatomic, strong)NSArray *arrayFooter;



/**
 状态分享

 @param arrayHead 上collect数据
 @param arrayfooter 下collect数据
 @param date 日期
 @param superView 父视图
 */
- (void)initViewStatuesWithArrayHead: (NSArray *)arrayHead arrayFooter: (NSArray *)arrayfooter date: (NSString *)date surperView: (UIView *)superView;


@end
