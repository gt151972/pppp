//
//  FlyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/4.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "FlyView.h"

@interface FlyView()
@property (nonatomic ,strong)UILabel *aUILabel;
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
    _aUILabel=[[UILabel alloc]initWithFrame:CGRectMake(0,2, 500, 50)];
    _aUILabel.font = [UIFont systemFontOfSize:12];
    _aUILabel.layer.masksToBounds = YES;
    NSString *strInfo= [NSString stringWithFormat:@"%@送给%@%d个%@",_strSrcName,_strToName,_giftNum,_strGiftName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strInfo];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, _strSrcName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strSrcName.length, 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(_strSrcName.length + 2, _strToName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(_strToName.length+_strSrcName.length+2, attrStr.length - (_strToName.length+_strSrcName.length+2))];
    [_aUILabel setAttributedText:attrStr];
    [_aUILabel sizeToFit];
    [self addSubview:_aUILabel];
    //取消所有的动画
    

    [self function];
//    [self gcdTimer];
    
}
- (void)gcdTimer
{
    //0 获取一个全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //1. 定义一个定时器
    /**
     第一个参数:说明定时器的类型
     第四个参数:GCD的回调任务添加到那个队列中执行，如果是主队列则在主线程执行     */
    dispatch_source_t  timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //这里创建的 timer, 是一个局部变量,由于 Block 回调定时器,因此,必须保证 timer 被强引用;    self.timer = timer;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);    /**     *
                                                                                        <#dispatch_source_t source#>:给哪个定时器设置时间
                                                                                        <#dispatch_time_t start#>:定时器立即启动的开始时间
                                                                                        <#uint64_t interval#>:定时器开始之后的间隔时间
                                                                                        <#uint64_t leeway#>:定时器间隔时间的精准度,传入0代表最精准,尽量让定时器精准,注意: dispatch 的定时器接收的时间是 纳秒
                                                                                        */
    uint64_t interval = 4.0 * NSEC_PER_SEC;
    //2设置定时器的相关参数:开始时间,间隔时间,精准度等
    dispatch_source_set_timer( timer, startTime, interval, 0 * NSEC_PER_SEC);
    //3.设置定时器的回调方法
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"%@",[NSThread currentThread]);
        [self function];
    });
    //4.开启定时器
    dispatch_resume(timer);
}

- (void)function{
    //    [self.aUILabel.layer removeAllAnimations];
    //计算实际text大小
    CGSize  textSize =  [_aUILabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    //保存label的frame
    CGRect lframe =_aUILabel.frame;
    //用计算出来的text的width更改frame的原始width
    lframe.size.width= textSize.width;//从屏幕最右边向左边移
    lframe.origin.x= self.bounds.size.width;; //用新值更改label的原frame值
    _aUILabel.frame = lframe;
    //计算动画x移动的最大偏移：屏幕width+text的width
    _aUILabel.clipsToBounds = YES;
    float offset = self.width +lframe.size.width;
    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionRepeat//动画重复的主开关
     |UIViewAnimationOptionCurveLinear//动画的时间曲
                     animations:^{
                         //                        aUILabel.transform = CGAffineTransformRotate(-offset, 0);
                         _aUILabel.transform=CGAffineTransformMakeTranslation(-offset,0);
                     } completion:^(BOOL finished) {
                     }
     ];
}

@end
