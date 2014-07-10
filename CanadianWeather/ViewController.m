//
//  ViewController.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "ViewController.h"
#import "WeatherDataController.h"


@interface ViewController ()
            

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)getWeatherBtnTapped:(id)sender {

    // get latest weather data, cache and forward to display view controller
    WeatherDataController *weatherDataController = [[WeatherDataController alloc] init];
    [weatherDataController refreshLocalDataWithForce:YES];

}

@end
