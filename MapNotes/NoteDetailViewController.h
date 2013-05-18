//
//  NoteDetailViewController.h
//  MapNotes
//
//  Created by Michael Feineman on 5/12/13.
//
//

#import <UIKit/UIKit.h>
#import "MapNoteAnnotation.h"

@class NoteDetailViewController;

@protocol NoteDetailViewControllerDelegate
- (void)noteDetailViewControllerDidFinish:(NoteDetailViewController *)controller AndDeletePin:(bool)delete_pin;
@end

@interface NoteDetailViewController : UIViewController {
    UITextField* titleField;
    UITextView* subtitleField;
}

@property IBOutlet UITextField* titleField;
@property IBOutlet UITextView* subtitleField;

@property (weak, nonatomic) IBOutlet id <NoteDetailViewControllerDelegate> delegate;
@property (strong, atomic) MapNoteAnnotation* annotation;

-(IBAction) done:(id)sender;
-(IBAction) deletePin:(id)sender;
-(IBAction) getDirections:(id)sender;

@end
