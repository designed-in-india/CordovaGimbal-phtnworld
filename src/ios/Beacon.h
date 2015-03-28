//
//  Beacon.h
//  CustomPlugin
//
//  Created by Leo on 26/03/15.
//
//

#import <Cordova/CDVPlugin.h>

@interface Beacon : CDVPlugin

- (void) open:(CDVInvokedUrlCommand*)command;
- (void) initializeBeacon:(CDVInvokedUrlCommand*)command;
- (void) copyFileFromBundle:(CDVInvokedUrlCommand*)command;

@end

@interface AppDelegate : Beacon

@end