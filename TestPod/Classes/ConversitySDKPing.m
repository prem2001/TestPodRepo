//
//  Ping.m
//  Conversity
//
//  Created by test on 1/23/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKPing.h"

@implementation ConversitySDKPing{
    BOOL valuee;

}

-(BOOL)getInternateStatus{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    
    NSError *serr;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
    

#define appService [NSURL \
URLWithString:@"https://conversity-cdn.s3.ap-south-1.amazonaws.com/ping.txt"]
    
    // Create request object
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
    
    // Set method, body & content-type
    request.HTTPMethod = @"POST";
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:1500];
    
    [request setValue:
     [NSString stringWithFormat:@"%lu",
      (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSHTTPURLResponse *response = nil;

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSLog(@"yes internet %ld",(long)[response statusCode]);
    if([response statusCode]==405){
//        NSLog(@"yes internet");
        valuee=YES;
    }else
    {
        valuee=NO;

    }
    
   
    return valuee;
    
}

@end
