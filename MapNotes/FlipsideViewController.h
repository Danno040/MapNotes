//
//  FlipsideViewController.h
//  MapNotes
//
//  Created by Mike Feineman on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller withAnnotation:(id <MKAnnotation>)annotation;
@end

@interface FlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* table;
}

@property (strong, atomic) IBOutlet UITableView* table;

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
