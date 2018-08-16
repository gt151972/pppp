//
//  ShareAlertSheet.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/5/11.
//  Copyright © 2017年 GT mac. All rights reserved.
//
#define NUMBER 2
#define ANIMATE_DURATION             0.25f
#import "ShareAlertSheet.h"

@implementation ShareAlertSheet
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Public set

- (void)initView{
    //        indexDal=[[IndexRequestDAL alloc]init];
    //        indexDal.delegate=self;
    //初始化背景视图，添加手势
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, gtHEIGHT);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.userInteractionEnabled = YES;
    
    UIButton *btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    [btnBg setBackgroundColor:[UIColor clearColor]];
    [btnBg addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBg];
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 144)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.backGroundView.layer setShadowColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    NSArray *arrayImage = [NSArray arrayWithObjects:@"shareFriend", @"shareCircle", nil];
    for (int index = 0; index < NUMBER; index ++ ) {
        UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(index * (gtWIDTH/NUMBER), 0, gtWIDTH/NUMBER, 144)];
        [btnShare setImage:[UIImage imageNamed:[arrayImage objectAtIndex:index]] forState:UIControlStateNormal];
        [btnShare setTag:200+index];
        [btnShare addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:btnShare];
    }
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
         [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 144, [UIScreen mainScreen].bounds.size.width, 144)];
        
    } completion:^(BOOL finished) {
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    //[self addGestureRecognizer:tapGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.backGroundView)
    {
        return NO;
    }
    return YES;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

#pragma mark -- Clicked
- (void)btnClicked: (UIButton *)button{
    if (button.tag == 200) {
        //分享到微信
        
    }else if (button.tag == 201){
        //分享到朋友圈
        
    }
}

#pragma mark - actions

- (void)tappedCancel
{
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tappedChoose
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChoseIndex:name:)])
    {
//        [self.delegate didChoseIndex:<#(int)#> name:<#(NSString *)#>];
    }
    
    [self tappedCancel];
}


@end
