//
//  RecommendModel.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User_Nodes,Users,User,Live_Nodes,Lives,Creator;
@interface RecommendModel : NSObject


@property (nonatomic, strong) NSArray<Live_Nodes *> *live_nodes;

@property (nonatomic, assign) NSInteger dm_error;

@property (nonatomic, strong) NSArray<User_Nodes *> *user_nodes;

@property (nonatomic, copy) NSString *error_msg;


@end
@interface User_Nodes : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<Users *> *users;

@end

@interface Users : NSObject

@property (nonatomic, copy) NSString *relation;

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *reason;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *third_platform;

@property (nonatomic, assign) NSInteger rank_veri;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger gmutex;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger inke_verify;

@property (nonatomic, copy) NSString *verified_reason;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *hometown;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *veri_info;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *profession;

@end

@interface Live_Nodes : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<Lives *> *lives;

@end

@interface Lives : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger room_id;

@property (nonatomic, assign) NSInteger online_users;

@property (nonatomic, assign) NSInteger version;

@property (nonatomic, assign) NSInteger rotate;

@property (nonatomic, assign) NSInteger multi;

@property (nonatomic, assign) NSInteger link;

@property (nonatomic, copy) NSString *share_addr;

@property (nonatomic, assign) NSInteger slot;

@property (nonatomic, strong) Creator *creator;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) NSInteger group;

@property (nonatomic, copy) NSString *stream_addr;

@property (nonatomic, assign) NSInteger pub_stat;

@property (nonatomic, assign) NSInteger optimal;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger status;

@end

@interface Creator : NSObject

@property (nonatomic, copy) NSString *third_platform;

@property (nonatomic, assign) NSInteger rank_veri;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger gmutex;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger inke_verify;

@property (nonatomic, copy) NSString *verified_reason;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *hometown;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *veri_info;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *profession;

@end


/////////////////////////////////////////////////
/*
 
 {"dm_error":0,"error_msg":"操作成功","live_nodes":[{"title":"游戏达人","lives":[{"city":"上海市","creator":{"emotion":"","inke_verify":0,"verified":0,"description":"直播间招大哥","gender":1,"profession":"Ta好像忘记写职业了","sex":1,"verified_reason":"","nick":"小戰","location":"上海市","birth":"1996-01-01","hometown":"陕西省&西安市","id":441861892,"portrait":"http://img2.inke.cn/MTQ5NTYxMzY2OTQyNiM0MjcjanBn.jpg","gmutex":0,"third_platform":"1","level":23,"rank_veri":4,"veri_info":"正太"},"id":"1502452950632485","image":"","name":"映客第一adc","pub_stat":1,"room_id":201,"share_addr":"https://h5.inke.cn/app/index.html#/game/live?uid=441861892&liveid=1502452950632485&ctime=1502452950","slot":1,"status":1,"stream_addr":"http://pull99gm.inke.cn/live/1502452950632485.flv?ikHost=ws&ikOp=1&codecInfo=8192","version":0,"landscape":1,"live_type":"game","like":[{"id":44,"icon":"http://img2.inke.cn/MTQ5MDMzNzczNTI0OSM3MSNqcGc=.jpg"},{"id":45,"icon":"http://img2.inke.cn/MTQ5MDMzNzc0MjIwMyMxNDgjanBn.jpg"},{"id":42,"icon":"http://img2.inke.cn/MTQ5MDMzNzcxNzY1MSM3MzEjanBn.jpg"},{"id":43,"icon":"http://img2.inke.cn/MTQ5MDMzNzcyNTU0OSMyMCNqcGc=.jpg"},{"id":40,"icon":"http://img2.inke.cn/MTQ5MDMzNzY4ODgwMSM1NTAjanBn.jpg"},{"id":41,"icon":"http://img2.inke.cn/MTQ5MDMzNzY5ODk5NCM5NDQjanBn.jpg"}],"online_users":27550,"group":0,"link":0,"optimal":0,"multi":0,"rotate":0,"extra":{"cover":"http://img2.inke.cn/MTUwMDg5NDM1MjA0NCM0MzMjanBn.jpg","label":[]}},{"city":"哈尔滨市","creator":{"emotion":"","inke_verify":0,"verified":89,"description":"不强求，不将就🐾","gender":0,"profession":"学生","sex":0,"verified_reason":"游戏达人","nick":"🌸女王大人.","location":"哈尔滨市","birth":"1996-01-05","hometown":"哈尔滨市","id":156275519,"portrait":"http://img2.inke.cn/MTUwMTMyODY3MzcwOCM5NjIjanBn.jpg","gmutex":0,"third_platform":"0","level":14,"rank_veri":89,"veri_info":"游戏达人"},"id":"1502452916559478","image":"","name":"小葵花课堂开课啦😄","pub_stat":1,"room_id":201,"share_addr":"https://h5.inke.cn/app/index.html#/game/live?uid=156275519&liveid=1502452916559478&ctime=1502452916","slot":2,"status":1,"stream_addr":"http://pull99gm.inke.cn/live/1502452916559478.flv?ikHost=ws&ikOp=1&codecInfo=8192","version":0,"landscape":1,"live_type":"game","like":[{"id":44,"icon":"http://img2.inke.cn/MTQ5MDMzNzczNTI0OSM3MSNqcGc=.jpg"},{"id":45,"icon":"http://img2.inke.cn/MTQ5MDMzNzc0MjIwMyMxNDgjanBn.jpg"},{"id":42,"icon":"http://img2.inke.cn/MTQ5MDMzNzcxNzY1MSM3MzEjanBn.jpg"},{"id":43,"icon":"http://img2.inke.cn/MTQ5MDMzNzcyNTU0OSMyMCNqcGc=.jpg"},{"id":40,"icon":"http://img2.inke.cn/MTQ5MDMzNzY4ODgwMSM1NTAjanBn.jpg"},{"id":41,"icon":"http://img2.inke.cn/MTQ5MDMzNzY5ODk5NCM5NDQjanBn.jpg"}],"online_users":20946,"group":0,"link":0,"optimal":0,"multi":0,"rotate":0,"extra":{"cover":"http://oss-cn-beijing.aliyuncs.com/feeds-video-1/cover/MTUwMjQ1NzM2MTM4MiMxNDgjY292ZXI=","label":[{"tab_name":"王者荣耀","tab_key":"7A3EA0ECD91632C8","cl":[0,216,201,1]},{"tab_name":"游戏达人","tab_key":"游戏达人","cl":[0,216,201,1]},{"tab_name":"游戏大神","tab_key":"游戏大神","cl":[0,216,201,1]},{"tab_name":"清纯","tab_key":"清纯","cl":[0,216,201,1]},{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"哈尔滨市","tab_key":"哈尔滨市","cl":[0,216,201,1]}]}},{"city":"金华市","creator":{"emotion":"已婚","inke_verify":0,"verified":0,"description":" ","gender":1,"profession":"你猜","sex":1,"verified_reason":"","nick":"楼云","location":"金华市","birth":"1992-10-26","hometown":"浙江省&金华市","id":31439358,"portrait":"http://img2.inke.cn/MTQ5ODYwMjY5NjAyOCMxNTcjanBn.jpg","gmutex":1,"third_platform":"1","level":77,"rank_veri":11,"veri_info":"暖男"},"id":"1502452964457343","image":"","name":"今天也来教我玩游戏好吗","pub_stat":1,"room_id":201,"share_addr":"https://h5.inke.cn/app/index.html#/game/live?uid=31439358&liveid=1502452964457343&ctime=1502452964","slot":1,"status":1,"stream_addr":"http://pull99gm.inke.cn/live/1502452964457343.flv?ikHost=ws&ikOp=1&codecInfo=8192","version":0,"landscape":1,"live_type":"game","like":[{"id":44,"icon":"http://img2.inke.cn/MTQ5MDMzNzczNTI0OSM3MSNqcGc=.jpg"},{"id":45,"icon":"http://img2.inke.cn/MTQ5MDMzNzc0MjIwMyMxNDgjanBn.jpg"},{"id":42,"icon":"http://img2.inke.cn/MTQ5MDMzNzcxNzY1MSM3MzEjanBn.jpg"},{"id":43,"icon":"http://img2.inke.cn/MTQ5MDMzNzcyNTU0OSMyMCNqcGc=.jpg"},{"id":40,"icon":"http://img2.inke.cn/MTQ5MDMzNzY4ODgwMSM1NTAjanBn.jpg"},{"id":41,"icon":"http://img2.inke.cn/MTQ5MDMzNzY5ODk5NCM5NDQjanBn.jpg"}],"online_users":27467,"group":0,"link":0,"optimal":0,"multi":0,"rotate":0,"extra":{"cover":"http://oss-cn-beijing.aliyuncs.com/feeds-video-1/cover/MTUwMjQ1NzQxMjk0NSMzOTIjY292ZXI=","label":[{"tab_name":"王者荣耀","tab_key":"7A3EA0ECD91632C8","cl":[0,216,201,1]},{"tab_name":"游戏达人","tab_key":"游戏达人","cl":[0,216,201,1]},{"tab_name":"阳光暖男","tab_key":"阳光暖男","cl":[0,216,201,1]},{"tab_name":"金华市","tab_key":"金华市","cl":[0,216,201,1]}]}}]},{"title":"好声音","lives":[{"city":"漳州市","creator":{"emotion":"已婚","inke_verify":0,"verified":0,"description":"感谢那些经久不离的陪伴❤️","gender":0,"profession":"do   re   mi","sex":3,"verified_reason":"","nick":"✨🎤  大舌头小秋秋🎤🎀","third_platform":"0","location":"漳州市","birth":"2013-09-14","hometown":"福建省&漳州市","portrait":"http://img2.inke.cn/MTQ5OTE5NzU0MjI5MSM2NTQjanBn.jpg","gmutex":0,"id":56637624,"level":40,"rank_veri":6,"veri_info":"玉女"},"id":"1502456172335382","image":"","name":"想睡不敢睡，困死宝宝了","pub_stat":1,"room_id":1044382024,"share_addr":"https://mlive3.inke.cn/share/live.html?uid=56637624&liveid=1502456172335382&ctime=1502456172","slot":1,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502456172335382.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":36101,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"好声音","tab_key":"好声音","cl":[0,216,201,1]},{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"清纯","tab_key":"清纯","cl":[0,216,201,1]},{"tab_name":"漳州市","tab_key":"漳州市","cl":[0,216,201,1]}]}},{"city":"广州市","creator":{"emotion":"保密","inke_verify":0,"verified":0,"description":"主播回来了","gender":0,"profession":"Ta好像忘记写职业了","sex":3,"verified_reason":"","nick":"套爷","location":"广州市","birth":"1992-03-14","hometown":"广东省&梅州市","id":9534635,"portrait":"http://img2.inke.cn/MTUwMjEwNTI0MjI0NyMxMTIjanBn.jpg","gmutex":0,"third_platform":"1","level":55,"rank_veri":8,"veri_info":"辣妹"},"id":"1502456660760129","image":"","name":"","pub_stat":1,"room_id":1044386815,"share_addr":"https://mlive5.inke.cn/share/live.html?uid=9534635&liveid=1502456660760129&ctime=1502456660","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502456660760129.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":11326,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"好声音","tab_key":"好声音","cl":[0,216,201,1]},{"tab_name":"性感","tab_key":"性感","cl":[0,216,201,1]},{"tab_name":"广州市","tab_key":"广州市","cl":[0,216,201,1]}]}},{"city":"天津市","creator":{"emotion":"保密","inke_verify":0,"verified":0,"description":"⏰20:00-22:00\n白天无聊会播一会儿！","gender":1,"profession":"搬砖","sex":1,"verified_reason":"","nick":"雅绪🦉","third_platform":"1","location":"天津市","birth":"1995-11-13","hometown":"天津市","portrait":"http://img2.inke.cn/MTUwMjI5NzMwOTAwNiM5OTIjanBn.jpg","gmutex":0,"id":4323525,"level":21,"rank_veri":4,"veri_info":"正太"},"id":"1502452836729859","image":"","name":"","pub_stat":1,"room_id":1044349809,"share_addr":"https://mlive23.inke.cn/share/live.html?uid=4323525&liveid=1502452836729859&ctime=1502452836","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502452836729859.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":26283,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"好声音","tab_key":"好声音","cl":[0,216,201,1]},{"tab_name":"才艺","tab_key":"才艺","cl":[0,216,201,1]},{"tab_name":"阳光暖男","tab_key":"阳光暖男","cl":[0,216,201,1]},{"tab_name":"天津市","tab_key":"天津市","cl":[0,216,201,1]}]}}]},{"title":"小清新","lives":[{"city":"石家庄市","creator":{"emotion":"单身","inke_verify":0,"verified":0,"description":"从明天开始 当一个劳模🙂","gender":0,"profession":"🐱","sex":3,"verified_reason":"","nick":"萌妃妃","third_platform":"1","location":"石家庄市","birth":"2008-02-16","hometown":"火星","portrait":"http://img2.inke.cn/MTUwMjM5MDgzMTYxOSM1MDcjanBn.jpg","gmutex":0,"id":44122327,"level":61,"rank_veri":9,"veri_info":"白富美"},"id":"1502457412326123","image":"","name":"🙃🙃","pub_stat":1,"room_id":1044394258,"share_addr":"https://mlive23.inke.cn/share/live.html?uid=44122327&liveid=1502457412326123&ctime=1502457412","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502457412326123.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":9806,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"有料","tab_key":"有料","cl":[0,216,201,1]},{"tab_name":"清纯","tab_key":"清纯","cl":[0,216,201,1]},{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"好声音","tab_key":"好声音","cl":[0,216,201,1]},{"tab_name":"石家庄市","tab_key":"石家庄市","cl":[0,216,201,1]}]}},{"city":"包头市","creator":{"emotion":"单身","inke_verify":0,"verified":0,"description":"不忘初心 用心演奏 感恩陪伴","gender":0,"profession":"古筝老师","sex":3,"verified_reason":"","nick":"🌻弦之舞VV","location":"包头市","birth":"1992-03-27","hometown":"内蒙古自治区&包头市","id":7889663,"portrait":"http://img2.inke.cn/MTQ5OTYwNjA1NzQyMSM2NDAjanBn.jpg","gmutex":0,"third_platform":"1","level":71,"rank_veri":10,"veri_info":"美人"},"id":"1502456620377693","image":"","name":"","pub_stat":1,"room_id":1044386377,"share_addr":"https://mlive24.inke.cn/share/live.html?uid=7889663&liveid=1502456620377693&ctime=1502456620","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502456620377693.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":25573,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"才艺","tab_key":"才艺","cl":[0,216,201,1]},{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"清纯","tab_key":"清纯","cl":[0,216,201,1]},{"tab_name":"包头市","tab_key":"包头市","cl":[0,216,201,1]}]}},{"city":"杭州市","creator":{"emotion":"单身","inke_verify":0,"verified":0,"description":"我喜欢老歌黄路灯和时间帮我挑的朋友","gender":0,"profession":"你猜","sex":3,"verified_reason":"","nick":"小🎐雪","third_platform":"0","location":"杭州市","birth":"2013-11-28","hometown":"火星","portrait":"http://img2.inke.cn/MTUwMjMxNTUyMTkyMCM2MDUjanBn.jpg","gmutex":0,"id":60354522,"level":90,"rank_veri":13,"veri_info":"富家小姐"},"id":"1502453912251265","image":"","name":"","pub_stat":1,"room_id":1044359935,"share_addr":"https://mlive25.inke.cn/share/live.html?uid=60354522&liveid=1502453912251265&ctime=1502453912","slot":1,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502453912251265.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":36797,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"气质","tab_key":"气质","cl":[0,216,201,1]},{"tab_name":"活泼开朗","tab_key":"活泼开朗","cl":[0,216,201,1]},{"tab_name":"性感","tab_key":"性感","cl":[0,216,201,1]},{"tab_name":"杭州市","tab_key":"杭州市","cl":[0,216,201,1]}]}}]},{"title":"搞笑达人","lives":[{"city":"松原市","creator":{"emotion":"保密","inke_verify":0,"verified":0,"description":"永远守候我姐和我徒弟丽丽！","gender":1,"profession":"Ta好像忘记写职业了","sex":1,"verified_reason":"","nick":"大傻龙子","location":"松原市","birth":"1996-01-01","hometown":"吉林省&松原市","id":2750070,"portrait":"http://img2.inke.cn/MTQ5NTY4MDY3NjU1MyM3MDkjanBn.jpg","gmutex":0,"third_platform":"1","level":100,"rank_veri":14,"veri_info":"花花公子"},"id":"1502456462154863","image":"","name":"晚上好","pub_stat":1,"room_id":1044384857,"share_addr":"https://mlive10.inke.cn/share/live.html?uid=2750070&liveid=1502456462154863&ctime=1502456462","slot":1,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502456462154863.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":12582,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"逗比搞笑","tab_key":"逗比搞笑","cl":[0,216,201,1]},{"tab_name":"幽默风趣","tab_key":"幽默风趣","cl":[0,216,201,1]},{"tab_name":"才艺","tab_key":"才艺","cl":[0,216,201,1]},{"tab_name":"松原市","tab_key":"松原市","cl":[0,216,201,1]}]}},{"city":"天津市","creator":{"emotion":"单身","inke_verify":0,"verified":0,"description":"💕榜前十➕\n💕感谢老铁诋毁还有赞美","gender":1,"profession":"小主播","sex":1,"verified_reason":"","nick":"🔫王皓轩（努力破600万）","third_platform":"1","location":"朝阳市","birth":"1993-09-10","hometown":"辽宁省&朝阳市","portrait":"http://img2.inke.cn/MTUwMTUyMzMyMzg5OCM4MyNqcGc=.jpg","gmutex":0,"id":2049753,"level":53,"rank_veri":8,"veri_info":"型男"},"id":"1502456710736828","image":"","name":"","pub_stat":1,"room_id":1044387347,"share_addr":"https://mlive21.inke.cn/share/live.html?uid=2049753&liveid=1502456710736828&ctime=1502456710","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502456710736828.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":4259,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"逗比搞笑","tab_key":"逗比搞笑","cl":[0,216,201,1]},{"tab_name":"幽默风趣","tab_key":"幽默风趣","cl":[0,216,201,1]},{"tab_name":"阳光暖男","tab_key":"阳光暖男","cl":[0,216,201,1]},{"tab_name":"天津市","tab_key":"天津市","cl":[0,216,201,1]}]}},{"city":"蒙特利尔","creator":{"emotion":"单身","inke_verify":0,"verified":0,"description":"可爱的外表，有趣的灵魂，神奇的猪猪","gender":1,"profession":"个体户","sex":1,"verified_reason":"","nick":"萌村萌叔～占卜猪","location":"蒙特利尔","birth":"1988-05-02","hometown":"海外&加拿大","id":52183041,"portrait":"http://img2.inke.cn/MTUwMTI3ODg0NDU3NiM2NDYjanBn.jpg","gmutex":0,"third_platform":"1","level":58,"rank_veri":9,"veri_info":"高富帅"},"id":"1502457178423150","image":"","name":"早啊 宝宝们","pub_stat":1,"room_id":1044392002,"share_addr":"https://mlive18.inke.cn/share/live.html?uid=52183041&liveid=1502457178423150&ctime=1502457178","slot":2,"status":1,"stream_addr":"http://qqpull.inke.cn/live/1502457178423150.flv?ikHost=tx&ikOp=0&codecInfo=8192","version":0,"live_type":"","landscape":0,"like":[],"online_users":30704,"group":0,"link":0,"optimal":1,"multi":0,"rotate":0,"extra":{"cover":null,"label":[{"tab_name":"儒雅绅士","tab_key":"儒雅绅士","cl":[0,216,201,1]},{"tab_name":"阳光暖男","tab_key":"阳光暖男","cl":[0,216,201,1]},{"tab_name":"幽默风趣","tab_key":"幽默风趣","cl":[0,216,201,1]},{"tab_name":"蒙特利尔","tab_key":"蒙特利尔","cl":[0,216,201,1]}]}}]}],"user_nodes":[{"title":"今日推荐","users":[{"user":{"emotion":"单身","inke_verify":0,"verified":1,"description":"日榜一➕V  微博：伊诺00117","liverank":{"uid":92374945,"dis_score":184,"pic":"http://img2.inke.cn/MTQ5NzU5Nzk0NDUzMSM3OSNqcGc=.jpg","score":1074,"level":16},"level":31,"gender":0,"veri_info":"慕兮抽象画工坊创始人","profession":"画室","sex":0,"verified_reason":"慕兮抽象画工坊创始人","nick":"Lonely Patients","third_platform":"0","rank_veri":1,"location":"青岛市","birth":"1994-02-18","hometown":"山东省&青岛市","portrait":"http://img2.inke.cn/MTQ5MjQ5Mzc5Mjc3NiM2MzMjanBn.jpg","gmutex":0,"id":92374945},"reason":"性感小诺诺","relation":"null","live_id":"1502457555779492"},{"user":{"emotion":"","inke_verify":0,"verified":0,"description":"","liverank":{"uid":130716173,"dis_score":88,"pic":"http://img2.inke.cn/MTQ5NzU5ODE0NDUzOSM2NzEjanBn.jpg","score":5050,"level":27},"level":22,"gender":1,"veri_info":"正太","profession":"Ta好像忘记写职业了","sex":1,"verified_reason":"","nick":"☔️-不战而胜的王","third_platform":"0","rank_veri":4,"location":"兰州市","birth":"1996-01-01","hometown":"甘肃省&兰州市","portrait":"http://img2.inke.cn/MTQ5ODQxNjM4OTAwMiM3NjAjanBn.jpg","gmutex":0,"id":130716173},"reason":"帅气型男","relation":"null","live_id":"1502456420266308"},{"user":{"emotion":"保密","inke_verify":0,"verified":0,"description":"每晚八点，不见不散，你不来 我不走！","liverank":{"uid":3502815,"dis_score":893,"pic":"http://img2.inke.cn/MTQ5NzU5ODM3NzA0NCM1MDQjanBn.jpg","score":11492,"level":36},"level":58,"gender":0,"veri_info":"白富美","profession":"Ta好像忘记写职业了","sex":3,"verified_reason":"","nick":"咛公子💤💤","third_platform":"1","rank_veri":9,"location":"","birth":"2012-07-27","hometown":"火星","portrait":"http://img2.inke.cn/MTQ5NjgxNTY3ODM3NiM4NzgjanBn.jpg","gmutex":0,"id":3502815},"reason":"活泼咛公子","relation":"null","live_id":"1502453618499179"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"记得我就好略略略","liverank":{"uid":84207712,"dis_score":128,"pic":"http://img2.inke.cn/MTQ5NzU5ODI3NTA4NSMxMTgjanBn.jpg","score":7580,"level":31},"level":37,"gender":1,"veri_info":"金童","profession":"煤矿专职工","sex":1,"verified_reason":"","nick":"Wuli小粥粥","third_platform":"0","rank_veri":6,"location":"无锡市","birth":"2015-09-12","hometown":"江苏省&无锡市","portrait":"http://img2.inke.cn/MTQ5ODgwNzczOTc3MyM0MDQjanBn.jpg","gmutex":0,"id":84207712},"reason":"深夜老司机","relation":"null","live_id":"1502457222535047"},{"user":{"emotion":"保密","inke_verify":0,"verified":0,"description":"🎵代表作《你是我大哥》《爱从天降》《自由奔腾》《我就是你兄弟》","liverank":{"uid":71846725,"dis_score":407,"pic":"http://img2.inke.cn/MTQ5NzU5ODMzNTg2NSM3NDcjanBn.jpg","score":10900,"level":35},"level":52,"gender":1,"veri_info":"型男","profession":"音乐人、原创歌手","sex":1,"verified_reason":"","nick":"华语歌手李刚","third_platform":"0","rank_veri":8,"location":"南通市","birth":"1978-06-18","hometown":"黑龙江省&哈尔滨市","portrait":"http://img2.inke.cn/MTQ4NjYyNzczMzk2MiM0MCNqcGc=.jpg","gmutex":0,"id":71846725},"reason":"音乐人、原创歌手李刚","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"不能站在别人的角度思考问题就别瞎逼逼😄","liverank":{"uid":2244238,"dis_score":633,"pic":"http://img2.inke.cn/MTQ5NzU5ODM3NzA0NCM1MDQjanBn.jpg","score":11752,"level":36},"level":94,"gender":0,"veri_info":"富家小姐","profession":"vx: 1535386599o","sex":3,"verified_reason":"","nick":"奶糖妹妹","third_platform":"1","rank_veri":13,"location":"榆林市","birth":"1994-05-30","hometown":"陕西省&榆林市","portrait":"http://img2.inke.cn/MTQ5ODc5NjEyMDk1OSMxOTcjanBn.jpg","gmutex":0,"id":2244238},"reason":"活泼开朗的奶糖妹妹","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"我想时间慢一点 阳光亮一点  我的笑容多一点  ❤️","liverank":{"uid":7312206,"dis_score":466,"pic":"http://img2.inke.cn/MTQ5NzU5ODI2MjY2OSMyOTIjanBn.jpg","score":6508,"level":30},"level":53,"gender":0,"veri_info":"辣妹","profession":"收破烂的","sex":3,"verified_reason":"","nick":"🍋最近不播🍋感冒发烧支气管感染","third_platform":"1","rank_veri":8,"location":"大连市","birth":"1996-01-01","hometown":"辽宁省&大连市","portrait":"http://img2.inke.cn/MTQ5NzE4OTA0NTM2NSM2MzAjanBn.jpg","gmutex":0,"id":7312206},"reason":"收破烂的笨笨","relation":"null","live_id":"1502456874398957"},{"user":{"emotion":"保密","inke_verify":0,"verified":1,"description":"🍼不辜负粉丝对我的期望","liverank":{"uid":58563794,"dis_score":306,"pic":"http://img2.inke.cn/MTQ5NzU5ODE1NzU4NiM5NjgjanBn.jpg","score":5383,"level":28},"level":40,"gender":1,"veri_info":"2014上海国际模特大赛河南赛区总决赛时装组十佳模特称号得主","profession":"模特导师","sex":1,"verified_reason":"2014上海国际模特大赛河南赛区总决赛时装组十佳模特称号得主","nick":"🍼BBBQ","third_platform":"0","rank_veri":1,"location":"南阳市","birth":"1993-02-05","hometown":"北京市","portrait":"http://img2.inke.cn/MTQ5ODM4NzI5NDI4MSMxOTIjanBn.jpg","gmutex":0,"id":58563794},"reason":"职业模特帅不帅","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":" ","liverank":{"uid":6248953,"dis_score":675,"pic":"http://img2.inke.cn/MTQ5NzU5ODI5MDc1OSM2OSNqcGc=.jpg","score":7831,"level":32},"level":28,"gender":0,"veri_info":"小公举","profession":"唱歌主播","sex":0,"verified_reason":"","nick":"雨泽、小歌手！","third_platform":"0","rank_veri":5,"location":"大连市","birth":"2012-12-31","hometown":"辽宁省&大连市","portrait":"http://img2.inke.cn/MTQ5Nzg4MDA4MTczOCMzNTAjanBn.jpg","gmutex":0,"id":6248953},"reason":"雨泽FD","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"微博：Jill火火","liverank":{"uid":1901165,"dis_score":20,"pic":"http://img2.inke.cn/MTQ5NzU5NzY1NjcxOCM4NzEjanBn.jpg","score":50,"level":3},"level":25,"gender":1,"veri_info":"怪蜀黍","profession":"Ta好像忘记写职业了","sex":1,"verified_reason":"","nick":"🔥Jill火火","third_platform":"1","rank_veri":5,"location":"杭州市","birth":"1996-07-10","hometown":"火星","portrait":"http://img2.inke.cn/MTQ5ODY2NTEwMDgxMyM2NTEjanBn.jpg","gmutex":0,"id":1901165},"reason":"帅气酷男","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"心有猛虎.细嗅蔷薇🌺","liverank":{"uid":10723474,"dis_score":18,"pic":"http://img2.inke.cn/MTQ5NzU5NzY4NzgxOCMzOTgjanBn.jpg","score":110,"level":5},"level":50,"gender":0,"veri_info":"辣妹","profession":"卖衣服的小火柴","sex":3,"verified_reason":"","nick":"奈奈生🌸","third_platform":"1","rank_veri":8,"location":"里士满","birth":"1996-01-01","hometown":"海外&加拿大","portrait":"http://img2.inke.cn/MTQ5NDQyOTEzNTU1MSMxMzIjanBn.jpg","gmutex":0,"id":10723474},"reason":"有个性的小秋秋","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":" ","liverank":{"uid":9820330,"dis_score":579,"pic":"http://img2.inke.cn/MTQ5NzU5ODI3NTA4NSMxMTgjanBn.jpg","score":7129,"level":31},"level":40,"gender":0,"veri_info":"玉女","profession":"Ta好像忘记写职业了","sex":0,"verified_reason":"","nick":"张小仙儿_","third_platform":"0","rank_veri":6,"location":"长沙市","birth":"2015-10-31","hometown":"火星","portrait":"http://img2.inke.cn/MTQ5Nzk0NDM4NTk0NiM2NTIjanBn.jpg","gmutex":0,"id":9820330},"reason":"张小仙儿是小公举","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"这辈子最遗憾的事就是亲不到自己的脸😄","liverank":{"uid":97420743,"dis_score":73,"pic":"http://img2.inke.cn/MTQ5NzU5ODE1NzU4NiM5NjgjanBn.jpg","score":5616,"level":28},"level":32,"gender":0,"veri_info":"小公举","profession":"你猜","sex":3,"verified_reason":"","nick":"小酒窝","third_platform":"0","rank_veri":5,"location":"哈尔滨市","birth":"1995-04-08","hometown":"黑龙江省&双鸭山市","portrait":"http://img2.inke.cn/MTQ5ODIzODA1MTc2NyM1NzUjanBn.jpg","gmutex":0,"id":97420743},"reason":"成熟彤彤宝宝","relation":"null"},{"user":{"emotion":"","inke_verify":0,"verified":0,"description":"求破2百万","liverank":{"uid":9886446,"dis_score":571,"pic":"http://img2.inke.cn/MTQ5NzU5ODIwMzU1OSM5MzMjanBn.jpg","score":5731,"level":29},"level":24,"gender":0,"veri_info":"萝莉","profession":"Ta好像忘记写职业了","sex":3,"verified_reason":"","nick":"老地方的雨","third_platform":"1","rank_veri":4,"location":"苏州市","birth":"1996-01-26","hometown":"苏州市","portrait":"http://img2.inke.cn/MTQ5ODY1ODIxMDExMiM5ODYjanBn.jpg","gmutex":0,"id":9886446},"reason":"性感女主播","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"世界上最浪漫的事，就是我们彼此相遇。","liverank":{"uid":64403113,"dis_score":1,"pic":"http://img2.inke.cn/MTQ5NzU5NzYzMzIwNSM1MzcjanBn.jpg","score":48,"level":2},"level":14,"gender":0,"veri_info":"","profession":"保密","sex":0,"verified_reason":"","nick":"闪闪","third_platform":"0","rank_veri":3,"location":"武汉市","birth":"1995-02-06","hometown":"湖北省&武汉市","portrait":"http://img2.inke.cn/MTQ5Nzk0MTcwOTU5NiM3NzkjanBn.jpg","gmutex":0,"id":64403113},"reason":"闪闪惹人爱的闪闪","relation":"null"},{"user":{"emotion":"","inke_verify":0,"verified":0,"description":"感谢陪伴💕不知道会陪我到什么时候呢🌙","liverank":{"uid":60861747,"dis_score":930,"pic":"http://img2.inke.cn/MTQ5NzU5ODMzNTg2NSM3NDcjanBn.jpg","score":10377,"level":35},"level":46,"gender":0,"veri_info":"名媛","profession":"Ta好像忘记写职业了","sex":0,"verified_reason":"","nick":"💚💚娜娜💚💚","third_platform":"0","rank_veri":7,"location":"沈阳市","birth":"1996-01-01","hometown":"辽宁省&沈阳市","portrait":"http://img2.inke.cn/MTQ5ODgxMDMzMDI2OCM1MjcjanBn.jpg","gmutex":0,"id":60861747},"reason":"我娜么美","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"今天夜班","liverank":{"uid":98373928,"dis_score":549,"pic":"http://img2.inke.cn/MTQ5NzU5ODI2MjY2OSMyOTIjanBn.jpg","score":6425,"level":30},"level":43,"gender":0,"veri_info":"名媛","profession":"护士","sex":0,"verified_reason":"","nick":"清茉","third_platform":"0","rank_veri":7,"location":"苏州市","birth":"2015-12-31","hometown":"江苏省&苏州市","portrait":"http://img2.inke.cn/MTQ5ODgwNzQyNDYzMSMzMSNqcGc=.jpg","gmutex":0,"id":98373928},"reason":"穿护士服的茉儿","relation":"null","live_id":"1502456570281050"},{"user":{"emotion":"保密","inke_verify":0,"verified":0,"description":"深情总是留不住 ，偏偏套路得人心。","liverank":{"uid":11419377,"dis_score":2,"pic":"http://img2.inke.cn/MTQ5NzU5ODEwMDI2MCM0OTEjanBn.jpg","score":3692,"level":24},"level":22,"gender":0,"veri_info":"萝莉","profession":"Ta好像忘记写职业了","sex":0,"verified_reason":"","nick":"灵宝、","third_platform":"1","rank_veri":4,"location":"银川市","birth":"1998-01-08","hometown":"银川市","portrait":"http://img2.inke.cn/MTQ5ODcyNDU3NzQzNyM5ODEjanBn.jpg","gmutex":0,"id":11419377},"reason":"软萌妹纸灵宝","relation":"null"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"谢谢大家的支持😎","liverank":{"uid":301149,"dis_score":126,"pic":"http://img2.inke.cn/MTQ5NzU5ODI3NTA4NSMxMTgjanBn.jpg","score":7582,"level":31},"level":58,"gender":1,"veri_info":"高富帅","profession":"自由自在","sex":1,"verified_reason":"","nick":"💯理查哥Richard😎","third_platform":"1","rank_veri":9,"location":"大安區","birth":"2015-01-20","hometown":"台湾省&新竹县","portrait":"http://img2.inke.cn/MTQ5ODEyMzg3NjM1MSM2MjYjanBn.jpg","gmutex":0,"id":301149},"reason":"魅力查理哥","relation":"null","live_id":"1502455462462163"},{"user":{"emotion":"单身","inke_verify":0,"verified":0,"description":"7 billion people, 14 billion faces.\n🎤🎸粤語英語國語彈唱🎼","liverank":{"uid":47849652,"dis_score":388,"pic":"http://img2.inke.cn/MTQ5NzU5ODEzMTg5NCMyOTMjanBn.jpg","score":4228,"level":26},"level":129,"gender":1,"veri_info":"教主","profession":"used car seller","sex":1,"verified_reason":"","nick":"🕴🏻叫我大佬🕴🏿","third_platform":"1","rank_veri":18,"location":"西雅圖","birth":"1986-05-04","hometown":"海外&美国","portrait":"http://img2.inke.cn/MTQ5ODcxMTgwMTk4NCMzMTAjanBn.jpg","gmutex":0,"id":47849652},"reason":"弹唱霸道总裁","relation":"null"}]}]}
 */
