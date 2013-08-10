//
//  eUMainViewController.m
//  effUp
//
//  Created by Colin McCormick on 8/9/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "eUMainViewController.h"

@implementation eUMainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize modelNumberLabel = _modelNumberLabel;
@synthesize arrayOfAllModels = _arrayOfAllModels;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - My methods

-(NSArray *)findSuggestedModels {

    NSString *modelNumber = self.modelNumberLabel.text;
    NSArray *allModelNumbers = [self.arrayOfAllModels valueForKey:@"model"];
    NSDictionary *baseModel = [self.arrayOfAllModels objectAtIndex:[allModelNumbers indexOfObject:modelNumber]];
    NSArray *suggestedModels = [self getSuggestionsForBaseModel:baseModel];
    return suggestedModels;
}

-(NSArray *)getSuggestionsForBaseModel:(NSDictionary *)baseModel {
    
    NSMutableArray *suggestedModels = [[NSMutableArray alloc] init];
    for (id model in self.arrayOfAllModels) {
        NSDictionary *comparedModel = [NSDictionary dictionaryWithDictionary:model];
        [comparedModel setValue:[self calculatePaybackFromBaseModel:baseModel toTargetModel:model] forKey:@"payback"];
        [suggestedModels addObject:comparedModel];
    }
    [suggestedModels sortUsingComparator:^NSComparisonResult(id model1, id model2)
     {
         NSNumber *payback1 = [model1 valueForKey:@"payback"];
         NSNumber *payback2 = [model2 valueForKey:@"payback"];
         return [payback1 compare:payback2];
     }];
     
    return suggestedModels;
}

-(NSNumber *)calculatePaybackFromBaseModel:(NSDictionary *)baseModel toTargetModel:(NSDictionary *)targetModel {
    return [NSNumber numberWithInt:2];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"applianceModelsList" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.arrayOfAllModels = array;  
}

- (void)viewDidUnload
{
    [self setModelNumberLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(eUFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
            
            NSArray *suggestedModels = [self findSuggestedModels];
            [[segue destinationViewController] setSuggestedModels:suggestedModels];
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
