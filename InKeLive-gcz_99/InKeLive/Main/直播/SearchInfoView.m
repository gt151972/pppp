//
//  SearchInfoView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/23.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SearchInfoView.h"
#import <POP.h>

@interface SearchInfoView()
@property (weak, nonatomic) IBOutlet UIView *searchBg;

@end

@implementation SearchInfoView
static const NSTimeInterval kAnimalTime = 1.0f;

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (UIView *)searchBg{
    _searchBg.layer.masksToBounds = YES;
    _searchBg.layer.cornerRadius = 18.0;
    _searchBg.layer.borderWidth = 2;
    _searchBg.layer.borderColor = RGB(24, 24, 24).CGColor;
    return _searchBg;
}

- (IBAction)btnBackClicked:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)btnGoToNextViewClicked:(id)sender {
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleX];
    anSpring.springBounciness = 20;
    anSpring.toValue = @100;
    anSpring.velocity = @400;
    anSpring.springSpeed = 5.0;
    [_searchBg.layer pop_addAnimation:anSpring forKey:@"positionAnimation"];
}

- (void)popShow {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

}

-(void)hide {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
