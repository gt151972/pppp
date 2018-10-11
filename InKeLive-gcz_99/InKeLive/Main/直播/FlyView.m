//
//  FlyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/4.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "FlyView.h"

@interface FlyView()
@end

@implementation FlyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.2); //背景透明
        self.layer.cornerRadius = 9;
        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor redColor];
        [self creatUI];
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
    UILabel *aUILabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 500, 50)];
    aUILabel.font = [UIFont systemFontOfSize:15];
    aUILabel.layer.masksToBounds = YES;
    NSString *strInfo= [NSString stringWithFormat:@"%@送给%@%d个%@",_strSrcName,_strToName,_giftNum,_strGiftName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strInfo];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, _strSrcName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strSrcName.length, 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(_strSrcName.length + 2, _strToName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strToName.length+_strSrcName.length+2, attrStr.length - (_strToName.length+_strSrcName.length+2))];
    [aUILabel setAttributedText:attrStr];
    [aUILabel sizeToFit];
    [self addSubview:aUILabel];
    //取消所有的动画
    
//    [self.aUILabel.layer removeAllAnimations];
    //计算实际text大小
    CGSize  textSize =  [aUILabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    //保存label的frame
    CGRect lframe =aUILabel.frame;
    //用计算出来的text的width更改frame的原始width
    lframe.size.width= textSize.width;//从屏幕最右边向左边移
    lframe.origin.x= self.bounds.size.width;; //用新值更改label的原frame值
    aUILabel.frame = lframe;
    //计算动画x移动的最大偏移：屏幕width+text的width
    aUILabel.clipsToBounds = YES;
    float offset = textSize.width+ SCREEN_WIDTH;
    [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionRepeat//动画重复的主开关
     |UIViewAnimationOptionCurveLinear//动画的时间曲
                    animations:^{aUILabel.transform=CGAffineTransformMakeTranslation(-offset,0);} completion:^(BOOL finished) {
                    }
     ];
}

@end
