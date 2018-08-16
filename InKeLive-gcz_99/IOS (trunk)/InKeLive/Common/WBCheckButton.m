//
//  WBCheckButton.m
//  InKeLive
//
//  Created by gu  on 17/9/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "WBCheckButton.h"

@interface WBCheckButton()
{
    WBCheckButtonStyle _style;
    BOOL _checked;
    NSString* _checkname;
    NSString* _uncheckname;
}
@end

@implementation WBCheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self =[super initWithFrame:frame])
    {
        _checked = NO;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        [self addSubview:_icon];
         [self setStyle:WBCheckButtonStyleDefault];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width + 10, 0, frame.size.width- _icon.frame.size.width -20, frame.size.height)];
        _label.backgroundColor =[UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = RGBA(255, 255, 255, 1.0);
        _label.textAlignment = UITextAlignmentLeft;
        [self addSubview:_label];
        
        [self addTarget : self action : @selector ( clicked:) forControlEvents :UIControlEventTouchUpInside ];
    }
    return self;
}

-(WBCheckButtonStyle)style
{
    return _style;
    
}

-(void)setStyle:(WBCheckButtonStyle)style
{
    _style = style;
    switch (_style) {
        case WBCheckButtonStyleDefault:
        case WBCheckButtonStyleBox:
            _checkname = @"checked.png";
            _uncheckname = @"unchecked.png";
            break;
        case WBCheckButtonStyleRadio:
            _checkname = @"radio.png";
            _uncheckname = @"unradio.png";
            break;
        default:
            break;
    }
    [self setChecked :_checked];
    
}

-(BOOL)isChecked:(id)sender
{
    return _checked;
}

-(void)setChecked:(BOOL)bcheck
{
    if(_checked != bcheck) {
        _checked = bcheck;
    }
    
    if(_checked)
        [self.icon setImage:[UIImage imageNamed:_checkname]];
    else
        [self.icon setImage:[UIImage imageNamed:_uncheckname]];
    
}

-(void)clicked:(id)sender
{
    if (_delegate!=nil)
    {
        //如果使用了RadioGroup，需要实现特殊逻辑比如单选s
        SEL sel=NSSelectorFromString(@"checkButtonClicked:");
        if([_delegate respondsToSelector:sel]){
            [_delegate performSelector:sel withObject:self];
        }
        
    }else {
        [self setChecked:!_checked];
    }
}




@end
