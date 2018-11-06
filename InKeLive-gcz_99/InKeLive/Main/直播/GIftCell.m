//
//  GIftCell.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "GIftCell.h"
#import "LocalUserModel.h"
#import "DPK_NW_Application.h"
#import "PresentViewCell.h"

@implementation GIftCell

- (instancetype)initWithRow:(NSInteger)row{
    if (self = [super initWithRow:row]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    [self addSubview:self.imgBg];
    [self.imgBg addSubview:self.iconImageView];
    [self.imgBg addSubview:self.giftImageView];
    [self.imgBg addSubview:self.senderLabel];
    [self.imgBg addSubview:self.lineLabel];
    [self.imgBg addSubview:self.labNum];
    
    [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(2);
        make.width.height.equalTo(@40);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-2);
        make.width.height.equalTo(@40
                                  );
    }];
    
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgBg.mas_centerY);
        make.right.equalTo(self).offset(20);
        make.left.equalTo(self.giftImageView.mas_right).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.senderLabel.mas_bottom).offset(5);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

- (void)startAnimationDuration:(NSTimeInterval)interval completion:(void (^)(BOOL finish))completion
{
    [UIView animateKeyframesWithDuration:interval delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(4, 4);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        
    }];
}

-(void)babyCoinFadeAway
{
    
    //相当与两个动画  合成
    //位置改变
    CABasicAnimation * aniMove = [CABasicAnimation animationWithKeyPath:@"position"];
    aniMove.fromValue = [NSValue valueWithCGPoint:_labNum.layer.position];
    aniMove.toValue = [NSValue valueWithCGPoint:CGPointMake(500, 300)];
    //大小改变
    CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aniScale.fromValue = [NSNumber numberWithFloat:3.0];
    aniScale.toValue = [NSNumber numberWithFloat:0.5];
    
    CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 3.0;//设置动画持续时间
    aniGroup.repeatCount = 1;//设置动画执行次数
//    aniGroup.delegate = self;
    aniGroup.animations = @[aniMove,aniScale];
    aniGroup.removedOnCompletion = NO;
    aniGroup.fillMode = kCAFillModeForwards;  //防止动画结束后回到原位
    //    [lable.layer removeAllAnimations];
    [_labNum.layer addAnimation:aniGroup forKey:@"aniMove_aniScale_groupAnimation"];
    
}


- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.masksToBounds = YES;
//        [_iconImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
//        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return _iconImageView;
}

- (UILabel *)lineLabel{
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc]init];
        _giftLabel.textColor = MAIN_COLOR;
        _giftLabel.textAlignment = NSTextAlignmentLeft;
        _giftLabel.font = [UIFont systemFontOfSize:12];
    }
    return _giftLabel;
}

- (PresentLable *)labNum{
    if (!_labNum) {
        _labNum = [[PresentLable alloc]init];
        _labNum.textColor = RGB(255, 98, 0);
        _labNum.borderColor = MAIN_COLOR;
        _labNum.textAlignment = NSTextAlignmentCenter;
        _labNum.font = [UIFont systemFontOfSize:23];
    }
    return _labNum;
}

- (UILabel *)senderLabel{
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc]init];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.textAlignment = NSTextAlignmentLeft;
        _senderLabel.font = [UIFont systemFontOfSize:12];
    }
    return _senderLabel;
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UIImageView *)imgBg{
    if (!_imgBg) {
        _imgBg = [[UIImageView alloc]init];
        _imgBg.image = [UIImage imageNamed:@"giftBackground"];
//        _imgBg.backgroundColor = RGBA(0, 0, 0, 0.3);
//        //圆角
//        _imgBg.layer.cornerRadius = 20;
//        _imgBg.clipsToBounds = YES;
    }
    return _imgBg;
}


- (void)setPresentmodel:(PresentModel *)presentmodel{
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    _presentmodel = presentmodel;
    NSLog(@"userData == %@",userData.userSmallHeadPic);
    
    NSURL *url =[NSURL URLWithString:userData.userSmallHeadPic];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.senderLabel.text = presentmodel.sender;
    
    NSLog(@"giftImageName == %@",presentmodel.giftImageName);
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
//    NSArray*array2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
//    NSString*cachePath2 = array[0];
    NSString*filePathName2 = [cachePath stringByAppendingPathComponent:@"livingUserInfo.plist"];
    NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:filePathName2];
    self.giftLabel.text = [NSString stringWithFormat:@"送给%@",[dicUser objectForKey:@"userAlias"]];
    //    NSURL *url = [NSURL URLWithString:giftImage];
    NSString *strUrl = [NSString stringWithFormat:@"%@gift/%@",[dict objectForKey:@"res"],presentmodel.giftImageName];
    NSURL *urlGiftImage =[NSURL URLWithString:strUrl];
    [self.giftImageView sd_cancelCurrentImageLoad];
    [self.giftImageView sd_setImageWithURL:urlGiftImage];
    self.labNum.text = [NSString stringWithFormat:@"X"];
}



@end
