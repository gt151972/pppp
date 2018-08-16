//
//  CarStatuesShareView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/5/16.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@interface CarStatuesShareView : BaseView<UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labDate;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
