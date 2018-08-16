//
//  RoomMembersView.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "RoomMembersView.h"

@implementation RoomMembersView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self =[super initWithFrame:frame style:style];
    if(self) {
        [self _initViews:frame];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self _initViews:self.frame];
}

-(void)_initViews:(CGRect)frame {
    //1.逆时针旋转90度
    self.transform =CGAffineTransformMakeRotation(-M_PI_2);
    //2.旋转之后宽高互换了，所以重新设置frame
    self.frame=frame;
    //3.隐藏滚动条
    self.showsVerticalScrollIndicator =NO;
    //4.背景设置为透明
    self.backgroundColor =[UIColor clearColor];
    //5.隐藏分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}


@end
