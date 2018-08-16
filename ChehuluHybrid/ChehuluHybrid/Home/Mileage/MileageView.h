//
//  MileageView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/24.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

//@interface MileageView : BaseView
@protocol  HomeMileageViewDelegate<NSObject>

@required
- (void)homeMileageTypeArray:(NSArray *)array name:(NSString*)name;

@end

@interface MileageView : BaseView{
    NSDictionary *dicSource;
    int mileage;
}

@property (nonatomic, assign) id<HomeMileageViewDelegate>delegate;
@property (nonatomic, strong) CAShapeLayer *trackLayer;//背景
@property (nonatomic, strong) CAShapeLayer *progressLayer;//填充
@property (nonatomic, strong) CAGradientLayer *gradientLayer;//渐变
@property (nonatomic, strong) UIBezierPath *pathBg;//背景路径
@property (nonatomic, strong) UIBezierPath *path;//路径


@property (nonatomic, strong) CAShapeLayer *pointLayer;//白点
@property (nonatomic, strong) CAShapeLayer *shadowLayer;//阴影色环
@property (nonatomic, assign) UIColor *trackColor;
@property (nonatomic, assign) UIColor *progressColor;
@property (nonatomic, assign) UIColor *pointColor;
@property (nonatomic, assign) CGFloat lineWidth;//环宽度
@property (nonatomic, assign) CGFloat pointRedius;//点半径
@property (nonatomic, strong) UIBezierPath *pointPath;//点路径
@property (nonatomic, strong) UIBezierPath *shadowPath;//阴影路径
@property (nonatomic, assign) CGFloat percent; //饼状图显示的百分比，最大为100
@property (nonatomic, assign) CGFloat animationDuration;//动画持续时长
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, assign) CGFloat pathWidth;//环半径
@property (nonatomic, assign) CGFloat sumSteps;
@property (nonatomic, strong) UILabel *progressLabel;
- (void)showViewWithView:(UIView *)view dic:(NSDictionary *)dic;
@end
