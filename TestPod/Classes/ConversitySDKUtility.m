//
//  ConversitySDKUtility.m
//  iMessageBubble
//
//  Created by test on 1/12/17.
//  Copyright © 2017 Prateek Grover. All rights reserved.
//

#import "ConversitySDKUtility.h"

@implementation ConversitySDKUtility

+(NSString *)getMid{
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hhmmssSS"];
    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSLog(@"Current date is %@",dateString);
    return dateString;
}
+(NSString *)getCurrentTime{
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSLog(@"Current date is %@",dateString);
    return dateString;
}


@end
