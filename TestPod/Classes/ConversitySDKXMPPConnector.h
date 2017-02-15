//
//  ConversitySDKXMPPConnector.h
//  iMessageBubble
//
//  Created by test on 1/11/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@import XMPPFramework;

@interface ConversitySDKXMPPConnector : NSObject<NSXMLParserDelegate>
{

    
   
}

@property (strong,nonatomic)NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;


- (void)_timerFired:(NSTimer *)timer;

- (void) doUpdate;

-(void)startXMPPService;
-(void)stopXMPPService;

@end
