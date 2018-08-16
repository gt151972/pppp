//
//  CarAnimation.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/20.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>

@interface CarAnimation : UIView{
    UIColor *color;
}
@property (nonatomic, retain) UIView *car;
@property (nonatomic, retain) UIImageView *environment;
@property (nonatomic, retain) UIImageView *bgMountain;
- (void)showLoadingAnimation:(UIView *)sup color:(UIColor *)color;
@end
