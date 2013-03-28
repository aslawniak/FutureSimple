//
//  ViewController.m
//  FutureSimple
//
//  Created by Adrian Slawniak on 3/28/13.
//  Copyright (c) 2013 Adrian Slawniak. All rights reserved.
//

#import "ViewController.h"
#import "SBJson/SBJson.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize longitude, latitude, locManager;
@synthesize dataReceived;
@synthesize labPress, labTemp;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.dataReceived = [[NSMutableData alloc] init];
	
	self.locManager = [[CLLocationManager alloc] init];
	self.locManager.delegate = self;
	[self.locManager startUpdatingLocation];
	
	self.labPress = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 20.0, 200.0, 30.0)];
	[self.view addSubview:self.labPress];
	
	self.labTemp = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 60.0, 200.0, 30.0)];
	[self.view addSubview:self.labTemp];

}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	self.longitude = newLocation.coordinate.longitude;
	self.latitude = newLocation.coordinate.latitude;

	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.1/find/city?lat=%f&lon=%f&cnt=10",self.latitude, self.longitude]]];
	
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(!conn)
	{
		NSLog(@"connection did fail!!!");
	}
	
	[manager stopUpdatingLocation];
	
//http://api.openweathermap.org/data/2.1/find/city?lat=55&lon=37&cnt=10
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.dataReceived appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"connection did fail with error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	NSString *stringFromData = [[NSString alloc] initWithData:self.dataReceived encoding:NSUTF8StringEncoding];
	NSDictionary *jsonObjects = [parser objectWithString:stringFromData error:nil];
	
	NSArray *list = [jsonObjects valueForKey:@"list"];

	if(list.count > 0)
	{
		NSDictionary *main = [[list objectAtIndex:0] valueForKey:@"main"];
		float temp = [[main valueForKey:@"temp"] floatValue];
		float pressure = [[main valueForKey:@"pressure"] floatValue];
		
		if(temp)
		{
			float tempCels = temp - 273.15;
			self.labTemp.text = [NSString stringWithFormat:@"temp: %.2f", tempCels];
		}
		
		if(pressure)
		{
			self.labPress.text = [NSString stringWithFormat:@"press: %.2f", pressure];
		}
	}
	
	
	
}

@end
