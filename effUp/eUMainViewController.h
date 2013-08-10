//
//  eUMainViewController.h
//  effUp
//
//  Created by Colin McCormick on 8/9/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "eUFlipsideViewController.h"

#define NEVER_GOOD_PAYBACK 100
#define ALWAYS_GOOD_PAYBACK -1
#define DONT_RECOMMEND_PAYBACK 200

@interface eUMainViewController : UIViewController <eUFlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (weak, nonatomic) IBOutlet UITextField *modelNumberLabel;
@property (strong, nonatomic) NSArray *arrayOfAllModels;

-(NSArray *)findSuggestedModels;
-(NSArray *)getSuggestionsForBaseModel:(NSDictionary *)baseModel;
-(NSNumber *)calculatePaybackFromBaseModel:(NSDictionary *)baseModel toTargetModel:(NSDictionary *)targetModel;

@end
