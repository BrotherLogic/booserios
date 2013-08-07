//
//  BooserViewController.m
//  Booser
//
//  Created by Simon Tucker on 22/06/2013.
//  Copyright (c) 2013 Simon Tucker. All rights reserved.
//

#import "BooserViewController.h"
#import "VenueList.h"

#define FOURSQUARE_BASE           @"https://api.foursquare.com/v2/"

@interface BooserViewController ()

@end

@implementation BooserViewController

@synthesize locatingLabel;
@synthesize locationManager;
@synthesize receivedData;
@synthesize state;
@synthesize tableData;
@synthesize mainTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    state = @"venue";
    
    locatingLabel.text = @"Loaded";
    NSLog(@"Done Load");
    mainTable.delegate = self;
        
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //Stop receiving updates
    if(newLocation.horizontalAccuracy <= 100.0f)
    {
        NSLog(@"Stopping updates");
        [locationManager stopUpdatingLocation];
    }
    
    locatingLabel.text = [NSString stringWithFormat:@"%1.4f,%1.4f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    NSLog(locatingLabel.text);
    [self searchVenues:newLocation.coordinate];
    //[self getVenue:@"Blah"];
    
    //Refresh the table view
    NSLog(@"Reloading");
    [mainTable setNeedsDisplay];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    NSLog(@"Received Response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data]; 
    NSLog([NSString stringWithFormat:@"Received Data %d",[receivedData length]]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSLog([NSString stringWithFormat:@"HERE: %@",[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]]);
    NSLog(@"Was above but %d",[receivedData length]);
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:receivedData
                 options:0
                 error:&error];
    if (!error)
    {
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            NSLog(@"Got the dictionary");
        }
        else if ([object isKindOfClass:[NSArray class]]){
            NSLog(@"Got something array");
            
            if ([state isEqualToString:@"venue"]){

                //Get the top entry and display instead of coordinates
                NSArray *array = object;
                VenueList *vList = [[VenueList alloc] initListWithData:array];
                NSLog([NSString stringWithFormat:@"blah %@",vList]);
                [mainTable setDataSource:vList];
                mainTable.dataSource = vList;
                
                NSLog(@"Set the data source");
                NSLog([NSString stringWithFormat:@"blaaah %@",[mainTable dataSource]]);
                
                NSDictionary *top = [array objectAtIndex:0];
                locatingLabel.text = [top objectForKey:@"name"];
                
               // state = @"beers";
               // [self getVenue:[top objectForKey:@"id"]];
            }
        }
        else{
            NSLog(@"Got something else");
        }
    }
    else
    {
        NSLog([NSString stringWithFormat:@"Found an error: %@",[error localizedDescription]]);
        NSLog([NSString stringWithFormat:@"ERROR: %@",[error localizedRecoverySuggestion]]);
    }
}

- (void)searchVenues:(CLLocationCoordinate2D) coords {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Create the request.
    NSString *webRequest = [NSString stringWithFormat:@"http://booser-beautiful.rhcloud.com/API?action=getVenue&lat=%1.6f&lon=%1.6f&notoken=true",coords.latitude,coords.longitude];
    NSLog(webRequest);
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:webRequest]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
   
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    receivedData = [[NSMutableData alloc]init];
}

- (void)getVenue:(NSString *) vid {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Create the request.
    vid = @"4792385cf964a520524d1fe3";
    NSString *webRequest = [NSString stringWithFormat:@"http://booser-beautiful.rhcloud.com/API?action=venueDetails&vid=%@&notoken=true",vid];
    NSLog(webRequest);
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:webRequest]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // create the connection with the request
    // and start loading the data
    receivedData = [[NSMutableData alloc]init];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"Sent request");
}

@end
