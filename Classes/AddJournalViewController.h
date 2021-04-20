//
//  AddJournalViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailsViewController;
#import <sqlite3.h>

#define kFilename	@"surf1.sqlite3"


@interface AddJournalViewController : UIViewController {
	
	DetailsViewController *detailsViewController;
	
	sqlite3 *database;
	
	IBOutlet UIDatePicker *datePicker;
	
	NSDateFormatter *formatter3;
	NSDate *now;
	
	NSString *strSelectedTime;	
	NSDateFormatter *formatter;
	NSDate *dateSelectedTime;
	
	NSDateFormatter *formatter2;	
	NSString *strSelectedDay;
	NSString *strSelectedHour;
	NSString *strSelectedMinutes;
	NSString *session;
	
	int intSelectedDay;
	int intSelectedHour;
	int intSelectedMinutes;
}
@property (nonatomic, retain) DetailsViewController *detailsViewController;
@property (nonatomic, retain) UIDatePicker *datePicker;

-(NSString *)dataFilePath;
-(void)applicationWillTerminate:(NSNotification *)notification;

-(IBAction)details;

@end
