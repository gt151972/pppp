//
//  PresentViewCell.m
//  PresentDemo
//
//  Created by 阮思平 on 16/10/2.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import "PresentViewCell.h"

#define Duration 0.1

@interface PresentViewCell ()

@property (weak, nonatomic) PresentLable *shakeLable;
/**
 *  记录礼物连乘数
 */
@property (assign, nonatomic) NSInteger number;
/**
 *  记录cell最初始的frame(即开始展示动画前的frame)
 */
@property (assign, nonatomic) CGRect originalFrame;
/**
 *  shake动画的缓存数组
 */
@property (strong, nonatomic) NSMutableArray *caches;
/**
 shake动画模型的缓存数组
 */
@property (strong, nonatomic) NSMutableArray *modelCaches;

@end

@implementation PresentViewCell

#pragma mark - Setter/Getter

- (NSMutableArray *)caches
{
    if (!_caches) {
        _caches = [NSMutableArray array];
    }
    return _caches;
}

- (NSMutableArray *)modelCaches
{
    if (!_modelCaches) {
        _modelCaches = [NSMutableArray array];
    }
    return _modelCaches;
}

#pragma mark - Initial

- (instancetype)initWithRow:(NSInteger)row
{
    if (self = [super init]) {
        _row              = row;
        _state            = AnimationStateNone;
        self.nowNO = 0;
    }
    return self;
}

#pragma mark - Private

/**
 *  添加连乘lable
 */
- (void)addShakeLable
{
    PresentLable *lable   = [[PresentLable alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.borderColor     = MAIN_COLOR;
    lable.textColor       = RGB(255, 98, 0);
    lable.font            = [UIFont systemFontOfSize:23.0];
    lable.textAlignment   = NSTextAlignmentLeft;
    lable.alpha           = 0.0;
    CGFloat w             = 160;
    CGFloat h             = CGRectGetHeight(self.frame);
    CGFloat x             = CGRectGetWidth(self.frame);
    CGFloat y             = 0;
    lable.frame           = CGRectMake(x, y, w, h);
    self.shakeLable       = lable;
    [self addSubview:lable];
}

/**
 *  开始连乘动画(利用递归实现连乘动画)
 *
 *  @param number 连乘次数
 *  @param block  当前number次连乘动画执行完成回调
 */
- (void)startShakeAnimationWithNumber:(NSInteger)number completion:(void (^)(BOOL finished))block
{
    self.superview.userInteractionEnabled = YES;
    _state                 = AnimationStateShaking;
    self.shakeLable.text   = [NSString stringWithFormat:@"   %ld", ++self.number];
    __weak typeof(self) ws = self;
    [self.shakeLable startAnimationDuration:Duration completion:^(BOOL finish) {
        if (number > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws startShakeAnimationWithNumber:(number - 1) completion:block];
            });
        }else {
            _state = AnimationStateShaked;
            if (block) {
                block(YES);
            }
        }
    }];
}

#pragma mark - Public

- (void)showAnimationWithModel:(id<PresentModelAble>)model showShakeAnimation:(BOOL)flag prepare:(void (^)(void))prepare completion:(void (^)(BOOL))completion
{
    _state             = AnimationStateShowing;
    _baseModel         = model;
    _sender            = [model sender];
    _giftName          = [model giftName];
    self.originalFrame = self.frame;
    self.number        = 0;
    if (prepare) {
        prepare();
    }
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self customDisplayAnimationOfShowShakeAnimation:flag];
    } completion:^(BOOL finished) {
        if (flag) {
            if (!self.shakeLable) {
                [self addShakeLable];
            }
            self.shakeLable.alpha = 1.0;
        }
        if (completion) {
            completion(flag);
        }
    }];
}

- (void)shakeAnimationWithNumber:(NSInteger)number
{
    NSLog(@"number == %ld",(long)number);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenAnimationOfShowShake:) object:@(YES)];
    [self performSelector:@selector(hiddenAnimationOfShowShake:) withObject:@(YES) afterDelay:self.showTime];
    if (number > 0) [self.caches addObject:@(number)];
    if (self.caches.count > 0 && _state != AnimationStateShaking) {
        NSInteger cache        = [self.caches.firstObject integerValue];
        [self.caches removeObjectAtIndex:0];//不能删除对象，因为可能有相同的对象
        __weak typeof(self) ws = self;//
        [self startShakeAnimationWithNumber:cache completion:^(BOOL finished) {
            [ws shakeAnimationWithNumber:-1];//传-1是为了缓存不被重复添加
            _nowNO = 0;
        }];
    }
}

- (void)shakeAnimationWithModels:(NSArray<id<PresentModelAble>> *)models
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenAnimationOfShowShake:) object:@(YES)];
    [self performSelector:@selector(hiddenAnimationOfShowShake:) withObject:@(YES) afterDelay:self.showTime];
    if (models.count > 0) [self.modelCaches addObjectsFromArray:models];
    if (self.modelCaches.count > 0 && _state != AnimationStateShaking) {
        _state = AnimationStateShaking;
        id<PresentModelAble> obj = self.modelCaches.firstObject;
        self.nowNO = (int)[obj giftNumber]+_nowNO;
        self.shakeLable.text = [NSString stringWithFormat:@"    %d", _nowNO];
        [self.modelCaches removeObjectAtIndex:0];
        __weak typeof(self) ws = self;
        //
        [self.shakeLable startAnimationDuration:Duration completion:^(BOOL finish) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _state = AnimationStateShaked;
                if (ws.modelCaches.count > 0) {
                    [ws shakeAnimationWithModels:nil];
                }
            });
        }];
        //
        _state = AnimationStateShaked;
        if (ws.modelCaches.count > 0) {
            [ws shakeAnimationWithModels:nil];
        }
    }
}

- (void)hiddenAnimationOfShowShake:(BOOL)flag
{
    self.superview.userInteractionEnabled = NO;
    _state = AnimationStateHiding;
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self customHideAnimationOfShowShakeAnimation:flag];
    } completion:^(BOOL finished) {
        
        //恢复cell的初始状态
        self.frame            = self.originalFrame;
        _state                = AnimationStateNone;
        self.shakeLable.alpha = 0.0;
        [self.caches removeAllObjects];
        [self.modelCaches removeAllObjects];
        _nowNO = 0;
        //通知代理
        if ([self.delegate respondsToSelector:@selector(presentViewCell:showShakeAnimation:shakeNumber:)]) {
            [self.delegate presentViewCell:self showShakeAnimation:flag shakeNumber:self.number];
            
        }
    }];
}

//目前还没有使用
- (void)releaseVariable
{
    //    [self.shakeLable removeFromSuperview];
}

@end

@implementation PresentViewCell (OverWrite)

- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag
{
    self.alpha     = 1.0;
    CGRect selfF   = self.frame;
    selfF.origin.x = 0;
    self.frame     = selfF;
}

- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag
{
    self.alpha     = 0.0;
    CGRect selfF   = self.frame;
    selfF.origin.y -= (CGRectGetHeight(selfF) * 0.5);
    self.frame     = selfF;
}

@end

@implementation PresentLable

- (void)drawTextInRect:(CGRect)rect
{
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
}

- (void)startAnimationDuration:(NSTimeInterval)interval completion:(void (^)(BOOL finish))completion
{
//    if (!kIs_iPhone5S) {
        [UIView animateKeyframesWithDuration:interval delay:0 options:0 animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
                self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
                //            self.transform = CGAffineTransformMakeScale(3, 3);
            }];
            [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1.0 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
                self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
                //            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            
        }];
//    }
}

@end

