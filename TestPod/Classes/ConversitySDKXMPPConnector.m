//
//  ConversitySDKXMPPConnector.m
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKXMPPConnector.h"
#import "ConversitySDKDataBase.h"
#import "MyViewController.h"
#import "ConversitySDKUtility.h"
#import "ConversitySDKNSDefaults.h"
#import "ConversitySDKPing.h"
#import "ConversitySDKMessageScheduler.h"



NSString *docsDir;
NSArray *dirPaths;
NSTimer *timer;





@implementation ConversitySDKXMPPConnector{
    XMPPStream *xmppStream;
    ConversitySDKDataBase *dataBase;
    NSString *curElement;
    NSMutableArray *politicians;
    BOOL isCongressNumbers;
    NSString *messageBody;
    NSString *messageFrom;

    
}
static BOOL sechduler;



-(void)connectToXMPP{
    //    NSLog(@"connectToXMPP");
    dataBase =[[ConversitySDKDataBase alloc]init];
    
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSString *newHost = [[dataBase getLoginDataFromSessionTable: 2] stringByReplacingOccurrencesOfString: @"https://" withString:@""];
    xmppStream.hostName = newHost;
    //    NSLog(@"HOST %@",newHost);
    UInt16 portNumber = [[[[NSNumberFormatter alloc]init]  numberFromString:[dataBase getLoginDataFromSessionTable: 17]] unsignedShortValue];
    //    NSLog(@"PORT %hu",portNumber);
    
    xmppStream.hostPort = portNumber;
    [xmppStream setStartTLSPolicy:true];
    
    NSString *username = [dataBase getLoginDataFromSessionTable: 3];
    //    NSLog(@"PORT %@",username);
    
    [xmppStream setMyJID:[XMPPJID jidWithString:username]];
    
    NSError *error = nil;
    [xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    //this method will excute when connect is connected to server
    //    - (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    //        NSLog(@"XMPPERROR1 %@",error);
    
}


-(void)connectToXMPP2{
    //    NSLog(@"connectToXMPP2");
    NSError *error=nil;
    [xmppStream authenticateWithPassword:[dataBase getLoginDataFromSessionTable: 4] error:&error];
    //    NSLog(@"XMPPERROR2 %@",error);
    [xmppStream sendElement:[XMPPPresence presence]];
    
    
    
}
-(void)sendMessageToServer:(NSString *)messageText mid:(NSString *)mid senders:(int )sender cursor:(sqlite3_stmt *)cur a:(NSString *)agentid d:(NSString *)deptid{
    ConversitySDKNSDefaults *defaults=[[ConversitySDKNSDefaults alloc]init];
    switch (sender) {
        case 1:
            //to me
        {
            NSString *action;
            NSString *a =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(cur, 11)];
            if([a isEqualToString:@"6"]||[a isEqualToString:@"1"]||[a isEqualToString:@"2"]){
                action=@"1";
            }else{
                action=@"V";
            }
            //MY LOOP BACK MESAGE
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:messageText];
            
            NSXMLElement *conversity = [NSXMLElement elementWithName:@"conversity"];
            [conversity addAttributeWithName:@"xmlns" stringValue:@"my:custom:conversity"];
            [conversity addAttributeWithName:@"mid" stringValue:mid];
            [conversity addAttributeWithName:@"deptID" stringValue:@"5"];
            [conversity addAttributeWithName:@"visitorName" stringValue:@"prem visitor"];
            [conversity addAttributeWithName:@"csId" stringValue:[dataBase getLoginDataFromSessionTable: 18]];
            [conversity addAttributeWithName:@"cId" stringValue:[defaults getKey]];
            [conversity addAttributeWithName:@"action" stringValue:action];
            
            
            
            
            
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            //        [message addAttributeWithName:@"to" stringValue:@"sandeep@conversity.net"];
            [message addAttributeWithName:@"to" stringValue:[dataBase getLoginDataFromSessionTable: 3]];
            [message addChild:conversity];
            [message addChild:body];
            
            [xmppStream sendElement:message];
            NSLog(@"SENTME: %@ \n\n",message);
        }
            break;
            
        case 2:{
            //TO SERVER
            NSString *a =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(cur, 11)];
            
//            NSLog(@"action %@",a);
          NSString *action;
            
            char  *c=[a UTF8String];
            char actions = *c;
            switch (actions) {
                case '1':
                    action=@"1";
//                    NSLog(@"visitor name %@",[defaults getChatVisitorName]);
                    messageText=[NSString stringWithFormat: @"Chat ended by %@.", [defaults getChatVisitorName]];
                    //                    messageText=@"Chat ended by me";
                    
                    break;
                case '2':
                    action=@"2";
                    messageText=@"Chat abandoned.";
                    break;
                case '6':
                    action=@"6";
                    messageText=[NSString stringWithFormat: @"%@ has left chat.", [defaults getChatVisitorName]];
                    break;
                case 'V':
                    action=@"V";
                    break;
                    
                default:
                    break;
            }
            
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:messageText];
            
            NSXMLElement *conversity = [NSXMLElement elementWithName:@"conversity"];
            [conversity addAttributeWithName:@"mid" stringValue:mid];
            [conversity addAttributeWithName:@"deptID" stringValue:deptid];
            [conversity addAttributeWithName:@"visitorName" stringValue:@"prem visitor"];
            [conversity addAttributeWithName:@"csId" stringValue:[dataBase getLoginDataFromSessionTable: 18]];
            [conversity addAttributeWithName:@"cId" stringValue:[defaults getKey]];
            [conversity addAttributeWithName:@"action" stringValue:action];
            
            
            
            
            
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            [message addAttributeWithName:@"to" stringValue:agentid];
            [message addChild:conversity];
            [message addChild:body];
            
            [xmppStream sendElement:message];
            NSLog(@"SENTSERVER: %@ \n\n",message);
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}
- (void) doUpdate
{
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
//    dispatch_async(queue, ^{
//        NSLog(@"1111");
//        // Perform async operation
//        // Call your method/function here
//        // Example:
//        // NSString *result = [anObject calculateSomething];
//        
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"2222");
//
//            // Update UI
//            // Example:
//            // self.myLabel.text = result;
//            
//            
//            if (!timer) {
//                timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
//                                                         target:self
//                                                       selector:@selector(_timerFired:)
//                                                       userInfo:nil
//                                                        repeats:TRUE];
//            }
//        });
//    });
//    
    
    
    
    
    
    
    
    
    
    //    NSLog(@"doUpdate");
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                 target:self
                                               selector:@selector(_timerFired:)
                                               userInfo:nil
                                                repeats:TRUE];
    }
    
}
- (void)_timerFired:(NSTimer *)timer {
//    NSLog(@"timmer run");
    ConversitySDKPing *ping=[[ConversitySDKPing alloc]init];
    if([ping getInternateStatus]){
    [self startTask];
    }
}

-(void)startTask{
    //        NSLog(@"startTask");
    [self connectToXMPP2];
    //        NSLog(@"isConnecting: %hhd", [xmppStream isConnecting]);
    //                        NSLog(@"isConnected: %hhd", [xmppStream isConnected]);
    //                        NSLog(@"isAuthenticating: %hhd", [xmppStream isAuthenticating]);
    //                        NSLog(@"isAuthenticated: %hhd", [xmppStream isAuthenticated]);
    //
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    //Build the path to keep the database
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    //    NSLog(@"path %@",_databasePath);
    
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM MESSAGE WHERE STATUS ='P' ORDER BY ID ASC "];
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                //get 1st index value from the sqlite.db
                NSString *message =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *mid =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                
                [self sendMessageToServer:message mid:mid senders:1 cursor:statement a:@"mujid" d:@"mydeptid"];
                
//                NSLog(@"---- %@",[dataBase getAllActiveAgentList]);
                NSArray *agentjid=[[dataBase getAllActiveAgentList] componentsSeparatedByString:@"||"];
//                NSLog(@"----%lu",(unsigned long)[agentjid count]);
                for (int i=0; i<[agentjid count]-1; i++) {
                    NSArray *agentJi=[agentjid[i] componentsSeparatedByString:@"|"];
                    NSString *agentJid=agentJi[0];
                    NSString *deptid=agentJi[1];
                    [self sendMessageToServer:message mid:mid senders:2 cursor:statement a:agentJid d:deptid];

                }

            
                
                
            
                

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                //                NSLog(@"db values %@",message);
            }
            sqlite3_finalize(statement);
        }
        
        //        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    else{
        NSLog(@"DB NOT OPEN");
    }
    
    
    
}

-(void)stopXMPP{
    //    NSLog(@"stopXMPP");
    [xmppStream disconnect];
    [timer invalidate];
    timer = nil;
    
    
    
    
}



-(void)startXMPPService{
    //            NSLog(@"startXMPPService");
    [self connectToXMPP];
    [self doUpdate];
}
-(void)stopXMPPService{
    //    NSLog(@"stopXMPPService");
    [self stopXMPP];
}

//messagereceivehandler
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    //    NSLog(@"message receive");
    
    NSLog(@"RECEIVE %@ \n\n",message);
    ConversitySDKNSDefaults *defaults=[[ConversitySDKNSDefaults alloc]init];
    if(![defaults getChatStartValue]){
        [defaults setChatStartValue:YES];
    }
    
    
    NSString *stringFromUTFString = [[NSString alloc] initWithFormat:@"%@", message];
    //    NSLog(@"jhjhjhjh %@",stringFromUTFString);
    messageBody = [[message elementForName:@"body"] stringValue];
    messageFrom = [[message elementForName:@"from"] stringValue];
//    NSLog(@"mesage body : %@",[[message elementForName:@"body"] stringValue]);


    
    //allocate memory for parser as well as
    NSXMLParser *xmlParserObject;
    NSData *xmlData;
    NSData* data=[stringFromUTFString dataUsingEncoding:NSUTF8StringEncoding];
    
    xmlParserObject =[[NSXMLParser alloc]initWithData:data];
    [xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [xmlParserObject parse];
    
    
    
    
    
    
    
    
    
    
    
    

}



- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"message"]){
        messageFrom=[attributeDict valueForKey:@"from"];
//        NSLog(@"frommm %@",[attributeDict valueForKey:@"from"]);
    }


    
    
    
    
    
    
    
    
    if( [elementName isEqualToString:@"conversity"])
    {
        if([[attributeDict valueForKey:@"csId"]isEqualToString:[dataBase getLoginDataFromSessionTable: 18]]){
            //            NSLog(@"action %@",[attributeDict valueForKey:@"action"]);
            
            
            NSString *mid=[attributeDict valueForKey:@"mid"];
            NSString *csId=[attributeDict valueForKey:@"csId"];
            NSString *agentName=[attributeDict valueForKey:@"visitorName"];
            char  *c=[[attributeDict valueForKey:@"action"] UTF8String];
            char action = *c;
            
            ConversitySDKNSDefaults *defaults=[[ConversitySDKNSDefaults alloc]init];
            
            
            switch(action)
            {
                case 'A' :
                    //checking of mid
                    //                    NSLog(@"messagebody %@",messageBody);
                    if([dataBase checkingforMidInDataBase:mid csid:csId]){
                        //    NSLog(@"RECEIVE message body %@",messageBody);
                        ConversitySDKDataBase *database=[[ConversitySDKDataBase alloc]init];
                        NSArray *array = @[messageBody, @"Tutorials", [ConversitySDKUtility getCurrentTime], @"A", @"D", @"Tutorials", @"Tutorials", @"Tutorials", agentName, mid, @"Tutorials"];
                        
                        [database insertIntoMessageTable:array];
                        
                        NSArray *sendObjetWithNoti=@[messageBody,agentName];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:sendObjetWithNoti];
                        
                        
                    }else{
                        NSLog(@"mid is already exit not save in DB");
                    }
                
                   
                    break;
                    
                case '5':{
                    
                    NSArray *agentNameArray=[agentName componentsSeparatedByString:@"||"];
                    NSString *parentAgentName=agentNameArray[0];
                    NSString *joinedAgentJids=agentNameArray[1];
                    NSString *joinedAgentDeptId=agentNameArray[2];
                    
                    NSArray *joinAgentdeptIdsArry=[joinedAgentDeptId componentsSeparatedByString:@","];
                    NSArray *agentArry=[joinedAgentJids componentsSeparatedByString:@","];
                    for(int i=0;i<[agentArry count];i++){
                        [dataBase insertJidInSessionTable :agentArry[i] :joinAgentdeptIdsArry[i]];
                        [dataBase updateJid :agentArry[i] :@"ACTIVE" :joinAgentdeptIdsArry[i]];
                    }
                    [dataBase updateJid:[dataBase getLoginDataFromSessionTable:3] :@"INACTIVE" :@"mydeptId"];
                    NSArray *array = @[messageBody, @"Tutorials", [ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", [dataBase getLoginDataFromSessionTable:18], @"text",parentAgentName ,mid, @"V"];
                    [dataBase insertIntoMessageTable:array];
                    NSArray *arrywithnoti=@[messageBody,parentAgentName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:arrywithnoti];
                    
                    
                }
                    
                    
                    break;
                case '6':
                {
//                    NSLog(@"leving jid %@",messageFrom);
                    NSArray *leaveAgent=[messageFrom componentsSeparatedByString:@"/"];
//                    NSLog(@"leving jid %@",leaveAgent[0]);
                    [dataBase updateJid:leaveAgent[0] :@"INACTIVE" :@"inactiveDeptId"];
                    
                    NSArray *array = @[messageBody, @"Tutorials", [ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", [dataBase getLoginDataFromSessionTable:18], @"text",agentName ,mid, @"V"];
                    [dataBase insertIntoMessageTable:array];
                    NSArray *arrywithnoti=@[messageBody,agentName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:arrywithnoti];
                    
                }
                    break;
                
                case '1':
                case '2':
                {
//                    NSLog(@"action 1 block %@",[dataBase getLoginDataFromSessionTable:14]);
                    
                    NSString *postChatMessage1=[dataBase getLoginDataFromSessionTable:14];
                    NSString *getLastAgentName=[dataBase getLastAgentName];
                    
                    NSArray *array = @[postChatMessage1, @"Tutorials", [ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", [dataBase getLoginDataFromSessionTable:18], @"text",getLastAgentName ,@"mid", @"V"];
                    [dataBase insertIntoMessageTable:array];
                    NSArray *arrywithnoti=@[postChatMessage1,getLastAgentName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:arrywithnoti];
                    [defaults setChatStartValue:NO];
                    [dataBase updateAllMessageStatus];
                    [dataBase deleteAllData :@"SESSION"];
                    [self stopXMPPService];
                }
                    break;
                    
                case '3':
                {
                    NSString *postChatMessage1=[dataBase getLoginDataFromSessionTable:14];
                    
                    NSArray *array = @[postChatMessage1, @"Tutorials", [ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", [dataBase getLoginDataFromSessionTable:18], @"text",agentName ,@"mid", @"V"];
                    [dataBase insertIntoMessageTable:array];
                    NSArray *arrywithnoti=@[messageBody,agentName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:arrywithnoti];
                    [defaults setChatStartValue:NO];
                    [dataBase deleteAllData :@"SESSION"];
                    [self stopXMPPService];
                    
                }
                    break;
                    
                    
                    
                default :{
                    [dataBase updateMid:mid];
                }
                    break;
            }
            
            
        }
        else{
            NSLog(@"from other csId");
            
        }
        
        
    }
}


//-------------------------------------------------------------


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    //    // init the ad hoc string with the value
    //    currentElementValue = [[NSMutableString alloc] initWithString:string];
    //} else {
    //    // append value to the ad hoc string
    //    [currentElementValue appendString:string];
    //}
    //NSLog(@"Processing value for : %@", string);
}


//-------------------------------------------------------------


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName isEqualToString:@"conversity"])
    {
    }
    
}



@end


