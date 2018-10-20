//
//  MessageCell.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "MessageCell.h"
#import "UILabel+WidthAndHeight.h"

@implementation MessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //取消单元格选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addAtrribuedLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAtrribuedLabel];
    }
    return self;
}
- (void)setModel:(MessageModel *)model{
    _model = model;
    self.label.textContainer = model.textContainer;
    [self.label setFrameWithOrign:CGPointMake(5, 5) Width:CGRectGetWidth(self.frame)];
}
- (void)addLable:(MessageModel *)model{
    TYAttributedLabel *label2 = [[TYAttributedLabel alloc]init];
    label2.isWidthToFit = YES;
    label2.backgroundColor = RGBA(0, 0, 0, 0.15);
    label2.textContainer = model.textContainer;
    [label2 setFrameWithOrign:CGPointMake(5, 10) Width:CGRectGetWidth(self.frame)];
     _label = label2;
    NSLog(@"height == %f",label2.height);
    [self.contentView addSubview:_label];
}

- (CGFloat)height: (MessageModel *)model{
    TYAttributedLabel *label2 = [[TYAttributedLabel alloc]init];
    label2.isWidthToFit = YES;
    label2.backgroundColor = RGBA(0, 0, 0, 0.15);
    label2.textContainer = model.textContainer;
    [label2 setFrameWithOrign:CGPointMake(5, 10) Width:CGRectGetWidth(self.frame)];
    return label2.height+5;
}

- (void)addAtrribuedLabel
{
    //Label?
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    
//    CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:[UIFont systemFontOfSize:14]];
//    NSLog(@"height == %f",height);
//    label.frame = CGRectMake(10, 30, SCREEN_WIDTH - 118, height);
//    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 118, 9999);//labelsize的最大值
//    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
//    label.frame = CGRectMake(8, 10, expectSize.width, expectSize.height);
//    label.backgroundColor = RGBA(0, 0, 0, 0.15);
//    label.layer.cornerRadius = 12;
//    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor redColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setFrameWithOrign:CGPointMake(5, 5) Width:CGRectGetWidth(self.frame)];
    [self.contentView addSubview:label];
    _label = label;
//    label.frame = CGRectMake(5, 3, CGRectGetWidth(self.frame), 15);
    NSArray *verticalContrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[label]-3-|" options:0 metrics:nil views:@{@"label":_label}];
//    NSArray *horizontalCOntraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[label]-5-|" options:0 metrics:nil views:@{@"label":_label}];
    //不同版本使用不一样?
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts];
//        [NSLayoutConstraint activateConstraints:horizontalCOntraints];
    } else {
        [self.contentView addConstraints:verticalContrainsts];
//        [self.contentView addConstraints:horizontalCOntraints];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
