//
//  FlyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/4.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "FlyView.h"
#import "DKScrollTextLable.h"

@interface FlyView()
@property (nonatomic ,strong)DKScrollTextLable *aUILabel;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,assign)int fromLocation;//字符串截取的开始位置

@end

@implementation FlyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.2); //背景透明
        self.layer.cornerRadius = 9;
        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor redColor];
//        [self creatUI];
    }
    return self;
}

- (void)creatUI{
//    // 添加 横向 跑马灯
//    [self addHorizontalMarquee];
//    // 开启跑马灯
//    [self.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    
}
-(void)paomadeng{
//    DKScrollTextLable *lab = [[DKScrollTextLable alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH*3/4, 12)];
//    lab.text = @"1234";
//    [self addSubview:lab];
    _aUILabel = [[DKScrollTextLable alloc]initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH*3/4, 12)];
    _aUILabel.font = [UIFont systemFontOfSize:12];
//    _titleString= [NSString stringWithFormat:@"%@送给%@%d个%@      %@送给%@%d个%@      %@送给%@%d个%@ ",_strSrcName,_strToName,_giftNum,_strGiftName,_strSrcName,_strToName,_giftNum,_strGiftName,_strSrcName,_strToName,_giftNum,_strGiftName];
    _titleString= [NSString stringWithFormat:@"%@送给%@%d个%@ ",_strSrcName,_strToName,_giftNum,_strGiftName];
    _aUILabel.text = _titleString;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_titleString];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, _strSrcName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strSrcName.length, 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(_strSrcName.length + 2, _strToName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strToName.length+_strSrcName.length+2, attrStr.length - (_strToName.length+_strSrcName.length+2))];
    _aUILabel.attrStr = attrStr;
    [self addSubview:_aUILabel];
}

- (void)test{
    CGRect frame = _aUILabel.frame;
    
    frame.origin.x =1000;
    
    _aUILabel.frame = frame;
    
    [UIView beginAnimations:@"testAnimation"context:NULL];
    
    [UIView setAnimationDuration:10.0f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationRepeatAutoreverses:NO];
    
    [UIView setAnimationRepeatCount:115];
    
    frame = _aUILabel.frame;
    
    frame.origin.x =-350;
    
    _aUILabel.frame = frame;
    
    [UIView commitAnimations];
}

- (void)function{
    CGSize  textSize =  [_aUILabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    //保存label的frame
    CGRect lframe =_aUILabel.frame;
    //用计算出来的text的width更改frame的原始width
    lframe.size.width= textSize.width;//从屏幕最右边向左边移
    lframe.origin.x= self.bounds.size.width;; //用新值更改label的原frame值
    _aUILabel.frame = lframe;
    //计算动画x移动的最大偏移：屏幕width+text的width
    _aUILabel.clipsToBounds = YES;
    CGRect rect = [_titleString boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                             context:nil];
    CGFloat width = rect.size.width;
    float offset = rect.size.width +lframe.size.width;
    
//    [UIView animateWithDuration:offset/5 delay:offset/10 options:UIViewAnimationOptionCurveLinear animations:^{
//        NSLog(@"运行1");
//        _aUILabel.transform=CGAffineTransformMakeTranslation(-offset,0);
//    } completion:^(BOOL finished) {
//        if (finished) {
////            [self function];
//        }
//    }];

    [UIView animateWithDuration:offset/5 delay:0 options:UIViewAnimationOptionCurveLinear//动画的时间曲
                     animations:^{
                         NSLog(@"运行2");
                         _aUILabel.transform=CGAffineTransformMakeTranslation(-offset,0);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _aUILabel.transform = CGAffineTransformIdentity;
                             [self function];
                         }
                     }
     ];
}

@end
