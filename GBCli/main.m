//
//  main.m
//  GBCli
//
//  Created by Tomaž Kragelj on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GBSettings+Application.h"
#import "GBCommandLineParser.h"
#import "GBOptionsHelper.h"

GBOptionDefinition GBOptionDefinitions[] = {
	{ 0,	nil,					@"PROJECT INFO",											GBOptionSeparator|GBOptionNoCmdLine },
	{ 'p',	@"project-name",		@"Project name",											GBValueRequired },
	{ 'v',	@"project-version",		@"Project version",											GBValueRequired },
	
	{ 0,	nil,					@"PATHS",													GBOptionSeparator|GBOptionNoCmdLine },
	{ 'o',	@"output",				@"Output path, repeat for multiple paths",					GBValueRequired },	
	
	{ 0,	nil,					@"MISCELLANEOUS",											GBOptionSeparator|GBOptionNoCmdLine },
	{ 0,	@"print-settings",		@"Print settings for current run",							GBValueNone },
	{ 'v',	@"version",				@"Display version and exit",								GBValueNone|GBOptionNoPrint },
	{ '?',	@"help",				@"Display this help and exit",								GBValueNone|GBOptionNoPrint },
	
	{ 0, nil, nil, 0 }
};

int main(int argc, char * argv[]) {
	@autoreleasepool {
		// Initialize settings stack.
		GBSettings *factoryDefaults = [GBSettings mySettingsWithName:@"Factory" parent:nil];
		GBSettings *settings = [GBSettings mySettingsWithName:@"CmdLine" parent:factoryDefaults];
		
		// Initialize options helper class.
		GBOptionsHelper *options = [[GBOptionsHelper alloc] init];
		options.applicationVersion = ^{ return @"1.0"; };
		options.applicationBuild = ^{ return @"100"; };
		options.printValuesHeader = ^{ return @"%APPNAME version %APPVERSION (build %APPBUILD)\n"; };
		options.printValuesArgumentsHeader = ^{ return @"Running with arguments:\n"; };
		options.printValuesOptionsHeader = ^{ return @"Running with options:\n"; };
		options.printValuesFooter = ^{ return @"\nEnd of values print...\n"; };
		options.printHelpHeader = ^{ return @"Usage %APPNAME [OPTIONS] <arguments separated by space>"; };
		options.printHelpFooter = ^{ return @"\nSwitches that don't accept value can use negative form with --no-<name> prefix."; };
		[options registerOptionsFromDefinitions:GBOptionDefinitions];
		
		// Initialize command line parser and parse cmd line.
		GBCommandLineParser *parser = [[GBCommandLineParser alloc] init];
		[options registerOptionsToCommandLineParser:parser];		
		__block BOOL commandLineValid = YES;
		__block BOOL finished = NO;
		[parser parseOptionsWithArguments:argv count:argc block:^(GBParseFlags flags, NSString *option, id value, BOOL *stop) {
			switch (flags) {
				case GBParseFlagUnknownOption:
					printf("Unknown command line option %s!\n", option.UTF8String);
					commandLineValid = NO;
					break;
				case GBParseFlagMissingValue:
					printf("Missing value for command line option %s!\n", option.UTF8String);
					commandLineValid = NO;
					break;
				case GBParseFlagArgument:
					[settings addArgument:value];
					break;
				case GBParseFlagOption:
					if ([option isEqualToString:@"version"]) {
						[options printVersion];
						finished = YES;
						*stop = YES;
					} else if ([option isEqualToString:@"help"]) {
						[options printHelp];
						finished = YES;
						*stop = YES;
					} else {
						[settings setObject:value forKey:option];
					}
					break;
			}
		}];
		if (finished) return 0;
		if (!commandLineValid) return 1;
		
		// Apply factory defaults and print settings if necessary.
		[factoryDefaults applyFactoryDefaults];
		if (settings.printSettings) [options printValuesFromSettings:settings];
	}
    return 0;
}
