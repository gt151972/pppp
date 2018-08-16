//
//  CarMistakeAnimation.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/29.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@interface CarMistakeAnimation : BaseView{
    NSTimer *timer;
    UIView *view;
    UIImageView *imageCar;
    UIImageView *imageScanDown;
    UIImageView *imageScanUp;
}

- (void) initViewWithSuperView: (UIView *)superView;
- (void) secondInitViewWithSuperView: (UIView *)superView;
- (void)MouseMove;
@end
