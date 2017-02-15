//
//  ConversitySDKDataBase.m
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKDataBase.h"

@implementation ConversitySDKDataBase

-(void)creatingclientidDB{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    
    //Build the path to keep the database
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    NSLog(@"DB location %@",_databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if([filemgr fileExistsAtPath:_databasePath]==NO){
        const char *dbpath=[_databasePath UTF8String];
        if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
            char *errorMessage;
            const char *sql_statement="CREATE TABLE IF NOT EXISTS SESSION (ID INTEGER PRIMARY KEY AUTOINCREMENT, STATUS TEXT, HN_ENGINE TEXT, XMPP_U TEXT, XMPP_P TEXT, AGENTID TEXT, AGENTNAME TEXT,DEPTNAME TEXT, DEPTEMAIL TEXT, RATINGS TEXT, ONLINE TEXT, MSG_WELCOME TEXT, MSG_HOLD TEXT, MSG_OFFLINE TEXT, MSG_POSTCHAT TEXT, MSG_ABANDON TEXT, WAITTIME_ABNDN TEXT, PORT_XMPP TEXT, SERVER_CHATSESSIONID TEXT, XMPP_S TEXT, AGENTXMPP TEXT UNIQUE, AGENT_ACTIVE TEXT, DEPTID TEXT);CREATE TABLE IF NOT EXISTS MESSAGE (ID INTEGER PRIMARY KEY AUTOINCREMENT, MESSAGE TEXT, DATE TEXT, TIME TEXT, SENDER TEXT, STATUS TEXT, SEENTO TEXT,MESSAGE_SESSION TEXT, MESSAGE_TYPE TEXT, AGENT_NAME TEXT, MID TEXT, ACTION TEXT);";
            if(sqlite3_exec(_DB, sql_statement, NULL,NULL, &errorMessage)!=SQLITE_OK){
//                NSLog(@" create the table");
                
            }
            sqlite3_close(_DB);
        }
        else{
            NSLog(@"Failed to open/create teh table");
        }
    }
 
}

-(void)insertIntoSessionTableJsonObjectDB:(NSDictionary *)jsonObject{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
//    NSLog(@"DB location %@",_databasePath);

    
    
        sqlite3_stmt *statement;
        const char *dbpath=[_databasePath UTF8String];
        if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
    
            NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO SESSION (STATUS, HN_ENGINE, XMPP_U, XMPP_P, AGENTID,AGENTNAME,DEPTNAME, DEPTEMAIL, RATINGS , ONLINE, MSG_WELCOME, MSG_HOLD, MSG_OFFLINE, MSG_POSTCHAT, MSG_ABANDON, WAITTIME_ABNDN, PORT_XMPP, SERVER_CHATSESSIONID, XMPP_S, AGENTXMPP, AGENT_ACTIVE,DEPTID ) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[jsonObject objectForKey:@"status"],[jsonObject objectForKey:@"hn_engine"],[jsonObject objectForKey:@"xmpp_u"],[jsonObject objectForKey:@"xmpp_p"],[jsonObject objectForKey:@"agentId"],[jsonObject objectForKey:@"agentName"],[jsonObject objectForKey:@"deptName"],[jsonObject objectForKey:@"deptEmail"],[jsonObject objectForKey:@"ratings"],[jsonObject objectForKey:@"online"],[jsonObject objectForKey:@"msg_welcome"],[jsonObject objectForKey:@"msg_hold"],[jsonObject objectForKey:@"msg_offline"],[jsonObject objectForKey:@"msg_postchat"],[jsonObject objectForKey:@"msg_abandon"],[jsonObject objectForKey:@"waittime_abndn"],[jsonObject objectForKey:@"port_xmpp"],[jsonObject objectForKey:@"server_chatsessionid"],[jsonObject objectForKey:@"xmpp_s"],[jsonObject objectForKey:@"agentXMPP"],@"ACTIVE",
                                 [jsonObject objectForKey:@"deptId"]];
            const char *insert_statement= [insertSQL UTF8String];
            sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    
            if(sqlite3_step(statement)==SQLITE_DONE){
//                NSLog(@"Added to db ");
    
            }
            else{
    
                NSLog(@"NOT Added to db");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
            
        }
}
-(void)insertIntoMessageTable:(NSArray *)array{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    

    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        
        NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO MESSAGE (MESSAGE, DATE, TIME, SENDER, STATUS, SEENTO,MESSAGE_SESSION, MESSAGE_TYPE, AGENT_NAME, MID, ACTION ) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8],array[9],array[10]];
        const char *insert_statement= [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
//            NSLog(@"Added to db ");
            
        }
        else{
            
            NSLog(@"NOT Added to db");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
}

-(void)updateMid:(NSString *)mid{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    NSLog(@"db path %@",_databasePath);
    
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        
        NSString *insertSQL=[NSString stringWithFormat:@"UPDATE MESSAGE SET STATUS = %@",mid];
        const char *insert_statement= [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
//            NSLog(@"Added to db ");
            
        }
        else{
            
            NSLog(@"NOT Added to db");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
}

-(NSString *)getLoginDataFromSessionTable:(int) inde{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    

    NSString *stringValue;
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
//                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SESSION ORDER BY ID ASC LIMIT 1"];
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
//                        NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                
                NSString *value =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, inde)];
                stringValue=value;

                

                
                //                NSLog(@"db values %@",addressField);
            }
            sqlite3_finalize(statement);
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    return stringValue;
}

-(BOOL) checkingforMidInDataBase:(NSString *)mid csid:(NSString *)csId{
    BOOL value=NO;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    
    NSString *stringValue;
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM MESSAGE WHERE MID = '%@' AND MESSAGE_SESSION = '%@'",mid,csId];
//        NSLog(@"sql query %@",querySQL);
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
//                                    NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
//                                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                
                NSInteger count=sqlite3_column_int(statement, 0);
//                NSLog(@"db count %ld",(long)count);
                if(count==0){
//                    NSLog(@"db count ");

                    value=YES;
                }
                
                
                //                NSLog(@"db values %@",addressField);
            }
            sqlite3_finalize(statement);
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    return value;
}

-(void)insertJidInSessionTable :(NSString *)agentArry  :(NSString *)joinAgentdeptIdsArry{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    //    NSLog(@"DB location %@",_databasePath);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        
        NSString *insertSQL=[NSString stringWithFormat:@"INSERT OR IGNORE INTO SESSION (AGENTXMPP, AGENT_ACTIVE,DEPTID ) VALUES (\"%@\",\"%@\",\"%@\")",agentArry,@"ACTIVE",joinAgentdeptIdsArry];
        const char *insert_statement= [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            //                NSLog(@"Added to db ");
            
        }
        else{
            
            NSLog(@"NOT Added to db");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    
}

-(void)updateJid :(NSString *)agentArry :(NSString *)active :(NSString *)joinAgentdeptIdsArry{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    //    NSLog(@"DB location %@",_databasePath);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        
        NSString *insertSQL=[NSString stringWithFormat:@"UPDATE SESSION SET AGENT_ACTIVE = '%@' , DEPTID = '%@' WHERE AGENTXMPP = '%@'",active,joinAgentdeptIdsArry,agentArry];
        const char *insert_statement= [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
                            NSLog(@"update jid:%@ ",insertSQL);
            
        }
        else{
            
            NSLog(@"NOT Added to db");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    
}

-(NSString *) getLastAgentName{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    
    NSString *stringValue;
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM MESSAGE WHERE SENDER = 'A' ORDER BY ID LIMIT 1"];
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
            //                        NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                
                NSString *value =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                stringValue=value;
                
                
                
                
                //                NSLog(@"db values %@",addressField);
            }
            sqlite3_finalize(statement);
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    return stringValue;
    
}

-(void)deleteAllData :(NSString *)tableName{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    
    NSString *stringValue;
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_exec(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){

        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    
}




-(int )getActiveAgentCount{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    
    sqlite3_stmt *statement;
    int count;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM SESSION WHERE AGENT_ACTIVE = 'ACTIVE'"];
        //        NSLog(@"sql query %@",querySQL);
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
            //                                    NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                
                 count=sqlite3_column_int(statement, 0);
                //                NSLog(@"db count %ld",(long)count);
               
                
                
                //                NSLog(@"db values %@",addressField);
            }
            sqlite3_finalize(statement);
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    return count;
}

-(void)updateAllMessageStatus{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    //    NSLog(@"DB location %@",_databasePath);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        
        NSString *insertSQL=[NSString stringWithFormat:@"UPDATE MESSAGE SET STATUS = 'D'"];
        const char *insert_statement= [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE){
            //                NSLog(@"Added to db ");
            
        }
        else{
            
            NSLog(@"NOT Added to db");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
}

-(NSString *)getAllActiveAgentList{
    NSString *docsDir;
    NSArray *dirPaths;
    
    NSString *valuesss;
    NSMutableString* string1 = [[NSMutableString alloc] init];
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
    
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //                NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SESSION WHERE AGENT_ACTIVE = 'ACTIVE'"];
        //        NSLog(@"sql query %@",querySQL);
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
            //                                    NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                
                NSString *value =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                NSLog(@"jid %@",value);
                NSString *value1 =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 22)];
                valuesss=[NSString stringWithFormat: @"%@|%@||", value,value1];
                [string1 appendString:valuesss];
    
                
            }
            sqlite3_finalize(statement);
            
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    return string1;

}






@end
