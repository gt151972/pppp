//
//  WBRadioGroup.m
//  InKeLive
//
//  Created by gu  on 17/9/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "WBRadioGroup.h"

@interface WBRadioGroup()
{
    NSMutableArray* _children;
}

@end

@implementation WBRadioGroup

-(instancetype)init {
    if(self =[super init]) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(void) add:(WBCheckButton*) button
{
    button.delegate = self;
    [_children addObject:button];
}

-(void) checkButtonClicked: (id) sender
{
    WBCheckButton* button = (WBCheckButton *)sender;
    for(WBCheckButton *each in _children) {
        [each setChecked:NO];
    }
    [button setChecked:YES];
}


@end
