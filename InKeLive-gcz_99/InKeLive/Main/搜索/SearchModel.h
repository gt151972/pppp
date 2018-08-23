//
//  SearchModel.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/23.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
@property (nonatomic, assign) int invisible;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) int mLevel;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int online;
@property (nonatomic, assign) int rId;
@property (nonatomic, assign) int uId;
@end
