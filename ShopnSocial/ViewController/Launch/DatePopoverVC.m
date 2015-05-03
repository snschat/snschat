//
//  DatePopoverVC.m
//  ShopnSocial
//
//  Created by rock on 5/2/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DatePopoverVC.h"

@interface DatePopoverVC ()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePopoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedDate != nil)
    {
        [self.datePicker setDate:self.selectedDate animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onDateChanged:(id)sender
{
    NSDate* date = self.datePicker.date;
    NSLog(@"%@", date.description);
    
    self.selectedDate = date;
    
    if (self.delegate != nil)
       [ self.delegate didSelectDate:date];
}

@end
