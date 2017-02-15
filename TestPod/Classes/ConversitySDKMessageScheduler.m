//
//  ConversitySDKMessageScheduler.m
//  Conversity
//
//  Created by test on 1/24/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKMessageScheduler.h"
#import "ConversitySDKDataBase.h"
#import "ConversitySDKPing.h"
#import "ConversitySDKUtility.h"
#import "ConversitySDKNSDefaults.h"

@implementation ConversitySDKMessageScheduler{
    NSTimer *timerr;
    NSInteger b;
    NSInteger timeCounter;
    ConversitySDKPing *ping;
    ConversitySDKDataBase *db;
    ConversitySDKNSDefaults *defaults;
}

-(void)startScheduler{
    db=[[ConversitySDKDataBase alloc]init];
    ping=[[ConversitySDKPing alloc]init];
    defaults=[[ConversitySDKNSDefaults alloc]init];
    
     b = [[db getLoginDataFromSessionTable:16] integerValue]/2;

    
//    NSLog(@"abandon time %ld",(long)b);

    if (!timerr) {
        timerr = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                 target:self
                                               selector:@selector(_timerFired:)
                                            userInfo:nil
                                                repeats:TRUE];
    }
}

- (void)_timerFired:(NSTimer *)timer {
//    NSLog(@"sedulertimer %ld",(long)timeCounter);
    if(timeCounter==b || timeCounter>b){
//        NSLog(@"sedulertimer cancel");
        [timerr invalidate];
        timerr=nil;
        NSArray *abandondedAndEndMessage=@[[db getLoginDataFromSessionTable:15],@"end"];
        NSArray *AV=@[@"A",@"V"];
        NSArray *DP=@[@"D",@"P"];
        NSArray *actionCode=@[@"2",@"2"];
        NSArray *seenToCode=@[@"visitor",@"agent"];
        for (int i=0; i<2; i++) {
            NSArray *array2 = @[abandondedAndEndMessage[i], @"Tutorials",[ConversitySDKUtility getCurrentTime],AV[i], DP[i], seenToCode[i], @"Tutorials", @"Tutorials", [db getLoginDataFromSessionTable:6], [ConversitySDKUtility getMid], actionCode[i]];
            [db insertIntoMessageTable:array2];
        }
    }
    
    if([ping getInternateStatus]){
        timeCounter++;
    }
//    NSLog(@"adnado timmer %hhd",[defaults getAbandonTimmer]);
    if(![defaults getAbandonTimmer]){
//        NSLog(@"stopTimer");
        [timerr invalidate];
        timerr=nil;
    }
    
    
    
    
}
-(void)stopTimer{
   
}
@end
