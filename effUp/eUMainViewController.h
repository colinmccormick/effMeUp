//
//  eUMainViewController.h
//  effUp
//
//  Created by Colin McCormick on 8/9/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "eUFlipsideViewController.h"

@interface eUMainViewController : UIViewController <eUFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
