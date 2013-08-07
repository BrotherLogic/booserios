//
//  VenueList.h
//  Booser
//
//  Created by Simon Tucker on 05/08/2013.
//  Copyright (c) 2013 Simon Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface VenueList : NSObject <UITableViewDataSource>
{
    
}

- (id)initListWithData: (NSArray *) data;

@property (nonatomic,retain) NSArray *tableData;

@end
