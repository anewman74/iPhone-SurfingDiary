//
//  FrontViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectionViewController;



@interface FrontViewController : UIViewController {
	SelectionViewController *selectionViewController;

}

@property (nonatomic, retain) SelectionViewController *selectionViewController;

-(IBAction) start;

@end
