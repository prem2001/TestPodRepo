//
//  ConversitySDKNSDefaults.m
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKNSDefaults.h"

@implementation ConversitySDKNSDefaults{
    NSUserDefaults *defaults;
}
-(void)initMethod{
    defaults = [NSUserDefaults standardUserDefaults];
}

-(void)setChatStartValue:(BOOL)valueForChatStart{
    [self initMethod];
    [defaults setBool:valueForChatStart forKey:@"chatStart"];
    [defaults synchronize];
}
-(BOOL)getChatStartValue{
    [self initMethod];
    BOOL chatStartValue = [defaults boolForKey:@"chatStart"];
    return chatStartValue;
}

-(void)setKey:(NSString*)key{
    [self initMethod];
    [defaults setObject:key forKey:@"key"];
    [defaults synchronize];
}
-(NSString *)getKey{
    [self initMethod];
    NSString *key = [defaults stringForKey:@"key"];
    return key;
}

-(void)setClientSalt:(NSString *)clientSalt{
    [self initMethod];
    [defaults setObject:clientSalt forKey:@"client_salt"];
    [defaults synchronize];
}
-(NSString *)getClientSalt{
    [self initMethod];
    NSString *clientSalt = [defaults stringForKey:@"client_salt"];
    return clientSalt;
}

-(void)setDept:(NSString *)dept{
    [self initMethod];
    [defaults setObject:dept forKey:@"dept"];
    [defaults synchronize];
}
-(NSString *)getDept{
    [self initMethod];
    NSString *dept = [defaults stringForKey:@"dept"];
    return dept;
}

-(void)setChatVisitorName:(NSString *)chatVisitorName{
    [self initMethod];
    [defaults setObject:chatVisitorName forKey:@"chat_visitor_name"];
    [defaults synchronize];
}
-(NSString *)getChatVisitorName{
    [self initMethod];
    NSString *chatVisitorName=[defaults stringForKey:@"chat_visitor_name"];
    return chatVisitorName;
}




-(void)setChatVisitorEmail:(NSString *)chatVisitorEmail{
    [self initMethod];
    [defaults setObject:chatVisitorEmail forKey:@"chat_visitor_email"];
    [defaults synchronize];
}
-(NSString *)getChatVisitorEmail{
    [self initMethod];
    NSString *chatVisitorEmail=[defaults stringForKey:@"chat_visitor_email"];
    return chatVisitorEmail;
}




-(void)setChatVisitorId:(NSString *)chatVisitorId{
    [self initMethod];
    [defaults setObject:chatVisitorId forKey:@"chat_visitor_id"];
    [defaults synchronize];
}
-(NSString *)getChatVisitorId{
    [self initMethod];
    NSString *chatVisitorId=[defaults stringForKey:@"chat_visitor_id"];
    return chatVisitorId;
}




-(void)setInitMessage:(NSString *)initMessage{
    [self initMethod];
    [defaults setObject:initMessage forKey:@"init_message"];
    [defaults synchronize];
}
-(NSString *)getInitMessage{
    [self initMethod];
    NSString *initMessage=[defaults stringForKey:@"init_message"];
    return initMessage;
}





-(void)setOS:(NSString *)os{
    [self initMethod];
    [defaults setObject:os forKey:@"os"];
    [defaults synchronize];
}
-(NSString *)getOS{
    [self initMethod];
    NSString *os=[defaults stringForKey:@"os"];
    return os;
}




-(void)setBubbleBgTx:(NSString *)bubbleBgTx{
    [self initMethod];
    [defaults setObject:bubbleBgTx forKey:@"bubble_bg_tx"];
    [defaults synchronize];
}
-(NSString *)getBubbleBgTx{
    [self initMethod];
    NSString *bubbleBgTx=[defaults stringForKey:@"bubble_bg_tx"];
    return bubbleBgTx;
}


-(void)setBubbleBgRx:(NSString *)bubbleBgRx{
    [self initMethod];
    [defaults setObject:bubbleBgRx forKey:@"bubble_bg_rx"];
    [defaults synchronize];
}
-(NSString *)getBubbleBgRx{
    [self initMethod];
    NSString *bubbleBgRx=[defaults stringForKey:@"bubble_bg_rx"];
    return bubbleBgRx;
}



-(void)setBubbleTxRx:(NSString *)bubbleTxRx{
    [self initMethod];
    [defaults setObject:bubbleTxRx forKey:@"bubble_tx_rx"];
    [defaults synchronize];
}
-(NSString *)getBubbleTxRx{
    [self initMethod];
    NSString *bubbleTxRx=[defaults stringForKey:@"bubble_tx_rx"];
    return bubbleTxRx;
}


-(void)setBubbleTxTx:(NSString *)bubbleTxTx{
    [self initMethod];
    [defaults setObject:bubbleTxTx forKey:@"bubble_tx_tx"];
    [defaults synchronize];
}
-(NSString *)getBubbleTxTx{
    [self initMethod];
    NSString *bubbleTxTx=[defaults stringForKey:@"bubble_tx_tx"];
    return bubbleTxTx;
}



-(void)setNotificationSound:(BOOL)notificationSound{
    [self initMethod];
    [defaults setBool:notificationSound forKey:@"notification_sound"];
    [defaults synchronize];
}
-(BOOL)getNotificationSound{
    [self initMethod];
    BOOL notificationIsActive = [defaults boolForKey:@"notification_sound"];
    return notificationIsActive;
}



-(void)setVibration:(BOOL)vibration{
    [self initMethod];
    [defaults setBool:vibration forKey:@"vibration"];
    [defaults synchronize];
}
-(BOOL)getVibration{
    [self initMethod];
    BOOL vibration = [defaults boolForKey:@"vibration"];
    return vibration;
}

-(void)setAbandonTimmer:(BOOL)abandon{
    [self initMethod];
    [defaults setBool:abandon forKey:@"abnadon"];
    [defaults synchronize];
}
-(BOOL)getAbandonTimmer{
    [self initMethod];
    BOOL abndon = [defaults boolForKey:@"abnadon"];
    return abndon;
}

//-(void)setInitMessageValue:(BOOL)abandon{
//    [self initMethod];
//    [defaults setBool:abandon forKey:@"initMessage"];
//    [defaults synchronize];
//}
//-(BOOL)getInitMessageValue{
//    [self initMethod];
//    BOOL value = [defaults boolForKey:@"initMessage"];
//    return value;
//}



@end
