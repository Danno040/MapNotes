//
//  MainViewController.h
//  MapNotes
//
//  Created by Mike Feineman on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "NoteDetailViewController.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, NoteDetailViewControllerDelegate, MKMapViewDelegate> {
    IBOutlet MKMapView *main_map;
}

@property bool has_zoomed;
@property CLLocationCoordinate2D current_location;
@property MKMapView* main_map;

-(IBAction)showInfo:(id)sender;
-(IBAction)dropPin:(id)sender;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation;

-(NSMutableArray*)serializeAnnotations;
-(void)applicationWillTerminate:(UIApplication *)application;

@end
