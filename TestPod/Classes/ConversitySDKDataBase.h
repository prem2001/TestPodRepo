//
//  ConversitySDKDataBase.h
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ConversitySDKDataBase : NSObject
@property (strong,nonatomic)NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

-(void)creatingclientidDB;

-(void)insertIntoSessionTableJsonObjectDB:(NSDictionary *)jsonObject;

-(void)insertIntoMessageTable:(NSArray *)array;

-(void)updateMid:(NSString *)mid;

-(NSString *)getLoginDataFromSessionTable:(int *)index;

-(BOOL) checkingforMidInDataBase:(NSString *)mid csid:(NSString *)csId;

//[dataBase insertJidInSessionTable :agentArry[i] :joinAgentdeptIdsArry[i]];
//[dataBase updateJid :agentArry[i] :@"ACTIVE" :joinAgentdeptIdsArry[i]]

-(void)insertJidInSessionTable :(NSString *)agentArry :(NSString *) joinAgentdeptIdsArry;

-(void)updateJid :(NSString *)agentArry :(NSString *)active :(NSString *)joinAgentdeptIdsArry;

-(NSString *) getLastAgentName;

-(void)deleteAllData :(NSString *)tableName;

-(int )getActiveAgentCount;

-(void)updateAllMessageStatus;

-(NSString *)getAllActiveAgentList;




@end
