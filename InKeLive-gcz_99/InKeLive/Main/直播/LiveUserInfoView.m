//
//  LiveUserInfoView.m
//  InKeLive
//
//  Created by gu  on 17/8/15.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "LiveUserInfoView.h"
#import "UIImageView+WebCache.h"
#import "SelectGiftUserView.h"

@interface LiveUserInfoView(){
    int userId;
    NSString *UserAlias;
}
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userAliasLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnUserId;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLable;

//@property (weak, nonatomic) IBOutlet UILabel *zhibuNum;
//@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;
//@property (weak, nonatomic) IBOutlet UILabel *fensiNum;

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
    if(self.userModel ==nil) {
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

/**
 公聊事件

 @param sender <#sender description#>
 */
- (IBAction)btnPublicChatClicked:(id)sender {
    if (self.publicChatBlock) {
        self.publicChatBlock(userId, UserAlias);
    }
}


/**
 私聊事件

 @param sender <#sender description#>
 */
- (IBAction)btnPrivateChatClicked:(id)sender {
    if (self.privateChatBlock) {
        self.privateChatBlock();
    }
}


/**
 送礼事件

 @param sender <#sender description#>
 */
- (IBAction)btnSandGiftClicked:(id)sender {
    if (self.sandGiftBlock) {
        self.sandGiftBlock(userId, UserAlias);
    }
}

-(void)updateInfo {
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"livingUserInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];

    NSLog(@"model == %@",self.userModel);
    NSURL *url =[NSURL URLWithString:[dict objectForKey:@"userSmallHeadPic"]];
    [self.userHeadImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString* strUserAlias = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userAlias"]];
    NSString *strUserId = [NSString stringWithFormat:@"ID:%@",[dict objectForKey:@"userId"]];
    userId = [[dict objectForKey:@"userId"] intValue];
    UserAlias = [dict objectForKey:@"userAlias"];
//    NSString* strUserVipLevel = [NSString stringWithFormat:@"用户等级：%d", self.userModel.vipLevel];
    
    self.userAliasLabel.text = strUserAlias;
    [_btnUserId setTitle:strUserId forState:UIControlStateNormal];
//    self.userLevelLable.text = strUserVipLevel;
}

//弹出窗口
- (void)popShow {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)hide {
    [self removeFromSuperview];
}

@end
