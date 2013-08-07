//
//  BooserViewController.h
//  Booser
//
//  Created by Simon Tucker on 22/06/2013.
//  Copyright (c) 2013 Simon Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VenueList.h"

@interface BooserViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UILabel *locatingLabel;
    IBOutlet UITableView *mainTable;
}

@property (nonatomic,retain) VenueList *vList;
@property (nonatomic,retain) IBOutlet UILabel *locatingLabel;
@property (nonatomic,retain) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSArray *tableData;

- (void)prepareForRequest;

@end
