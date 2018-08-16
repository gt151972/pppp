//
//  LiveUserInfoView.m
//  InKeLive
//
//  Created by gu  on 17/8/15.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "LiveUserInfoView.h"
#import "UIImageView+WebCache.h"

@interface LiveUserInfoView()
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userAliasLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLable;
@property (weak, nonatomic) IBOutlet UILabel *zhibuNum;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;
@property (weak, nonatomic) IBOutlet UILabel *fensiNum;

@end

@implementation LiveUserInfoView


+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib lastObject];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

+ (instancetype)userView
{
    //使用的静态函数加载方式
    return [self createViewFromNib];
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    //从 xib中加载
    [super awakeFromNib];
    if(self.userModel !=nil) {
        [self updateInfo];
    }
}

- (IBAction)closeButtonClick:(id)sender {
    if(self.closeBlock)
        self.closeBlock();
}

-(IBAction)backgroundButtonClick:(id)sender
{
    if(self.closeBlock)
        self.closeBlock();

}

- (IBAction)guanzhuButtonClick:(id)sender {
    if(self.guanzhuBlock)
        self.guanzhuBlock();
}


-(void)updateInfo {
    NSURL *url =[NSURL URLWithString:@"http://pic.nipic.com/2007-11-19/20071119205414928_2.jpg"];
    [self.userHeadImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString* strUserAlias = [NSString stringWithFormat:@"用户呢称：%@", self.userModel.userAlias];
    NSString* strUserId = [NSString stringWithFormat:@"用户号码：%d",self.userModel.userId];
    NSString* strUserVipLevel = [NSString stringWithFormat:@"用户等级：%d", self.userModel.vipLevel];
    
    self.userAliasLabel.text = strUserAlias;
    self.userIdLabel.text = strUserId;
    self.userLevelLable.text = strUserVipLevel;
}

@end
