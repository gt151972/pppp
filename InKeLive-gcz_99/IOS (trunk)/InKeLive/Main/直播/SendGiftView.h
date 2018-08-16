//
//  SendGiftView.h
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftViewCell.h"

#import "ClientRoomModel.h"

//礼物面板(礼物列表)

@interface SendGiftView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIPageControl *_pageControl;
    //礼物标记
    NSInteger _reuse;
}

//房间对象
@property (nonatomic, weak)ClientRoomModel* roomObj;
//当前选择用户ID
@property (nonatomic, assign)int userId;
//当前选择礼物数量
@property (nonatomic, assign)int giftNum;
//礼物列表
@property (nonatomic,strong)UICollectionView *giftCollectionView;
//底部充值  发送 pane
@property (nonatomic,strong)UIView *rechargeView;
//充值按钮
//@property (nonatomic,strong)UIButton *rechargeButton;
@property(nonatomic, strong)UILabel *userMoneyLabel;
//发送礼物按钮
@property (nonatomic,strong)UIButton *senderButton;
//赠送对象按钮
@property( nonatomic, strong)UIButton* selectUserButton;
//赠送数量按钮
@property( nonatomic, strong)UIButton* selectNumButton;
//页面指示器
@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,copy)void (^giftClick)(NSInteger tag);
@property (nonatomic,copy)void (^grayClick)();

//@property (nonatomic,strong)NSMutableArray *dataArr;  //数据

- (void)popShow;
- (void)updateUserMoney:(long long)nk NB:(long long)nb;
- (void)addUser:(int)userId UserName:(NSString*)userName;
- (void)delUser:(int)userId;

@end
