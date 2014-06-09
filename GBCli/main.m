//
//  main.m
//  GBCli
//
//  Created by Tomaž Kragelj on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GBSettings+Application.h"
#import "GBCli.h"

void registerOptions(GBOptionsHelper *options) {
	[options registerSeparator:@"OPTIONS:"];
	
	[options registerOption:0 long:GBSettingKeys.printSettings description:@"Print settings for current run" flags:GBOptionNoValue];
	[options registerOption:'v' long:GBSettingKeys.printVersion description:@"Display version and exit" flags:GBValueNone|GBOptionNoPrint];
	[options registerOption:'?' long:GBSettingKeys.printHelp description:@"Diusplay this help and exit" flags:GBValueNone|GBOptionNoPrint];
	
	[options registerSeparator:@"COMMANDS:"];
	
	[options registerGroup:@"project" description:@"[PROJECT OPTIONS]:" optionsBlock:^(GBOptionsHelper *options) {
		[options registerOption:'p' long:GBSettingKeys.projectName description:@"Project name" flags:GBOptionRequiredValue];
		[options registerOption:'n' long:GBSettingKeys.projectVersion description:@"Project version" flags:GBOptionRequiredValue];
	}];
	
	[options registerGroup:@"path" description:@"[PATH OPTIONS]:" optionsBlock:^(GBOptionsHelper *options) {
		[options registerOption:'o' long:GBSettingKeys.outputPaths description:@"Output path, repeat for multiple paths" flags:GBOptionRequiredValue];
	}];
}

int main(int argc, char * argv[]) {
	@autoreleasepool {
		// Initialize settings stack.
		GBSettings *factoryDefaults = [GBSettings mySettingsWithName:@"Factory" parent:nil];
		GBSettings *fileSettings = [GBSettings mySettingsWithName:@"File" parent:factoryDefaults];
		GBSettings *settings = [GBSettings mySettingsWithName:@"CmdLine" parent:fileSettings];
		[factoryDefaults applyFactoryDefaults];
		[fileSettings loadSettingsFromPlist:[@"~/Downloads/mysettings.plist" stringByStandardizingPath] error:nil];
		
		// Initialize options helper class and prepare injection strings.
		GBOptionsHelper *options = [[GBOptionsHelper alloc] init];		
		options.applicationVersion = ^{ return @"1.0"; };
		options.applicationBuild = ^{ return @"100"; };
		options.printValuesHeader = ^{ return @"%APPNAME version %APPVERSION (build %APPBUILD)\n"; };
		options.printValuesArgumentsHeader = ^{ return @"Running with arguments:\n"; };
		options.printValuesOptionsHeader = ^{ return @"Running with options:\n"; };
		options.printValuesFooter = ^{ return @"\nEnd of values print...\n"; };
		options.printHelpHeader = ^{ return @"Usage %APPNAME [OPTIONS] [COMMAND [COMMAND OPTIONS]] <arguments separated by space>"; };
		options.printHelpFooter = ^{ return @"\nSwitches that don't accept value can use negative form with --no-<name> or --<name>=0 prefix."; };
		registerOptions(options);

		// Initialize command line parser and register it with all options from helper. Then parse command line.
		GBCommandLineParser *parser = [[GBCommandLineParser alloc] init];
		[parser registerSettings:settings];
		[parser registerOptions:options];
		if (![parser parseOptionsWithArguments:argv count:argc]) {
			gbprintln(@"Errors in command line parameters!");
			gbprintln(@"");
			[options printHelp];
			return 1;
		}
		
		// NOTE: from here on, you can forget about GBOptionsHelper or GBCommandLineParser and only deal with GBSettings...
		
		// Print help or version if instructed - print help if there's no cmd line argument also...
		if (settings.printHelp || argc == 1) {

			[options printHelp];
			return 0;
		}
		if (settings.printVersion) {
			[options printHelp];
			return 0;
		}		
		
		// Print settings if necessary.
		if (settings.printSettings) {
			[options printValuesFromSettings:settings];
		}
	}
    return 0;
}
