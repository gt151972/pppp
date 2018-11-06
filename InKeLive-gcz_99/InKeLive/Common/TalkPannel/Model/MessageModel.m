//
//  MessageModel.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "MessageModel.h"
#import "RegexKitLite.h"
#import "LevelGrade.h"
#import "TYTextContainer.h"

@implementation MessageModel

- (void)setModelFromStirng:(NSString *)string{
    _userId = 0;
    _dataString = string;
    NSString *msg;
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:14];
    container.linesSpacing = 3;
    container.characterSpacing = 0;
    container.isWidthToFit = YES;
    switch (self.cellType) {
        case CellNewChatMessageType:  //聊天消息
        {
            NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
            NSString *contentPattern = @"(?<=txt@=).*?(?=/)";
            
            NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
            NSString *unReplaceTXT = [[string componentsMatchedByRegex:contentPattern]firstObject];
            NSString *replaceTXT = [unReplaceTXT stringByReplacingOccurrencesOfRegex:@"@A" withString:@"@"];
            NSString *txt = [replaceTXT stringByReplacingOccurrencesOfRegex:@"@S" withString:@"/"];
            
            msg = [NSString stringWithFormat:@"%@:%@",name,txt];
            
            // 属性文本生成器
            container.text = msg;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [msg enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
            textStorage.range = [msg rangeOfString:name];
            textStorage.textColor = RGBA(30, 153, 247, 1);
            textStorage.font = [UIFont systemFontOfSize:14];
            [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        case CellNewGiftType:   //礼物消息??
        {
            
            NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
            NSString *giftPattern = @"(?<=gfid@=).*?(?=/)";
            NSString *hitPattern = @"(?<=hits@=).*?(?=/)";
            
            NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
            NSString *gift = [[string componentsMatchedByRegex:giftPattern]firstObject];
            NSString *hits = [[string componentsMatchedByRegex:hitPattern] firstObject];
            if (hits == NULL) {
                hits = @"1";
            }
            NSString *giftName;
            NSURL *giftIconURL;
            for (NSDictionary *dic in self.gift) {
                NSString *giftID = dic[@"id"];
                if ([gift isEqualToString:giftID]) {
                    giftName = dic[@"name"];
                    giftIconURL = [NSURL URLWithString:dic[@"mobile_icon_v2"]];
                    break;
                }
            }
            NSString *text = [NSString stringWithFormat:@"%@ 赠送给主播%@",name,giftName];
            
            container = [[TYTextContainer alloc]init];
            container.text = text;
            
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            nameTextStorage.range = [text rangeOfString:name];
            nameTextStorage.textColor = RGBA(30, 153, 247, 1);
            nameTextStorage.font = [UIFont systemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.imageURL = giftIconURL;
            imageStorage.size = CGSizeMake(30, 30);
            [container appendTextStorage:imageStorage];
            
            TYTextStorage *giftTextStorage = [[TYTextStorage alloc]init];
            giftTextStorage.text = [NSString stringWithFormat:@"%@连击",hits];
            giftTextStorage.font = [UIFont systemFontOfSize:14];
            [container appendTextStorage:giftTextStorage];
            
            msg = [NSString stringWithFormat:@"%@%@连击",text,hits];
            
        }
            break;
        case CellNewUserEnterType:  //新用户进入
        {
            NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
            NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
            msg = [NSString stringWithFormat:@"%@ 进入了直播间",name];
            
            container.text = msg;
            
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            nameTextStorage.range = [msg rangeOfString:name];
            nameTextStorage.textColor = RGBA(257, 100, 113, 1);
            nameTextStorage.font = [UIFont systemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
        }
            break;
        case CellBanType:   //封杀信息
        {
            NSString *nickPattern = @"(?<=snick@=).*?(?=/)";
            NSString *banedNamePattern = @"(?<=dnick@=).*?(?=/)";
            NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
            NSString *banedName = [[string componentsMatchedByRegex:banedNamePattern]firstObject];
            msg = [NSString stringWithFormat:@"管理员%@封禁了%@",name,banedName];
            
            container.text = msg;
            
            container.textColor = RGBA(257, 100, 113, 1);
            
        }
            break;
        case CellDeserveType: //?打赏???
        {
            NSString *nickPattern = @"(?<=Snick@A=).*?(?=@)";
            NSString *levPattern = @"(?<=lev@=).*?(?=/)";
            NSString *hitPattern = @"(?<=hits@=).*?(?=/)";
            NSString *name = [[string componentsSeparatedByRegex:nickPattern]firstObject];
            NSInteger levle = [[[string componentsSeparatedByRegex:levPattern]firstObject]integerValue];
            NSString *hits = [[string componentsSeparatedByRegex:hitPattern]firstObject];
            NSString *deserve;
            
            switch (levle) {
                case 1:
                    deserve = @"初级酬勤";
                    break;
                case 2:
                    deserve = @"中级酬勤";
                    break;
                case 3:
                    deserve = @"高级酬勤";
                    break;
                default:
                    break;
            }
            msg = [NSString stringWithFormat:@"%@ 给主播赠送了%@%@连击",name,deserve,hits];
            
            container.text = msg;
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            nameTextStorage.range = [msg rangeOfString:name];
            nameTextStorage.textColor = RGBA(30, 153, 247, 1);
            nameTextStorage.font = [UIFont systemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [msg rangeOfString:deserve];
            deserveTextStorage.textColor = RGBA(198, 53, 150, 1);
            deserveTextStorage.font = [UIFont systemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            
            
        }
        default:
            break;
    }
    _unColoredMsg = msg;
    _textContainer = container;
}
- (void)setModel:(NSString*)userID withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withMessage:(NSString*)message toUserAlias:(NSString *)toUserAlias toId:(int)toId level: (int)level
{
    _userId = [userID intValue];
    self.cellType = type;
    userID = userID?userID:@"";
    name = name?name:@"";
    icon = icon?icon:@"";
    if (message.length==0) {
        return;
    }
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:14];
    container.linesSpacing = 3;
    container.characterSpacing = 0;
    container.isWidthToFit = YES;
    NSString *allMessage;
    switch (type) {
        case CellNewChatMessageType:  //新聊天消息
        {
            if (toId == 0) {
                allMessage = [NSString stringWithFormat:@"%@:%@∮",name,message];
            }else{
                allMessage = [NSString stringWithFormat:@"%@:@%@,%@∮",name,toUserAlias,message];
            }
            
            
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3, 0, 16, 16)];
            [view addSubview:[[LevelGrade shareInstance] greadImage:level]];
            [container addView:view range:NSMakeRange(0, 0)];
            //用户名字的颜色和文字大小
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            NSString *sting = [NSString stringWithFormat:@"%@:",name];
            nameTextStorage.range = [allMessage rangeOfString:sting];
            nameTextStorage.textColor = MAIN_COLOR;
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            //用户名字的颜色和文字大小
            TYTextStorage *tonameTextStorage = [[TYTextStorage alloc]init];
            NSString *strToName = [NSString stringWithFormat:@"@%@,",toUserAlias];
            tonameTextStorage.range = [allMessage rangeOfString:strToName];
            tonameTextStorage.textColor = [UIColor whiteColor];
            tonameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:tonameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [allMessage rangeOfString:message];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            
            //增加连接??
            [container addLinkWithLinkData:userID linkColor:MAIN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            [container addLinkWithLinkData:[NSString stringWithFormat:@"%d",toId] linkColor:MAIN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:strToName]];
            
            // 链接
//            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
//            textStorage.range = [allMessage rangeOfString:name];
//            textStorage.textColor = RGB(30, 153, 247);
//            textStorage.font = [UIFont systemFontOfSize:15];
//            [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        case CellSystemHomType:{
            allMessage = [NSString stringWithFormat:@"喇叭: %@∮",message];
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            
            //用户名字的颜色和文字大小
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
//            NSString *string = [NSString stringWithFormat:@""];
            nameTextStorage.range = [allMessage rangeOfString:@"喇叭: "];
            nameTextStorage.textColor = RGB(149, 255, 24);
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [allMessage rangeOfString:message];
            deserveTextStorage.textColor = RGB(149, 255, 24);
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            
//            增加连接??
            [container addLinkWithLinkData:userID linkColor:RGBA(30, 153, 247, 1) underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
//             链接
                        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
                        textStorage.range = [allMessage rangeOfString:name];
                        textStorage.textColor = RGB(30, 153, 247);
                        textStorage.font = [UIFont systemFontOfSize:14];
                        [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        case CellHomType:{
            allMessage = [NSString stringWithFormat:@"喇叭: %@:%@∮",name,message];
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            
            //用户名字的颜色和文字大小
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            NSString *string = [NSString stringWithFormat:@"喇叭: %@:",name];
            nameTextStorage.range = [allMessage rangeOfString:string];
            nameTextStorage.textColor = RGB(32, 233, 256);
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [allMessage rangeOfString:message];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            //增加连接??
            [container addLinkWithLinkData:userID linkColor:RGB(32, 233, 256) underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
//             链接
                        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
                        textStorage.range = [allMessage rangeOfString:name];
                        textStorage.textColor = RGB(32, 233, 256);
                        textStorage.font = [UIFont systemFontOfSize:14];
                        [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        case CellNoticeType:{
            allMessage = [NSString stringWithFormat:@"公告: %@:%@∮",name,message];
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            NSString *string = [NSString stringWithFormat:@"公告: %@:",name];
            nameTextStorage.range = [allMessage rangeOfString:string];
            nameTextStorage.textColor = GREEN_COLOR;
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [allMessage rangeOfString:message];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            //增加连接??
                        [container addLinkWithLinkData:userID linkColor:GREEN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
            // 链接
                        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
                        textStorage.range = [allMessage rangeOfString:name];
                        textStorage.textColor = GREEN_COLOR;
                        textStorage.font = [UIFont systemFontOfSize:14];
                        [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
            
        default:
            break;
    }
    _unColoredMsg = allMessage;
    _textContainer = container;
}

-(void) setModel:(NSString*)sysTipText
{
    _userId = 0;
    NSString* name = @"系统:";
    NSString* message= sysTipText;
    if (message.length==0) {
        return;
    }
    
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:14];
    container.linesSpacing = 3;
    container.characterSpacing = 0;
    container.isWidthToFit = YES;
    NSString *allMessage= [NSString stringWithFormat:@"%@%@∮",name,message];
    
    // 属性文本生成器
    container.text = allMessage;
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配表情
    [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 0) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageName = capturedStrings[1];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake(30, 30);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    //用户名字的颜色和文字大小(系统)
    TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
    nameTextStorage.range = [allMessage rangeOfString:name];
    nameTextStorage.textColor = GREEN_COLOR;
    nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:nameTextStorage];
    
    //聊天格式
    TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
    deserveTextStorage.range = [allMessage rangeOfString:message];
    deserveTextStorage.textColor = GREEN_COLOR;
    deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:deserveTextStorage];
    TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
    deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
    deserveTextStorage2.textColor = [UIColor clearColor];
    deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:deserveTextStorage2];
    // 添加表情数组到label
    [container addTextStorageArray:tmpArray];
    
    _unColoredMsg = allMessage;
    _textContainer = container;
    
}

-(void) setModel:(NSString*)userId withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withGiftId:(NSString*)giftId withGiftName:(NSString*)giftName withGiftNum:(NSString*)giftNum withToId:(NSString *)toId withToName:(NSString*)strToName level:(int)level hide:(BOOL)hide
{
    _userId = [userId intValue];
    NSString* strText1=@"";
    NSString* strAction=@"送给";
    NSString* strGiftInfo = [NSString stringWithFormat:@"%@ 个 %@", giftNum, giftName];
    //NSString* strToUserName = @"XXX";
    
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:14];
    container.linesSpacing = 3;
    container.characterSpacing = 0;
    container.isWidthToFit = YES;
    NSString *allMessage= [NSString stringWithFormat:@"%@ %@ %@ %@∮",name,strAction,strToName,strGiftInfo];
    
    // 属性文本生成器
    container.text = allMessage;
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配表情
    [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 0) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageName = capturedStrings[1];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake(30, 30);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    if (![name isEqualToString:@"天外贵宾"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [view addSubview:[[LevelGrade shareInstance] greadImage:level]];
        [container addView:view range:NSMakeRange(0, 0)];
    }

    //礼物:
//    TYTextStorage *text1TextStorage = [[TYTextStorage alloc]init];
//    text1TextStorage.range = [allMessage rangeOfString:strText1];
//    text1TextStorage.textColor = GREEN_COLOR;
//    text1TextStorage.font = [UIFont boldSystemFontOfSize:15];
//    [container addTextStorage:text1TextStorage];
    
    //用户名字的颜色和文字大小
    TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
    nameTextStorage.range = [allMessage rangeOfString:[NSString stringWithFormat:@"%@",name]];
    nameTextStorage.textColor = MAIN_COLOR;
    nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:nameTextStorage];
    
    //送给
    TYTextStorage *actionTextStorage = [[TYTextStorage alloc]init];
    actionTextStorage.range = [allMessage rangeOfString:strAction];
    actionTextStorage.textColor = [UIColor whiteColor];
    actionTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:actionTextStorage];
    
    //XXX
    TYTextStorage *toUserTextStorage = [[TYTextStorage alloc]init];
    toUserTextStorage.range = [allMessage rangeOfString:[NSString stringWithFormat:@"%@ ",strToName]];
    toUserTextStorage.textColor = MAIN_COLOR;
    toUserTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:toUserTextStorage];
    
    //礼物格式
    TYTextStorage *giftInfoTextStorage = [[TYTextStorage alloc]init];
    giftInfoTextStorage.range = [allMessage rangeOfString:strGiftInfo];
    giftInfoTextStorage.textColor = [UIColor whiteColor];
    giftInfoTextStorage.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:giftInfoTextStorage];
    TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
    deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
    deserveTextStorage2.textColor = [UIColor clearColor];
    deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
    [container addTextStorage:deserveTextStorage2];
    if (!hide) {
        [container addLinkWithLinkData:userId linkColor:MAIN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
    }
    [container addLinkWithLinkData:toId linkColor:MAIN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:[NSString stringWithFormat:@" %@",strToName]]];
    // 添加表情数组到label
    [container addTextStorageArray:tmpArray];
    
    _unColoredMsg = allMessage;
    _textContainer = container;
}
/**
 进出房间通知
 
 @param userId <#userId description#>
 @param name <#name description#>
 @param type <#type description#>
 @param level <#level description#>
 */
-(void)setModelWithId:(NSString *)userId name:(NSString *)name type:(CellType)type level:(int)level{
    _userId = [userId intValue];
    self.cellType = type;
    userId = userId?userId:@"";
    name = name?name:@"";
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:14];
    container.linesSpacing = 3;
    container.characterSpacing = 0;
    container.isWidthToFit = YES;
    NSString *allMessage;
    switch (type) {
        case CellLeaveType:  //新聊天消息
        {
            
            allMessage = [NSString stringWithFormat:@"%@ 离开了!∮",name];
            
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            [view addSubview:[[LevelGrade shareInstance] greadImage:level]];
            [container addView:view range:NSMakeRange(0, 0)];
            //用户名字的颜色和文字大小
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            NSString *string = [NSString stringWithFormat:@"%@ ",name];
            nameTextStorage.range = [allMessage rangeOfString:string];
            nameTextStorage.textColor = MAIN_COLOR;
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            NSString *string2 = @" 离开了!";
            deserveTextStorage.range = [allMessage rangeOfString:string2];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            
            //增加连接??
//            [container addLinkWithLinkData:userId linkColor:RGBA(30, 153, 247, 1) underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
            //             链接
//            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
//            textStorage.range = [allMessage rangeOfString:name];
//            textStorage.textColor = RGB(30, 153, 247);
//            textStorage.font = [UIFont systemFontOfSize:14];
//            [container addTextStorage:textStorage];
//            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        case CellEnterType:  //新聊天消息
        {
            allMessage = [NSString stringWithFormat:@"%@ 进来了!∮",name];
            
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            // 正则匹配表情
            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                if (captureCount > 0) {
                    // 图片信息储存
                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                    imageStorage.cacheImageOnMemory = YES;
                    imageStorage.imageName = capturedStrings[1];
                    imageStorage.range = capturedRanges[0];
                    imageStorage.size = CGSizeMake(30, 30);
                    
                    [tmpArray addObject:imageStorage];
                }
            }];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            [view addSubview:[[LevelGrade shareInstance] greadImage:level]];
            [container addView:view range:NSMakeRange(0, 0)];
            //用户名字的颜色和文字大小
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            NSString *string = [NSString stringWithFormat:@"%@ ",name];
            nameTextStorage.range = [allMessage rangeOfString:string];
            nameTextStorage.textColor = MAIN_COLOR;
            nameTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:nameTextStorage];
            
            //聊天格式
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            NSString *string2 = @" 进来了!";
            deserveTextStorage.range = [allMessage rangeOfString:string2];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage];
            TYTextStorage *deserveTextStorage2 = [[TYTextStorage alloc]init];
            deserveTextStorage2.range = [allMessage rangeOfString:@"∮"];
            deserveTextStorage2.textColor = [UIColor clearColor];
            deserveTextStorage2.font = [UIFont boldSystemFontOfSize:14];
            [container addTextStorage:deserveTextStorage2];
            //增加连接??
            [container addLinkWithLinkData:userId linkColor:MAIN_COLOR underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
            //             链接
//            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
//            textStorage.range = [allMessage rangeOfString:name];
//            textStorage.textColor = RGB(30, 153, 247);
//            textStorage.font = [UIFont systemFontOfSize:14];
//            [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
        default:
            break;
    }
    _unColoredMsg = allMessage;
    _textContainer = container;
}
@end
