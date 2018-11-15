//
//  ClientRoomModel.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ClientRoomModel.h"

@implementation ClientRoomModel

-(void) reset
{
    self.roomId = 0;
    self.roomName = @"";
    self.creatorId = 0;
    self.op1 = 0;
    self.op2 = 0;
    self.op3 = 0;
    self.op4 = 0;
    self.op5 = 0;
    self.op6 = 0;
    self.notice1 = @"";
    self.notice2 = @"";
    self.notice3 = @"";
    self.notice4 =@"";
    self.roomGateAddr = @"";
    self.roomMediaAddr = @"";
    self.isConnected = 0;
    self.isJoinRoomFinished = 0;
    self.connectedCount = 0;
    
    [self clearMember];
    [self clearOnMicUser];
}

- (NSMutableArray *)allMemberList{
    if (_allMemberList == nil) {
        _allMemberList = [NSMutableArray array];
    }
    return _allMemberList;
}

-(NSMutableArray*)memberList {
    if(_memberList ==nil) {
        _memberList = [NSMutableArray array];
    }
    return _memberList;
}

-(NSMutableArray*)onMicUserList {
    if(_onMicUserList == nil) {
        _onMicUserList = [NSMutableArray array];
    }
    return _onMicUserList;
}

-(ClientUserModel *)findAllMember:(int)userId{
    ClientUserModel *userObj = nil;
    for(int i=0; i<self.allMemberList.count; i++) {
        ClientUserModel* p =[self.allMemberList objectAtIndex:i];
        if(p.userId == userId) {
            userObj = p;
            break;
        }
    }
    return userObj;
}

-(ClientUserModel*) findMember :(int) userId {
    ClientUserModel* userObj =nil;
    for(int i=0; i<self.memberList.count; i++) {
        ClientUserModel* p =[self.memberList objectAtIndex:i];
        if(p.userId == userId) {
            userObj = p;
            break;
        }
    }
    return userObj;
}

-(ClientUserModel*) findOnMicUser: (int) userId {
    ClientUserModel* userObj = nil;
    for(int i=0; i<self.onMicUserList.count; i++) {
        ClientUserModel* p = [self.onMicUserList objectAtIndex:i];
        if(p.userId == userId) {
            userObj = p;
            break;
        }
    }
    return userObj;
}

-(void)addaAllMember:(ClientUserModel *)userObj{
    [self.allMemberList addObject:userObj];
}

-(void) addMember: (ClientUserModel*) userObj {
    [self.memberList addObject:userObj];
}

-(void) addOnMicUser:(ClientUserModel*) userObj {
    [self.onMicUserList addObject:userObj];
}
-(NSMutableArray *)sortMicUser:(NSMutableArray *)array{
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    for (int index = 0; index < array.count; index++) {
        ClientUserModel *model = [array objectAtIndex:index];
        if (model.micState == 1) {
            [arrayData addObject:model];
            [arr removeObjectAtIndex:index];
        }
    }
    NSArray *array2 = [arrayData sortedArrayUsingComparator:
                       ^NSComparisonResult(ClientUserModel *obj1, ClientUserModel *obj2) {
                           // 先按照麦序
                           NSComparisonResult result = obj1.param_01 < obj2.param_01;
                           return result;
                       }];
    NSMutableArray *array3 = [[NSMutableArray alloc] initWithArray:array2];
    for (int index = 0; index < arr.count; index ++ ) {
        [array3 addObject:[arr objectAtIndex:index]];
    }
    return array3;
}

- (void)delAllMember:(int)userId{
    for(int i=0; i<self.memberList.count; i++) {
        ClientUserModel* p = [self.memberList objectAtIndex:i];
        if(p.userId == userId) {
            [self.memberList removeObjectAtIndex:i];
            break;
        }
    }
}

-(void) delMember: (int) userId {
    for(int i=0; i<self.memberList.count; i++) {
        ClientUserModel* p = [self.memberList objectAtIndex:i];
        if(p.userId == userId) {
            [self.memberList removeObjectAtIndex:i];
            break;
        }
    }
}

-(void) delOnMicUser: (int)userId {
    for(int i=0; i<self.onMicUserList.count; i++) {
        ClientUserModel* p = [self.onMicUserList objectAtIndex:i];
        if(p.userId == userId) {
            [self.onMicUserList removeObjectAtIndex:i];
            break;
        }
    }
}

-(void) clearMember {
    if(_memberList != nil) {
        [_memberList removeAllObjects];
    }
}

-(void) clearOnMicUser {
    if(_onMicUserList != nil) {
        [_onMicUserList removeAllObjects];
    }
}

- (void)clearAllMember{
    if(_allMemberList != nil) {
        [_allMemberList removeAllObjects];
    }
}

@end
