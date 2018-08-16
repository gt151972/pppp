//
//  WeekCell.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekCell : UICollectionViewCell

+(UINib *)nib;

@property (weak, nonatomic) UILabel *weekDay;
@property (nonatomic, strong) NSString *strToday;


- (void)setBackgroundView:(UIView *)backgroundView;
@end
