//
//  SelectedLogViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define kFilename	@"surf1.sqlite3"

@interface SelectedLogViewController : UIViewController <UITextFieldDelegate> {

	IBOutlet UITextField *date;
	IBOutlet UITextField *session;
	IBOutlet UITextField *winddirection;
    IBOutlet UITextField *windspeed;
	IBOutlet UITextField *buoysdirection;
	IBOutlet UITextField *buoysheight;
	IBOutlet UITextField *buoysinterval;
	IBOutlet UITextField *tide;
	IBOutlet UITextField *region;
	IBOutlet UITextField *location;
	IBOutlet UITextField *rating;
	IBOutlet UITextField *comment;
	
	sqlite3 *database;
	
	int newrownumber;
	
	NSString *title;
	NSString *message;
	UIAlertView *alert;
	
	BOOL moveViewUp;
	CGFloat scrollAmount;
	
}
@property (nonatomic, retain) UITextField *date;
@property (nonatomic, retain) UITextField *session;
@property (nonatomic, retain) UITextField *winddirection;
@property (nonatomic, retain) UITextField *windspeed;
@property (nonatomic, retain) UITextField *buoysdirection;
@property (nonatomic, retain) UITextField *buoysheight;
@property (nonatomic, retain) UITextField *buoysinterval;
@property (nonatomic, retain) UITextField *tide;
@property (nonatomic, retain) UITextField *region;
@property (nonatomic, retain) UITextField *location;
@property (nonatomic, retain) UITextField *rating;
@property (nonatomic, retain) UITextField *comment;

-(NSString *)dataFilePath;
-(void)applicationWillTerminate:(NSNotification *)notification;

-(IBAction)save;
-(IBAction)deleteLog;
-(void) scrollTheView:(BOOL)movedUp;

@end