//
//  ConversitySDKNSDefaults.h
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversitySDKNSDefaults : NSObject

-(void)setChatStartValue:(BOOL)valueForChatStart;
-(BOOL)getChatStartValue;

-(void)setKey:(NSString *)key;
-(NSString *)getKey;

-(void)setClientSalt:(NSString *)clientSalt;
-(NSString *)getClientSalt;

-(void)setDept:(NSString *)dept;
-(NSString *)getDept;

-(void)setChatVisitorName:(NSString *)chatVisitorName;
-(NSString *)getChatVisitorName;

-(void)setChatVisitorEmail:(NSString *)chatVisitorEmail;
-(NSString *)getChatVisitorEmail;

-(void)setChatVisitorId:(NSString *)chatVisitorId;
-(NSString *)getChatVisitorId;

-(void)setInitMessage:(NSString *)initMessage;
-(NSString *)getInitMessage;

-(void)setOS:(NSString *)os;
-(NSString *)getOS;

-(void)setBubbleBgTx:(NSString *)bubbleBgTx;
-(NSString *)getBubbleBgTx;

-(void)setBubbleBgRx:(NSString *)bubbleBgRx;
-(NSString *)getBubbleBgRx;

-(void)setBubbleTxRx:(NSString *)bubbleTxRx;
-(NSString *)getBubbleTxRx;

-(void)setBubbleTxTx:(NSString *)bubbleTxTx;
-(NSString *)getBubbleTxTx;

-(void)setNotificationSound:(BOOL)notificationSound;
-(BOOL)getNotificationSound;

-(void)setVibration:(BOOL)vibration;
-(BOOL)getVibration;

-(void)setAbandonTimmer:(BOOL)abandon;
-(BOOL)getAbandonTimmer;

//-(void)setInitMessageValue:(BOOL)abandon;
//-(BOOL)getInitMessageValue;



@end
