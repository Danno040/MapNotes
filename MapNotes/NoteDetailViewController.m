//
//  NodeDetailViewController.m
//  MapNotes
//
//  Created by Michael Feineman on 5/12/13.
//
//

#import "NoteDetailViewController.h"

@implementation NoteDetailViewController

@synthesize delegate = _delegate;
@synthesize annotation = _annotation;
@synthesize titleField = _titleField;
@synthesize subtitleField = _subtitleField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.titleField setText:self.annotation.title];
    [self.subtitleField setText:self.annotation.subtitle];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    
    self.annotation.title = self.titleField.text;
    self.annotation.subtitle = self.subtitleField.text;
    
    
    [self.delegate noteDetailViewControllerDidFinish:self AndDeletePin:NO];
}

- (IBAction)deletePin:(id)sender {
    [self.delegate noteDetailViewControllerDidFinish:self AndDeletePin:YES];
}

- (IBAction)getDirections:(id)sender
{
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [self.annotation.mapItem openInMapsWithLaunchOptions:launchOptions];
}

@end
