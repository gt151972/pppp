//
//  LevelGrade.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/10.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelGrade : NSObject
+(LevelGrade *)shareInstance;
- (UIWebView *)greadImage:(int)level;
@end
