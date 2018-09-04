//
//  FlyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/4.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "FlyView.h"
#import <JhtMarquee/JhtHorizontalMarquee.h>

@interface FlyView(){
    JhtHorizontalMarquee *_horizontalMarquee;
    // 是否暂停了纵向 跑马灯
    BOOL _isPauseV;
}
@end

@implementation FlyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = RGBA(0, 0, 0, 0.2); //背景透明
        self.backgroundColor = [UIColor redColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    // 添加 横向 跑马灯
    [self addHorizontalMarquee];
    // 开启跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    
}

#pragma mark 横向 跑马灯
/** 添加 横向 跑马灯 */
- (void)addHorizontalMarquee {
    self.horizontalMarquee.text = @" 这是一个跑马灯View，测试一下好不好用，哈哈哈，😁👌😀 😁👌😀 😁👌😀 😁👌😀 哈哈哈哈！ ";
    [self addSubview:self.horizontalMarquee];
}

#pragma mark - Get
/** 横向 跑马灯 */
- (JhtHorizontalMarquee *)horizontalMarquee {
    if (!_horizontalMarquee) {
        _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 18) withSingleScrollDuration:10.0];
        
        _horizontalMarquee.tag = 100;
        // 添加点击手势
//        UITapGestureRecognizer *htap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marqueeTapGes:)];
//        [_horizontalMarquee addGestureRecognizer:htap];
    }
    
    return _horizontalMarquee;
}

#pragma mark Get Method
/** 点击 滚动跑马灯 触发方法 */
- (void)marqueeTapGes:(UITapGestureRecognizer *)ges {
    if (ges.view.tag == 100) {
        NSLog(@"点击__水平__滚动的跑马灯啦！！！");
        
    }
}



@end
