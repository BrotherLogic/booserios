//
//  VenueList.m
//  Booser
//
//  Created by Simon Tucker on 05/08/2013.
//  Copyright (c) 2013 Simon Tucker. All rights reserved.
//

#import "VenueList.h"

@implementation VenueList

@synthesize tableData;

- (id)initListWithData: (NSArray *)data{
    NSLog(@"Init");
    self = [super init];
    tableData = data;
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"Blah Blah Blah");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Balls");
    //We only have a single section
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Requesting table");
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = @"Blah";
    return cell;
}


@end
