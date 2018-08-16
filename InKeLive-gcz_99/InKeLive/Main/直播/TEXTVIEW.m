//
//  TEXTVIEW.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "TEXTVIEW.h"

@implementation TEXTVIEW

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)popShow {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    //    [self initData];
    //    [self.HeadTableView reloadData];
    //    [self.chatTableView reloadData];
}

-(void)hide {
    [self removeFromSuperview];
}
@end
