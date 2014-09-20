//
//  ShowSimpleWeatherViewController.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-09-19.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "ShowSimpleWeatherViewController.h"
#import "WeatherDataController.h"


@interface ShowSimpleWeatherViewController ()

@property (strong, nonatomic) IBOutlet UITextView *weatherInformation;

@end

@implementation ShowSimpleWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([WeatherDataController sharedInstance].hasData) {
        self.weatherInformation.text = [WeatherDataController sharedInstance].currentWeatherData.description;

    } else {
        self.weatherInformation.text = @"No current data :-(";
    }
}



@end
