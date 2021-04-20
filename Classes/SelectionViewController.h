//
//  SelectionViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddJournalViewController;
@class AllJournalsViewController;
@class SpecificSearchViewController;
@class ForecastSearchViewController;

@interface SelectionViewController : UIViewController {
	AddJournalViewController *addjournalViewController;
	AllJournalsViewController *allJournalsViewController;
	SpecificSearchViewController *specificSearchViewController;
	ForecastSearchViewController *forecastSearchViewController;
}
@property (nonatomic, retain) AddJournalViewController *addJournalViewController;
@property (nonatomic, retain) AllJournalsViewController *allJournalsViewController;
@property (nonatomic, retain) SpecificSearchViewController *specificSearchViewController;
@property (nonatomic, retain) ForecastSearchViewController *forecastSearchViewController;

-(IBAction) add;
-(IBAction) all;
-(IBAction) specific;
-(IBAction) forecast;

@end
