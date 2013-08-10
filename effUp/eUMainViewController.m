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
    NSLog(@"about to find suggested models");
    NSString *modelNumber = self.modelNumberLabel.text;
    NSLog(@"for model number %@", modelNumber);
    NSArray *allModelNumbers = [self.arrayOfAllModels valueForKey:@"modelName"];
    NSDictionary *baseModel = [self.arrayOfAllModels objectAtIndex:[allModelNumbers indexOfObject:modelNumber]];
    NSArray *suggestedModels = [self getSuggestionsForBaseModel:baseModel];
    return suggestedModels;
}

-(NSArray *)getSuggestionsForBaseModel:(NSDictionary *)baseModel {
    
    //NSMutableArray *suggestedModels = [[NSMutableArray alloc] init];
    NSMutableArray *suggestedModels = [NSMutableArray array];
    for (id model in self.arrayOfAllModels) {
        if ([model valueForKey:@"modelName"] != [baseModel valueForKey:@"modelName"]) {
            NSLog(@"comparing to %@", [model valueForKey:@"modelName"]);
            NSMutableDictionary *comparedModel = [NSMutableDictionary dictionaryWithDictionary:model];
            [comparedModel setObject:[self calculatePaybackFromBaseModel:baseModel toTargetModel:model] forKey:@"payback"];
          //  [comparedModel setObject:@"test" forKey:@"payback"];
            NSLog(@"payback value %@", [comparedModel valueForKey:@"payback"]);
            if ([comparedModel valueForKey:@"payback"] < [NSNumber numberWithFloat:(NEVER_GOOD_PAYBACK-1)]) {
                [suggestedModels addObject:comparedModel];
            }
        }
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
    NSDecimalNumber *basePrice = [baseModel valueForKey:@"price"];
    NSDecimalNumber *targetPrice = [targetModel valueForKey:@"price"];
  //  NSLog(@"base %@, target %@", basePrice, targetPrice);
    float costDelta = [targetPrice doubleValue] - [basePrice doubleValue];
  //  NSLog(@"cost delta is %5.1f", costDelta);
    
    NSDecimalNumber *baseEnergyCost = [baseModel valueForKey:@"energyCost"];
    NSDecimalNumber *targetEnergyCost = [targetModel valueForKey:@"energyCost"];
    float energyCostDelta = [targetEnergyCost doubleValue] - [baseEnergyCost doubleValue];
  //  NSLog(@"energy cost delta is %5.1f", energyCostDelta);
    
    NSNumber *payback = [NSNumber numberWithFloat:0];
    if (costDelta > 0) { // more expensive
        if (energyCostDelta > 0) { // less efficient
            payback = [NSNumber numberWithFloat:NEVER_GOOD_PAYBACK]; // always worse
        } else { // more efficient
            payback = [NSNumber numberWithFloat:(-costDelta / energyCostDelta)]; // payback sometime
        }
    } else { // less expensive
        if (energyCostDelta > 0) { // less efficient
            payback = [NSNumber numberWithFloat:DONT_RECOMMEND_PAYBACK]; // don't recommend
        } else { // more efficient
            payback = [NSNumber numberWithFloat:ALWAYS_GOOD_PAYBACK]; // always saves
        }
    }
    return payback;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.modelNumberLabel) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  [self.modelNumberLabel setDelegate:self];
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
        
        NSLog(@"about to go into UI thing");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
            
        }
        NSLog(@"about to get suggested models in segue");
        NSArray *suggestedModels = [self findSuggestedModels];
        [[segue destinationViewController] setSuggestedModels:suggestedModels];
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
