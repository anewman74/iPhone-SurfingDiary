//
//  AllJournalsViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "AllJournalsViewController.h"
#import "Surfing_JournalAppDelegate.h"
#import "SelectedLogViewController.h"
#import "Singleton.h"

@implementation AllJournalsViewController

@synthesize selectedlogvc;
@synthesize tableData;


- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
														 , NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

#pragma initialize table data
-(void)initializeTableData{

	NSString *query = @"SELECT ROW, date, session FROM surflog";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			[tableData addObject:[NSString stringWithFormat:@"%s - %s...(%i)", (char*)sqlite3_column_text(statement, 1), (char*)sqlite3_column_text(statement, 2), sqlite3_column_int(statement, 0)]];
		}
		sqlite3_finalize(statement);
	}
	[self.tableView reloadData];
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	//NSLog(@"in selected log");
	sqlite3_close(database);
}


#pragma view will appear
-(void)viewWillAppear:(BOOL)animated {
	
	tableData = 0;
	tableData = [[NSMutableArray alloc] init]; //initialize the array
	
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS surflog (row integer primary key,date text, session text, winddirection text,windspeed integer, buoysdirection text, buoysheight integer, buoysinterval integer, tide text, rating integer, comment text, region text, location text);";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
	[self initializeTableData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Results", @"results");
	
	UIApplication *app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	//Set up the cell
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] lowercaseString];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	row = row+1;
	int count = [tableData count];	
	
	for (int i=1; i<count+1; i++) {
		if(row == i)
		{
			test = [tableData objectAtIndex:indexPath.row];
			NSArray *splite = [test componentsSeparatedByString:@" - "];
			first = [splite objectAtIndex:0];
			second = [splite objectAtIndex:1];
            NSArray *splite2 = [second componentsSeparatedByString:@"...("];
            third = [splite2 objectAtIndex:0];
            fourth = [splite2 objectAtIndex:1];
            NSArray *splite3 = [fourth componentsSeparatedByString:@")"];
            fifth = [splite3 objectAtIndex:0];
            int intfifth = [fifth intValue];
			
			NSString *query = [[NSString alloc] initWithFormat: @"SELECT ROW FROM surflog where date = '%@' and session = '%@' and row = %i",first,third, intfifth];

			sqlite3_stmt *statement;
			if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
				while(sqlite3_step(statement) == SQLITE_ROW){
					int rowdata = sqlite3_column_int(statement, 0);
					
					[[Singleton sharedSingleton] setnewrownumber:rowdata];		
				}
				sqlite3_finalize(statement);
			}
			sqlite3_close(database);
			
			if (self.selectedlogvc == nil)
			{
				SelectedLogViewController *gSelectedLog = [[SelectedLogViewController alloc] initWithNibName: @"SelectedLogView" bundle:[NSBundle mainBundle]];
				self.selectedlogvc = gSelectedLog;
				[gSelectedLog release];
			}
			Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.surfingNavController pushViewController:selectedlogvc animated:YES];
		}
		
	}
	
}

#pragma mark - method viewWillDisappear.
-(void) viewWillDisappear:(BOOL)animated {
	
	sqlite3_close(database);
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [selectedlogvc release];
    [alljournals release];
    [tableData release];
    [test release];
    [first release];
    [second release];
    [third release];
    [fourth release];
    [fifth release];
}


@end

