//
//  MessageFrame.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "MessageFrame.h"
#import "Message.h"
#import "NSString+Extension.h"

@implementation MessageFrame
- (void)setModel:(Message *)model{
    _model = model;
    
    CGFloat cellMargin    = 10; //边缘间距
    CGFloat topViewH      = 10;
    CGFloat headToView = 3; //边距
    CGFloat bubblePadding = 10;
    CGFloat chatLabelMax  = SCREEN_WIDTH-42-51-3; //cell最大宽度
    CGFloat cellMinW      = 60;     // cell的最小宽度值,针对文本
    
    CGSize timeSize  = CGSizeMake(0, 0);
    if (model.isMine) {
        cellMinW = timeSize.width + bubblePadding*2;
        CGSize chateLabelSize = [model.message sizeWithMaxWidth:chatLabelMax andFont:MessageFont];
        CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2, chateLabelSize.height + bubblePadding * 2);
        CGSize topViewSize = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
        _bubbleViewF = CGRectMake(SCREEN_WIDTH - bubbleSize.width, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
        CGFloat x = CGRectGetMinX(_bubbleViewF)+bubblePadding;
        _topViewF = CGRectMake(SCREEN_WIDTH - topViewSize.width-5, cellMargin,topViewSize.width,topViewSize.height);
        _chatLabelF = CGRectMake(x, topViewH + cellMargin + bubblePadding, chateLabelSize.width, chateLabelSize.height);
    }else{
        CGSize chateLabelSize = [model.message sizeWithMaxWidth:chatLabelMax andFont:MessageFont];
        CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
        CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2 , chateLabelSize.height + bubblePadding * 2);
        
        _bubbleViewF  = CGRectMake(bubbleSize.width, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
        CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding ;
        _topViewF     = CGRectMake(CGRectGetMinX(_bubbleViewF), cellMargin, topViewSize.width, topViewSize.height);
        _chatLabelF   = CGRectMake(x, cellMargin + bubblePadding + topViewH, chateLabelSize.width, chateLabelSize.height);
    }
    _cellHight = MAX(CGRectGetMaxY(_bubbleViewF), 200) + cellMargin;
//    CGSize size= [model.message sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-40 andFont:[UIFont systemFontOfSize:11.0]];
//    _cellHight = size.height+10;
}

@end
