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

#import "GTGiftListModel.h"
#import "GTGiftGroupModel.h"

#define GifGetY SCREEN_HEIGHT - 285
#define Collor_Simple RGBA(0, 0, 0, 0.58)
#define Collor_Deep RGBA(0, 0, 0, 0.6)

#define typeCount 6
@interface SendGiftView()
@property (nonatomic, strong) UIView *topClassifyView;//顶部分类栏
@property (nonatomic, strong)NSArray *arrGroupTitle;
@property (nonatomic, strong)UIButton *btnSelect;
@property (nonatomic, strong)NSArray *arrayCollect;
@property (nonatomic, strong)NSMutableArray *arrayAll;

@end

@implementation SendGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self arrayAll];
        _arrayCollect = [NSArray arrayWithArray:[_arrayAll objectAtIndex:0]];
        [self setSubViews];
        self.userId = 0;
        self.giftNum = 1;
        self.userName = @"请选择赠送礼物的对象";
        
    }
    return self;
}

- (void)setSubViews{
    //这里没有设置自己(UIView),意思就是背景透明了
    self.pageControl.numberOfPages = (_arrayCollect.count +7)/8;
    [self.rechargeView addSubview:self.pageControl];
    [self addSubview:self.giftCollectionView];
    [self addSubview:self.rechargeView];
    
    //[self.rechargeView addSubview:self.rechargeButton];
    [self.rechargeView addSubview:self.userMoneyLabel];
    [self.rechargeView addSubview:self.senderButton];
    [self.rechargeView addSubview:self.selectUserButton];
//    [self.rechargeView addSubview:self.selectNumButton];
    [self addSubview:self.topClassifyView];
    
}

//弹出礼物
- (void)popShow{
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
//    //重新计算页数
//    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
//    self.pageControl.numberOfPages = (dpk_app.giftList.count +7)/8;
}

-(void)hide {
    [self removeFromSuperview];
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
    //    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
    return _arrayCollect.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegisterId" forIndexPath:indexPath];

    if(_arrayCollect.count>0 && indexPath.row < _arrayCollect.count)
    {
//        NSLog(@"_arrayCollect == %@",_arrayCollect);
        //设置礼物信息
        GTGiftListModel* model = [_arrayCollect objectAtIndex:indexPath.row];
//        NSLog(@"pic == %@",model.pic_thumb);
        [cell setGiftInfo:model.giftId GiftImage:model.pic_original GiftName:model.name GiftPrice:model.price];
        [cell.hitButton setTitle:[NSString stringWithFormat:@"%d",model.price] forState:UIControlStateNormal];
        if (_reuse == indexPath.row) {
            cell.hitButton.hidden = NO;
        } else {
            cell.hitButton.hidden = YES;
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
                cell.hitButton.hidden = YES;
            }
        }
        cell.hitButton.hidden = NO;
        _giftNum ++;
        [cell.hitButton setTitle:[NSString stringWithFormat:@"X%d",_giftNum] forState:UIControlStateNormal];
        //可以发送礼物
//        self.senderButton.backgroundColor = RGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = indexPath.row;
        
    } else {
        cell.hitButton.hidden = YES;
        //未有选中，禁用发送按钮
//        self.senderButton.backgroundColor = [UIColor grayColor];
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
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
        _giftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, GifGetY+35, SCREEN_WIDTH, 220) collectionViewLayout:flowLay];
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

- (NSMutableArray *)arrayAll{
    _arrayAll = [NSMutableArray array];
    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
    NSArray *arrayGroup = [NSArray arrayWithArray: dpk_app.giftGroup];
    NSArray *arrayList = [NSArray arrayWithArray: dpk_app.giftList];
    if (arrayGroup.count > 0 && arrayList.count > 0) {
        for (int count = 0; count < typeCount ; count ++) {
            NSMutableArray *arrSame = [NSMutableArray array];
            GTGiftGroupModel*model = [arrayGroup objectAtIndex:count];
            for (int index = 0; index < model.list.count; index ++) {
                //        NSLog(@"%@",model.list[index]);
                for (int x = 0; x < arrayList.count; x++) {
                    GTGiftListModel *listModel = [arrayList objectAtIndex:x];
                    //            NSLog(@"group == %@",[model.list objectAtIndex:index]);
                    //            NSLog(@"list == %d",listModel.giftId);
                    if ([[model.list objectAtIndex:index]intValue] == listModel.giftId) {
                        [arrSame addObject:listModel];
                    }
                }
            }
            NSLog(@"arrSame == %lu",(unsigned long)arrSame.count);
            //        [_array addObject:arrSame];
            [_arrayAll insertObject:arrSame atIndex:count];
        }
//        arrData = _array;
//        [arrData writeToFile:plistPath atomically:YES];
//        NSString *plistPath = [[NSBundle mainBundle]pathForResource:APP_info ofType:@"plist"];
//        NSMutableArray *arr = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:GIFT_LIST];
//        NSLog(@"arr == %@",arr);
    }
    return _arrayAll;
}

//底部工具栏(充值按钮，发送按钮)
- (UIView *)rechargeView{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 46, SCREEN_WIDTH, 46)];
        _rechargeView.backgroundColor = RGBA(0, 0, 0, 0.8);
//        _rechargeView.backgroundColor = [UIColor grayColor];
    }
    return _rechargeView;
}


/**
 分类

 @return <#return value description#>
 */
- (UIView *)topClassifyView{
    if (!_topClassifyView) {
        _topClassifyView = [[UIView alloc] initWithFrame:CGRectMake(0, GifGetY, SCREEN_WIDTH, 35)];
        _topClassifyView.backgroundColor = RGBA(50, 50, 50, 0.8);
        CGFloat btnWidth = SCREEN_WIDTH/typeCount;
        DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
        for (int index = 0; index < typeCount; index ++) {
            UIButton *btnType = [[UIButton alloc] initWithFrame:CGRectMake(index*btnWidth, 0, btnWidth, 35)];
            [btnType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnType setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
            [btnType.titleLabel setFont:[UIFont systemFontOfSize:13]];
            GTGiftGroupModel* model = [dpk_app.giftGroup objectAtIndex:index];
            [btnType setTitle:model.title forState:UIControlStateNormal];
            [btnType setTag:1000+index];
            [btnType addTarget:self action:@selector(btnTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_topClassifyView addSubview:btnType];
        }
        UIButton *btn = (UIButton *)[_topClassifyView viewWithTag:1000];
        [btn setSelected:YES];
    }
    return _topClassifyView;
}

- (void)btnTypeClicked: (UIButton *)btnType{
    if (_arrayCollect.count > 0) {
        _arrayCollect = nil;
    }
    for (int index = 0; index < 6; index ++) {
        UIButton *btn = (UIButton *)[[btnType superview]viewWithTag:1000 + index];
        [btn setSelected:NO];
    }
    UIButton *button = btnType;
    [button setSelected:YES];
    _arrayCollect = [NSArray arrayWithArray:[_arrayAll objectAtIndex:btnType.tag - 1000]];
    NSLog(@"count == %lu",(unsigned long)_arrayCollect.count);
    self.pageControl.numberOfPages = (_arrayCollect.count +7)/8;
    [self.rechargeView reloadInputViews];
    [self.giftCollectionView reloadData];
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
        _userMoneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH- 80, 14)];
        _userMoneyLabel.font =[UIFont systemFontOfSize:12];
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
        _senderButton = [MyControlTool buttonWithText:@"发送" textColor:[UIColor whiteColor] selectTextColor:[UIColor whiteColor] font:17 tag:0 frame:CGRectMake(SCREEN_WIDTH - 78, 10, 66, 36) clickBlock:^(id x) {
            if (self.giftClick) {
                self.giftClick(_reuse);
                [self hide];
            }
        }];
        _senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _senderButton.layer.cornerRadius = 2; //圆角
        _senderButton.layer.masksToBounds = YES;
        [_senderButton setBackgroundColor:MAIN_COLOR];
    }
    return _senderButton;
}

//选择赠送对象按钮
-(UIButton *)selectUserButton {
    if(!_selectUserButton) {
        CGRect frame = CGRectMake(12, 28, 230, 22);
        _selectUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectUserButton.frame = frame;
        _selectUserButton.backgroundColor = [UIColor clearColor];
        _selectUserButton.tag = 2000;
        
        _selectUserButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _selectUserButton.titleLabel.textColor = MAIN_COLOR;
        _selectUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _selectUserButton.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
        [_selectUserButton setTitle:[NSString stringWithFormat:@"送给:%@",_userName] forState:UIControlStateNormal];
        [_selectUserButton addTarget:self action:@selector(selectUserBtnClicked:) forControlEvents:UIControlEventTouchUpInside ];
    }
    return _selectUserButton;
}

//- (void)selectUserBtnClicked: (UIButton *)button{
//    if (self.selectGiftUser) {
//        self.selectGiftUser();
//        [self hide];
//    }
//}

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
        weakSelf.userId = (int)userId;
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
