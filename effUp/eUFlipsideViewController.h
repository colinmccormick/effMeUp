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

@interface eUFlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet id <eUFlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *suggestedModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)done:(id)sender;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
