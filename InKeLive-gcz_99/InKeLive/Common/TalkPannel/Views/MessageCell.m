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
    self.label.verticalAlignment = TYVerticalAlignmentCenter;
   // self.label.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1];;
}

- (void)addAtrribuedLabel
{
    //Label?
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
//    label.backgroundColor = RGBA(0, 0, 0, 0.15);
//    label.layer.cornerRadius = 12;
//    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label sizeToFit];
    CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:label.font];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, height)];
    viewBg.backgroundColor = RGBA(0, 0, 0, 0.15);
    viewBg.layer.cornerRadius = 12;
    viewBg.layer.masksToBounds = YES;
    [self.contentView addSubview:viewBg];
    [self.contentView addSubview:label];
    
    _label = label;
    _viewBg = viewBg;
    NSArray *verticalContrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[label]-3-|" options:0 metrics:nil views:@{@"label":_label}];
    NSArray *horizontalCOntraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|" options:0 metrics:nil views:@{@"label":_label}];
    //不同版本使用不一样?
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints];
    } else {
        [self.contentView addConstraints:verticalContrainsts];
        [self.contentView addConstraints:horizontalCOntraints];
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
