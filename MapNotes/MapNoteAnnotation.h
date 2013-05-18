//
//  MapNoteAnnotation.h
//  MapNotes
//
//  Created by Michael Feineman on 5/11/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapNoteAnnotation : NSObject <MKAnnotation>

@property CLLocationCoordinate2D location;
@property (strong, atomic) NSString* title;
@property (strong, atomic) NSString* subtitle;

- (id)initWithLocation: (CLLocationCoordinate2D) l;
- (id) initWithDictionary: (NSDictionary*)dict;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (MKMapItem*)mapItem;

@end
