//
//  SendGiftView.m
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
// 送礼物view

#import "SendGiftView.h"
#import "MyControlTool.h"
#import "FlowLayout.h"

#import "DPK_NW_Application.h"
#import "AppDelegate.h"
#import "SelectGiftUserView.h"
#import "SelectGiftCountView.h"


#define GifGetY SCREEN_HEIGHT - 280
#define Collor_Simple RGBA(0, 0, 0, 0.58)
#define Collor_Deep RGBA(0, 0, 0, 0.6)

@implementation SendGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
        self.userId = 0;
        self.giftNum = 1;
    }
    return self;
}

- (void)setSubViews{
    //这里没有设置自己(UIView),意思就是背景透明了
    [self.rechargeView addSubview:self.pageControl];
    [self addSubview:self.giftCollectionView];
    [self addSubview:self.rechargeView];
    //[self.rechargeView addSubview:self.rechargeButton];
    [self.rechargeView addSubview:self.userMoneyLabel];
    [self.rechargeView addSubview:self.senderButton];
    [self.rechargeView addSubview:self.selectUserButton];
    [self.rechargeView addSubview:self.selectNumButton];
}

//弹出礼物
- (void)popShow{
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    //重新计算页数
    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
    self.pageControl.numberOfPages = (dpk_app.giftArray.count +7)/8;
}

//更新用户金币信息
- (void)updateUserMoney:(long long)nk NB:(long long)nb {
    NSString* strNK=@"";
    NSString* strNB=@"";
    if(nk >=1000000) {
        nk = nk/10000;
        strNK = [NSString stringWithFormat:@"金币:%lld万", nk];
    }
    else {
        strNK = [NSString stringWithFormat:@"金币:%lld", nk];
    }
    //
    if(nb >=1000000) {
        nb = nb/10000;
        strNB = [NSString stringWithFormat:@"积分:%lld万", nb];
    }
    else {
        strNB =[NSString stringWithFormat:@"积分:%lld", nb];
    }
    
    NSString* strText = [NSString stringWithFormat:@"%@  %@", strNK, strNB];
    self.userMoneyLabel.text = strText;
}

//更新选中用户
- (void)addUser:(int)userId UserName:(NSString*)userName
{
    self.userId = userId;
    [self.selectUserButton setTitle:[NSString stringWithFormat:@"赠送:%@",userName] forState:UIControlStateNormal];
}

//删除用户
- (void)delUser:(int)userId
{
    self.userId = 0;
    [self.selectUserButton setTitle:@"赠送:请选择对象" forState:UIControlStateNormal];
}

//点击上方灰色区域移除视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    //手指点击的Y位置
    if ( point.y < GifGetY) {
        if (self.grayClick) {
            self.grayClick();
        }
        [self removeFromSuperview];  //从superView移除,这里其实就是从keyWindow移除?
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}

#pragma
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //数量
    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
    return dpk_app.giftArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegisterId" forIndexPath:indexPath];
    DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
    
    //测试数据,testcode
    //for(int i=0; i<dpk_app.giftArray.count; i++) {
    //    ClientGiftModel* model = [dpk_app.giftArray objectAtIndex:i];
    //    NSLog(@"icon:%@", model.icon);
    //}

    
    if(dpk_app.giftArray.count >0 && indexPath.row < dpk_app.giftArray.count)
    {
        //设置礼物信息
        ClientGiftModel* model = [dpk_app.giftArray objectAtIndex:indexPath.row];
        [cell setGiftInfo:model.giftId GiftImage:model.icon GiftName:model.giftName GiftPrice:model.coins];

        if (_reuse == indexPath.row) {
            cell.hitButton.selected = YES;
        } else {
            cell.hitButton.selected = NO;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftViewCell *cell = (GiftViewCell *)[self.giftCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell.hitButton.selected) {
        for (UIView *view in self.giftCollectionView.subviews) {
            //遍历所有cell，重置为未连击状态
            if ([view isKindOfClass:[GiftViewCell class]]) {
                GiftViewCell *cell = (GiftViewCell *)view;
                cell.hitButton.selected = NO;
            }
        }
        cell.hitButton.selected = YES;
        //可以发送礼物
        self.senderButton.backgroundColor = RGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = indexPath.row;
    } else {
        cell.hitButton.selected = NO;
        //未有选中，禁用发送按钮
        self.senderButton.backgroundColor = [UIColor grayColor];
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}


#pragma 加载
//滑动
- (UICollectionView *)giftCollectionView{
    if (!_giftCollectionView) {
        FlowLayout *flowLay = [[FlowLayout alloc]init];
        flowLay.minimumLineSpacing = 0;
        flowLay.minimumInteritemSpacing = 0;
        flowLay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLay.itemSize = CGSizeMake(SCREEN_WIDTH/4, 110);  //item的尺寸
        
        //listView的尺寸
        _giftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, GifGetY, SCREEN_WIDTH, 220) collectionViewLayout:flowLay];
        //_giftCollectionView.backgroundColor = RGBA(0, 0, 0, 0.8);
        _giftCollectionView.backgroundColor = [UIColor darkGrayColor];
        _giftCollectionView.bounces = NO;
        _giftCollectionView.delegate = self;
        _giftCollectionView.dataSource = self;
        _giftCollectionView.pagingEnabled = YES;
        
        [_giftCollectionView registerClass:[GiftViewCell class] forCellWithReuseIdentifier:@"RegisterId"];
    }
    return _giftCollectionView;
}

//底部工具栏(充值按钮，发送按钮)
- (UIView *)rechargeView{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 60, SCREEN_WIDTH, 60)];
        //_rechargeView.backgroundColor = RGBA(0, 0, 0, 0.8);
        _rechargeView.backgroundColor = [UIColor darkGrayColor];
    }
    return _rechargeView;
}

//充值按钮
//- (UIButton *)rechargeButton{
//    if (!_rechargeButton) {
//        _rechargeButton = [MyControlTool buttonWithText:@"充值" textColor:RGB(249, 179, 61) font:17 tag:0 frame:CGRectMake(0, 0, 100, 60) clickBlock:^(id x) {
//        }];
//    }
//    return _rechargeButton;
//}

//用户金币/记分
-(UILabel*)userMoneyLabel {
    if(!_userMoneyLabel) {
        _userMoneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 36, SCREEN_WIDTH- 80, 14)];
        _userMoneyLabel.font =[UIFont systemFontOfSize:13];
        _userMoneyLabel.textColor = RGB(255, 255, 255);
        _userMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _userMoneyLabel.text = @"金币:0 积分:0";
        //_userMoneyLabel.layer.borderColor = [UIColor colorWithRed:0/255.0f green:255/255.0f blue:0/255.0f alpha:1.0f].CGColor;
        //_userMoneyLabel.layer.borderWidth = 1.0f;
    }
    return _userMoneyLabel;
}

//发送礼物按钮
- (UIButton *)senderButton{
    if (!_senderButton) {
        _senderButton = [MyControlTool buttonWithText:@"发送" textColor:[UIColor whiteColor] selectTextColor:[UIColor whiteColor] font:17 tag:0 frame:CGRectMake(SCREEN_WIDTH - 70, 17, 60, 26) clickBlock:^(id x) {
            if (self.giftClick) {
                self.giftClick(_reuse);
            }
        }];
        _senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _senderButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 45, 40);
        _senderButton.layer.cornerRadius = 2; //圆角
        _senderButton.layer.masksToBounds = YES;
        [_senderButton setBackgroundColor:RGB(23, 23, 23)];
    }
    return _senderButton;
}

//选择赠送对象按钮
-(UIButton *)selectUserButton {
    if(!_selectUserButton) {
        CGRect frame = CGRectMake(0, 2, 130, 28);
        _selectUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectUserButton.frame = frame;
        _selectUserButton.backgroundColor = [UIColor clearColor];
        _selectUserButton.tag = 2000;
        
        _selectUserButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _selectUserButton.titleLabel.textColor = [UIColor whiteColor];
        _selectUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _selectUserButton.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
        [_selectUserButton setTitle:@"赠送:请选择对象" forState:UIControlStateNormal];
        [_selectUserButton addTarget:self action:@selector(selectUserBtnClicked:) forControlEvents:UIControlEventTouchUpInside ];
    }
    return _selectUserButton;
}

//选择赠送数量按钮
-(UIButton*)selectNumButton {
    if(!_selectNumButton) {
        CGRect frame = CGRectMake(SCREEN_WIDTH - 140, 2, 90, 28);
        _selectNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectNumButton.frame = frame;
        _selectNumButton.backgroundColor = [UIColor clearColor];
        _selectNumButton.tag = 2000;
        _selectNumButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _selectNumButton.titleLabel.textColor = [UIColor whiteColor];
        _selectNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _selectNumButton.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
        [_selectNumButton setTitle:@"数量:1" forState:UIControlStateNormal];
        [_selectNumButton addTarget:self action:@selector(selectNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside ];
        
    }
    return _selectNumButton;
}

//分页（放在底部工具栏里面)
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 5, 40, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 3;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    return _pageControl;
}

//礼物图片
//- (NSMutableArray *)dataArr{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//        //创建默认礼物
//        for (NSInteger i = 0; i < 24; i++) {
//            NSString *imagePath=[NSString stringWithFormat:@"yipitiezhi0%zd",i + 1];
//            [_dataArr addObject:imagePath];
//        }
//    }
//    return _dataArr;
//}

//选择赠送用户
-(void) selectUserBtnClicked:(id)sender {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    SelectGiftUserView* view = [[SelectGiftUserView alloc] initWithFrame:frame];
    
    view.userArray = self.roomObj.memberList;
    WEAKSELF;
    [view setUserClick:^(NSInteger userId, NSString* userAlias) {
        weakSelf.userId = userId;
        [self.selectUserButton setTitle:[NSString stringWithFormat:@"赠送:%@", userAlias] forState:UIControlStateNormal ];
    }];
    [view popShow];
}

//选择赠送数量
-(void) selectNumBtnClicked:(id)sender {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    SelectGiftCountView* view = [[SelectGiftCountView alloc] initWithFrame:frame];
    
    WEAKSELF;
    [view setNumClick:^(NSInteger giftNum) {
        weakSelf.giftNum = giftNum;
        [self.selectNumButton setTitle:[NSString stringWithFormat:@"数量:%d", giftNum] forState:UIControlStateNormal ];
    }];
    [view popShow];

}





@end
