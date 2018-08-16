//
//  WeekDataSource.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CollectionViewCellConfigureBlock)(id cell, id item);

@interface WeekDataSource : NSObject<UICollectionViewDataSource>

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAthdexPath: (NSIndexPath *)indexPath;

@end
