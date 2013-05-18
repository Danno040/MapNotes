//
//  MainViewController.m
//  MapNotes
//
//  Created by Mike Feineman on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapNoteAnnotation.h"
#import "NoteDetailViewController.h"

@implementation MainViewController

@synthesize has_zoomed;
@synthesize current_location;
@synthesize main_map = _main_map;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    
    if(!has_zoomed) {
        MKCoordinateRegion region;
        region.center = self.main_map.userLocation.coordinate;

        MKCoordinateSpan span; 
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01; 
        region.span = span;

        [self.main_map setRegion:region animated:YES];
        
        has_zoomed = true;
    }
    
    current_location = self.main_map.userLocation.coordinate;
    
    //AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //[delegate.flipsideViewController updatePositionLabel:main_map.userLocation.coordinate];
    
}


- (void)viewDidLoad
{
    //self.main_map.delegate = self;
    UIApplication* myApp = [UIApplication sharedApplication];
    
    // Try to load saved annotations
    NSString* filePath = [(AppDelegate*)[myApp delegate] saveFilePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if(fileExists)
    {
        NSArray* annotations = [[NSArray alloc] initWithContentsOfFile:filePath];
        for(NSDictionary* dict in annotations) {
            MapNoteAnnotation* pin = [[MapNoteAnnotation alloc] initWithDictionary:dict];
            [self.main_map addAnnotation:pin];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationDidEnterBackgroundNotification object:myApp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:myApp];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    has_zoomed = false;
    
    [self.main_map.userLocation addObserver:self
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];

    
}

- (void)viewDidUnload
{
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSMutableArray*)serializeAnnotations {
    NSMutableArray* seralizable_annotations = [[NSMutableArray alloc] init];
    for(id <MKAnnotation> annotation in self.main_map.annotations) {
        if ([annotation isKindOfClass:[MapNoteAnnotation class]])
        {
            NSArray* objectsArray = @[annotation.title, annotation.subtitle, [[NSNumber alloc] initWithDouble:annotation.coordinate.latitude], [[NSNumber alloc] initWithDouble: annotation.coordinate.longitude]];
            NSArray* keysArray = @[@"title", @"subtitle", @"latitude", @"longitude"];
            NSDictionary* dict = [[NSDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
            [seralizable_annotations addObject:dict];
        }
    }
    return seralizable_annotations;
}

-(void)applicationWillTerminate:(UIApplication *)application {
    // Save annotations to a file.
    NSLog(@"MainViewController got applicationWillTerminate");
    NSMutableArray* annotations = [self serializeAnnotations];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString* filePath = [delegate saveFilePath];
    
    [annotations writeToFile:filePath atomically:YES];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller withAnnotation:(id <MKAnnotation>)annotation
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MKCoordinateRegion region;
    region.center = annotation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.01; // Change these values to change the zoom
    span.longitudeDelta = 0.01;
    region.span = span;
    
    [self.main_map setRegion:region animated:YES];
}

- (void)noteDetailViewControllerDidFinish:(NoteDetailViewController *)controller AndDeletePin:(bool) delete_pin
{
    if(delete_pin) {
        [self.main_map removeAnnotation:controller.annotation];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    FlipsideViewController *controller = delegate.flipsideViewController;
    [controller.table reloadData];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)dropPin:(id)sender
{
    NSLog(@"Drop Pin Called!");
    MapNoteAnnotation* pin = [[MapNoteAnnotation alloc] initWithLocation:current_location];
    [self.main_map addAnnotation:pin];
    
}

#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the callout
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapNoteAnnotation class]])
    {
        NSLog(@"clicked custom annotation");
    }
    
    NoteDetailViewController *controller = [[NoteDetailViewController alloc] initWithNibName:@"NoteDetailViewController" bundle:nil];
    controller.delegate = self;
    controller.annotation = annotation;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
    
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // handle our custom annotation - Taken from MapCallouts example
    //
    if ([annotation isKindOfClass:[MapNoteAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString *MapNoteAnnotationIdentifier = @"mapNoteAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.main_map dequeueReusableAnnotationViewWithIdentifier:MapNoteAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:MapNoteAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            customPinView.draggable = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

@end
