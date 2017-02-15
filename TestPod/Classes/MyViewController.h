//
//  MyViewController.h
//  test2
//
//  Created by test on 1/30/17.
//  Copyright © 2017 GlobalServices. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface MyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *chatView;
- (IBAction)editingDidBegin:(id)sender;
- (IBAction)editingDidEnd:(id)sender;
- (IBAction)didEndOnExit:(id)sender;
- (IBAction)editingChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *mainInterface;

@property (strong, nonatomic) IBOutlet UIImageView *sendButtonView;

@property (strong, nonatomic) IBOutlet UIImageView *menuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *closeImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong,nonatomic)NSString *databasePath;
@property(nonatomic) sqlite3 *DB;
@end
