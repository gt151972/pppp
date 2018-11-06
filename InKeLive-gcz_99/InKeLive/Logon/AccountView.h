//
//  AccountView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/5.
//  Copyright © 2018 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountView : UIView
- (void)setSubViews: (NSArray *)array;
@property (nonatomic, copy) void(^btnAccountClick)(NSString *userID, NSString *pwdMD5);
- (void)popShow;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
