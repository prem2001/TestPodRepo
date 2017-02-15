//
//  MyViewController.m
//  test2
//
//  Created by test on 1/30/17.
//  Copyright © 2017 GlobalServices. All rights reserved.
//

#import "MyViewController.h"
#import "ContentView.h"
#import "ChatTableViewCell.h"
#import "ChatTableViewCellXIB.h"
#import "ChatCellSettings.h"

#import "ConversitySDKNSDefaults.h"
#import "ConversitySDKDataBase.h"
#import "ConversitySDKXMPPConnector.h"
#import "ConversitySDKUtility.h"
#import "ConversitySDKPing.h"
#import "ConversitySDKMessageScheduler.h"


@interface iMessage: NSObject

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSString *userTime;
@property (strong, nonatomic) NSString *messageType;

@end

@implementation iMessage

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}

@end
@interface MyViewController (){
    BOOL *touchOnChatInterface;
    ConversitySDKNSDefaults *defaults;
    ConversitySDKXMPPConnector *xmppConnecter;
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (strong, nonatomic) IBOutlet UITextField *chatTextView;

/*Uncomment second line and comment first to use XIB instead of code*/
@property (strong,nonatomic) ChatTableViewCell *chatCell;
//@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;


@property (strong,nonatomic) ContentView *handler;

@end

@implementation MyViewController
{
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
    ConversitySDKDataBase *db;
    
    UIView *chatMenuListView;
    BOOL menuListFlag;
    
}
bool isShown = false;

@synthesize chatCell;

//Remove bubble noch ot tail
//go to ChatTableViewCell.m class and set
//getReceiverBubbleTail     YES;


- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSLog(@"Chat interface");
    
    db=[[ConversitySDKDataBase alloc]init];
    [db creatingclientidDB];
    
    
    //prem code
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingHappens:) name:@"notificationName" object:nil];
    
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    
    
    self.chatView.layer.cornerRadius = 10;
    self.chatView.layer.masksToBounds = YES;
    self.sendButtonView.layer.cornerRadius=18;
    self.sendButtonView.layer.masksToBounds=YES;
    self.closeImageView.layer.cornerRadius=10;
    self.closeImageView.layer.masksToBounds=YES;
    self.menuImageView.layer.cornerRadius=10;
    self.menuImageView.layer.masksToBounds=YES;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendmessageMethod:)];
    tapped.numberOfTouchesRequired = 1;
    UITapGestureRecognizer *tapped1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeChatViewMethod:)];
    tapped.numberOfTouchesRequired = 1;
    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuListMethod:)];
    tapped.numberOfTouchesRequired = 1;
    UITapGestureRecognizer *tapped3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatViewTouchMethod:)];
    tapped.numberOfTouchesRequired = 1;
    [_sendButtonView addGestureRecognizer:tapped];
    [_closeImageView addGestureRecognizer:tapped1];
    [_menuImageView addGestureRecognizer:tapped2];
    [_chatView addGestureRecognizer:tapped3];
    
    
    /* chat interface background color */
    self.chatView.backgroundColor= [self colorWithHexString:@"88232323"];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    
    self.sendButtonView.backgroundColor= [self colorWithHexString:@"6699FF"];
    self.closeImageView.backgroundColor= [self colorWithHexString:@"CC5F5F5F"];
    self.menuImageView.backgroundColor= [self colorWithHexString:@"CC5F5F5F"];
    
    
    
    
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    [chatCellSettings setSenderBubbleColorHex:@"E6EBF0"];
    [chatCellSettings setReceiverBubbleColorHex:@"0978E1"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"444444"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"444444"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"444444"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"FFFFFF"];
    
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    
    //    self.navigationItem.title = @"iMessageBubble Demo";
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    
    
    
    /*Uncomment second para and comment first to use XIB instead of code*/
    //Registering custom Chat table view cell for both sending and receiving
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
    
    
    /*UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
     
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
     
     nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
     
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];*/
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.chatTable addGestureRecognizer:gestureRecognizer];
    //prem code
    [self creatingDB];
    [self refreshTableView];
    defaults=[[ConversitySDKNSDefaults alloc]init];
    xmppConnecter=[[ConversitySDKXMPPConnector alloc]init];
    
    if([defaults getChatStartValue]){
        NSLog(@"chat value true");
        [xmppConnecter startXMPPService];
    }
    
    
    menuListFlag=NO;
    
    defaults=[[ConversitySDKNSDefaults alloc]init];
    
    
}

- (void) dismissKeyboard
{
    [self.chatTextView resignFirstResponder];
}

//sendmessagehandler
-(void)sendmessageMethod :(id) sender
{
    //sendmessage
    //    iMessage *sendMessage;
    //    NSString *message=_chatTextView.text;
    //
    //    sendMessage = [[iMessage alloc] initIMessageWithName:@"agentName" message:message time:@"time" type:@"self"];
    //    [self updateTableView:sendMessage];
    
    
    
    
    NSString *messageText=self.chatTextView.text;
    
    if([defaults getChatStartValue]){
        NSLog(@"chat value true");
    }
    else{
        NSLog(@"chat value false");
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:[defaults getKey] forKey:@"clientId"];
        [dict setValue:[defaults getClientSalt] forKey:@"clientSalt"];
        [dict setValue:[defaults getDept] forKey:@"deptId"];
        [dict setValue:[defaults getChatVisitorId] forKey:@"visitorId"];
        [dict setValue:[defaults getChatVisitorName] forKey:@"visitorName"];
        [dict setValue:[defaults getChatVisitorEmail] forKey:@"visitorEmail"];
        [dict setValue:[defaults getOS] forKey:@"OS"];
        
        NSError *serr;
        
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
        
        if (serr)
        {
            NSLog(@"Error generating json data for send dictionary...");
            NSLog(@"Error (%@), error: %@", dict, serr);
            return;
        }
        
        NSLog(@"Successfully generated JSON for send dictionary");
        NSLog(@"now sending this dictionary...\n%@\n\n\n", dict);
#define appService [NSURL \
URLWithString:@"https://portal.conversity.net/app/x/v_register.php"]
        
        // Create request object
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
        
        // Set method, body & content-type
        request.HTTPMethod = @"POST";
        request.HTTPBody = jsonData;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setValue:
         [NSString stringWithFormat:@"%lu",
          (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
         {
             
             NSLog(@"responce @%",r );
             if (!data)
             {
                 NSLog(@"No data returned from server, error ocurred: %@", error);
                 NSString *userErrorText = [NSString stringWithFormat:
                                            @"Error communicating with server: %@", error.localizedDescription];
                 return;
             }
             
             //             NSLog(@"got the NSData fine. here it is...\n%@\n", data);
             
             NSError *deserr;
             NSDictionary *responseDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&deserr];
             
             NSLog(@"so, here's the responseDict \n%@\n", responseDict);
             
             NSLog(@"status %@",[responseDict objectForKey:@"status"]);
             
             if([[responseDict objectForKey:@"status"] isEqualToString:@"1"]){
                 ConversitySDKDataBase *database=[[ConversitySDKDataBase alloc]init];
                 [database insertIntoSessionTableJsonObjectDB:responseDict];
                 
                 
                 //if dept is offline
                 if(![[database getLoginDataFromSessionTable:10]isEqualToString:@"1"]) {
                     [database updateAllMessageStatus];
                     NSString *offlinemessage=[database getLoginDataFromSessionTable:13];
                     NSString *key=@"{{dttm}}";
                     
                     //2 sec delay
                     double delayInSeconds = 2.0;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                         if([offlinemessage rangeOfString:key].location==NSNotFound){
                             //when key is not found
                             NSString *agentName=[database getLoginDataFromSessionTable:6];
                             iMessage *sendMessage;
                             
                             NSArray *array = @[offlinemessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                             [database insertIntoMessageTable:array];
                             sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:offlinemessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                             [self updateTableView:sendMessage];
                         }else{
                             NSString *newmessage = [offlinemessage stringByReplacingOccurrencesOfString: key withString:[database getLoginDataFromSessionTable:10]];
                             
                             NSString *agentName=[database getLoginDataFromSessionTable:6];
                             iMessage *sendMessage;
                             
                             NSArray *array = @[newmessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                             [database insertIntoMessageTable:array];
                             sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:newmessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                             [self updateTableView:sendMessage];
                             
                         }
                         
                         [defaults setChatStartValue:NO];
                         [database deleteAllData:@"SESSION"];
                         [database updateAllMessageStatus];
                     });
                     
                     
                     
                     
                     
                     
                     
                 }
                 //Department is online but agent is offline
                 else if ([[database getLoginDataFromSessionTable:16]isEqualToString:@"5"]){
                     
                     iMessage *sendMessage;
                     NSString *agentName=[database getLoginDataFromSessionTable:6];
                     NSString *welcomeMessage=[database getLoginDataFromSessionTable:11];
                     NSArray *array = @[welcomeMessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                     [database insertIntoMessageTable:array];
                     sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:welcomeMessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                     [self updateTableView:sendMessage];
                     
                     NSString *holdMessage=[database getLoginDataFromSessionTable:12];
                     NSArray *array2 = @[holdMessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                     [database insertIntoMessageTable:array2];
                     sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:holdMessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                     [self updateTableView:sendMessage];
                     
                     
                     
                     double delayInSeconds = 5.0;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                         
                         iMessage *sendMessage;
                         NSString *abandoned=[database getLoginDataFromSessionTable:15];
                         NSArray *array2 = @[abandoned, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                         [database insertIntoMessageTable:array2];
                         sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:abandoned time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                         [self updateTableView:sendMessage];
                         
                         [database updateAllMessageStatus];
                         [defaults setChatStartValue:NO];
                         [database deleteAllData:@"SESSION"];
                         
                     });
                     
                 }
                 
                 //when dept and agent both are online.
                 else{
                     iMessage *sendMessage;
                     NSString *agentName=[database getLoginDataFromSessionTable:6];
                     NSString *welcomeMessage=[database getLoginDataFromSessionTable:11];
                     NSArray *array = @[welcomeMessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                     [database insertIntoMessageTable:array];
                     sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:welcomeMessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                     [self updateTableView:sendMessage];
                     
                     NSString *holdMessage=[database getLoginDataFromSessionTable:12];
                     NSArray *array2 = @[holdMessage, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"A", @"D", @"visitor", @"Tutorials", @"Tutorials", agentName, [ConversitySDKUtility getMid], @"V"];
                     [database insertIntoMessageTable:array2];
                     sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:holdMessage time:[ConversitySDKUtility getCurrentTime] type:@"other"];
                     [self updateTableView:sendMessage];
                     
                     
                     ConversitySDKMessageScheduler *abandedtimer=[[ConversitySDKMessageScheduler alloc]init];
                     [abandedtimer startScheduler];
                     
                     
                     [xmppConnecter startXMPPService];
                     [defaults setChatStartValue:YES];
                     [defaults setAbandonTimmer:YES];
                 }
                 
             }
             else if ([[responseDict objectForKey:@"status"] isEqualToString:@"0"]){
                 NSString *message=[responseDict objectForKey:@"message"];
                 UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil                                                            message:message
                                                                delegate:nil                                                  cancelButtonTitle:nil                                                  otherButtonTitles:nil, nil];
                 toast.backgroundColor=[UIColor redColor];
                 [toast show];
                 int duration = 2; // duration in seconds
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissWithClickedButtonIndex:0 animated:YES];            });
                 
             }
             
             
             
             
             // LOOK at that output on your console to learn how to parse it.
             // to get individual values example blah = responseDict[@"fieldName"];
         }];
    }
    //sendmessage
    if([self.chatTextView.text length]!=0)
    {
        ConversitySDKDataBase *database=[[ConversitySDKDataBase alloc]init];
        
        if(![defaults getChatStartValue]){
            NSArray *array1 = @[[defaults getInitMessage], @"Tutorials",[ConversitySDKUtility getCurrentTime], @"V", @"P", @"agent", @"Tutorials", @"Tutorials", [defaults getChatVisitorName], [ConversitySDKUtility getMid], @"V"];
            [database insertIntoMessageTable:array1];
        }
        
        
        
        iMessage *sendMessage;
        NSArray *array = @[messageText, @"Tutorials",[ConversitySDKUtility getCurrentTime], @"V", @"P", @"visitor", @"Tutorials", @"Tutorials", [defaults getChatVisitorName], [ConversitySDKUtility getMid], @"V"];
        [database insertIntoMessageTable:array];
        sendMessage = [[iMessage alloc] initIMessageWithName:[defaults getChatVisitorName] message:self.chatTextView.text time:[ConversitySDKUtility getCurrentTime] type:@"self"];
        [self updateTableView:sendMessage];
    }
    
    
}
-(void)closeChatViewMethod :(id) sender
{
    [self.view endEditing:YES];
    self.view.hidden=YES;
    
    
}
-(void)menuListMethod :(id) sender

{
    if(menuListFlag){
        menuListFlag=NO;
        chatMenuListView.hidden=YES;
    }else{
        [self showMenuList];
        menuListFlag=YES;
    }
    
}
-(void)showMenuList{
    chatMenuListView = [[UIView alloc] initWithFrame:CGRectMake(_chatView.frame.size.width/2- _chatView.frame.size.width/4, _chatView.frame.size.height/2-100, _chatView.frame.size.width/2, 122)];
    chatMenuListView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, _chatView.frame.size.width/2, 40);
    [button setTitle:@"Sound" forState:(UIControlState)UIControlStateNormal];
    [button addTarget:self action:@selector(soundMethod) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [button setTitleColor:[self colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [button setBackgroundColor:[self colorWithHexString:@"CC5F5F5F"]];
    
    UIView *sapretor = [[UIView alloc] initWithFrame:CGRectMake(0, 40, chatMenuListView.frame.size.width, 1)];
    sapretor.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(0, 41,  chatMenuListView.frame.size.width, 40);
    [button2 setTitle:@"Vibration" forState:(UIControlState)UIControlStateNormal];
    [button2 addTarget:self action:@selector(vibartionMethod) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [button2 setTitleColor:[self colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[self colorWithHexString:@"CC5F5F5F"]];
    
    UIView *sapretor2 = [[UIView alloc] initWithFrame:CGRectMake(0, 81, chatMenuListView.frame.size.width, 1)];
    sapretor2.backgroundColor = [UIColor whiteColor];
    
    UIButton *endChatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    endChatButton.frame = CGRectMake(0, 82, chatMenuListView.frame.size.width, 40);
    [endChatButton setTitle:@"End Chat" forState:(UIControlState)UIControlStateNormal];
    [endChatButton addTarget:self action:@selector(endChatMethod) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [endChatButton setTitleColor:[self colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [endChatButton setBackgroundColor:[self colorWithHexString:@"CC5F5F5F"]];
    
    [chatMenuListView addSubview:button];
    [chatMenuListView addSubview:sapretor];
    [chatMenuListView addSubview:button2];
    [chatMenuListView addSubview:sapretor2];
    [chatMenuListView addSubview:endChatButton];
    
    [self.chatView addSubview:chatMenuListView];
}
-(void)chatViewTouchMethod :(id) sender

{
    chatMenuListView.hidden=YES;
    menuListFlag=NO;
    
}
-(void)soundMethod{
    chatMenuListView.hidden=YES;
    menuListFlag=NO;
}
-(void)vibartionMethod{
    chatMenuListView.hidden=YES;
    menuListFlag=NO;
}
-(void)endChatMethod{
    chatMenuListView.hidden=YES;
    menuListFlag=NO;
    
    NSLog(@"active agent count %d",[db getActiveAgentCount]);
    NSString *action;
    if([db getActiveAgentCount]>1){
        action=@"6";
    }else{
        action=@"1";
    }
    NSArray *array = @[@"end", @"Tutorials",[ConversitySDKUtility getCurrentTime], @"V", @"P", @"agent", [db getLoginDataFromSessionTable:18], @"text", [defaults getChatVisitorName], [ConversitySDKUtility getMid], action];
    [db insertIntoMessageTable:array];
    
}
- (void)keyboardDidShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyBoardHeight=keyboardSize.height-30;
    
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,[[UIScreen mainScreen] bounds].size.height-keyBoardHeight)];
    
    //    if ([[UIScreen mainScreen] bounds].size.height == 568) {
    //    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,200)];
    //} else {
    //    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,200)];
    //}
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,[[UIScreen mainScreen] bounds].size.height)];
    //if ([[UIScreen mainScreen] bounds].size.height == 568)
    //{ [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    //} else {
    //    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    //}
    
}






- (IBAction)edidtingDidBegin:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];}


- (IBAction)end:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
-(void) updateTableView:(iMessage *)msg
{
    [self.chatTextView setText:@""];
    //    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    if([message.messageType isEqualToString:@"self"])
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
        
        chatCell.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setCellColor:[UIColor whiteColor] ForCell:chatCell];
        
    }
    else
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
        //for background tranparent
        [self setCellColor:[UIColor whiteColor] ForCell:chatCell];
        
    }
    
    return chatCell;
    
}
- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];;
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    CGSize size;
    
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
    //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
    if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
    //Find the required cell height
    Namesize = [@"Name" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[0]}
                                     context:nil].size;
    
    
    
    Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:fontArray[1]}
                                                    context:nil].size;
    
    
    Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[2]}
                                     context:nil].size;
    
    
    size.height = Messagesize.height + Namesize.height + Timesize.height + 20.0f;//size of the bubble in tableview
    self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    
    
    return size.height;
}

-(UIColor *)colorWithHexString:(NSString*)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
            case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
            case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
            case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
            case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return (CGFloat)hexComponent/255.0f;
}





-(void)creatingDB{
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to keep the database
    _databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"clientId.db"]];
    
}
-(void)refreshTableView{
    sqlite3_stmt *statement;
    const char *dbpath=[_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_DB)==SQLITE_OK){
        //        NSLog(@"DB OPEN");
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM MESSAGE WHERE SEENTO = 'visitor' ORDER BY ID ASC"];
        const char *query_statment =  [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL)==SQLITE_OK){
            //            NSLog(@"DB sqlite3_prepare_v2");
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                NSLog(@"DB sqlite3_step");
                //get 1st index value from the sqlite.db
                NSString *messageBody =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *sender =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *time =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *agentName =[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                
                //for adding the value to array
                iMessage *sendMessage;
                
                
                if([sender isEqualToString:@"V"]){
                    sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:messageBody time:time type:@"self"];
                }else{
                    sendMessage = [[iMessage alloc] initIMessageWithName:agentName message:messageBody time:time type:@"others"];
                }
                
                
                
                [self updateTableView:sendMessage];
                
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
}
-(void)somethingHappens:(NSNotification*)notification
{
    NSArray *getNotifiArray=notification.object;
    NSString *messageBody=getNotifiArray[0];
    NSString *agentName=getNotifiArray[1];
    
    iMessage *receiveMessage;
    
    receiveMessage = [[iMessage alloc] initIMessageWithName:agentName message:messageBody time:[ConversitySDKUtility getCurrentTime] type:@"other"];
    
    [self updateTableView:receiveMessage];
}



@end
