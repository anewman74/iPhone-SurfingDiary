//
//  AllJournalsViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class SelectedLogViewController;

#define kFilename	@"surf1.sqlite3"

@interface AllJournalsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	
	SelectedLogViewController *selectedlogvc;
	
	IBOutlet UITableView *alljournals;
	
	NSMutableArray *tableData;
	NSString *test;
	NSString *first;
	NSString *second;
    NSString *third;
    NSString *fourth;
    NSString *fifth;
	
	sqlite3 *database;
}

@property (nonatomic, retain) SelectedLogViewController *selectedlogvc;
@property (nonatomic, retain) NSMutableArray *tableData;

-(NSString *)dataFilePath;
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void)initializeTableData;

@end
