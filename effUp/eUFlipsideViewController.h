//
//  eUFlipsideViewController.h
//  effUp
//
//  Created by Colin McCormick on 8/9/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eUFlipsideViewController;

@protocol eUFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(eUFlipsideViewController *)controller;
@end

@interface eUFlipsideViewController : UIViewController

@property (weak, nonatomic) IBOutlet id <eUFlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *suggestedModels;

- (IBAction)done:(id)sender;

@end
