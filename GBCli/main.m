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

void registerOptions(GBOptionsHelper *options) {
	GBOptionDefinition definitions[] = {
		{ 0,	nil,							@"PROJECT INFO",											GBOptionSeparator },
		{ 'p',	GBSettingKeys.projectName,		@"Project name",											GBValueRequired },
		{ 'v',	GBSettingKeys.projectVersion,	@"Project version",											GBValueRequired },
		
		{ 0,	nil,							@"PATHS",													GBOptionSeparator },
		{ 'o',	GBSettingKeys.outputPaths,		@"Output path, repeat for multiple paths",					GBValueRequired },	
		
		{ 0,	nil,							@"MISCELLANEOUS",											GBOptionSeparator },
		{ 0,	GBSettingKeys.printSettings,	@"Print settings for current run",							GBValueNone },
		{ 'v',	GBSettingKeys.printVersion,		@"Display version and exit",								GBValueNone|GBOptionNoPrint },
		{ '?',	GBSettingKeys.printHelp,		@"Display this help and exit",								GBValueNone|GBOptionNoPrint },
		
		{ 0, nil, nil, 0 }
	};
	[options registerOptionsFromDefinitions:definitions];
}

int main(int argc, char * argv[]) {
	@autoreleasepool {
		// Initialize settings stack.
		GBSettings *factoryDefaults = [GBSettings mySettingsWithName:@"Factory" parent:nil];
		GBSettings *settings = [GBSettings mySettingsWithName:@"CmdLine" parent:factoryDefaults];
		[factoryDefaults applyFactoryDefaults];
		
		// Initialize options helper class and prepare injection strings.
		GBOptionsHelper *options = [[GBOptionsHelper alloc] init];		
		options.applicationVersion = ^{ return @"1.0"; };
		options.applicationBuild = ^{ return @"100"; };
		options.printValuesHeader = ^{ return @"%APPNAME version %APPVERSION (build %APPBUILD)\n"; };
		options.printValuesArgumentsHeader = ^{ return @"Running with arguments:\n"; };
		options.printValuesOptionsHeader = ^{ return @"Running with options:\n"; };
		options.printValuesFooter = ^{ return @"\nEnd of values print...\n"; };
		options.printHelpHeader = ^{ return @"Usage %APPNAME [OPTIONS] <arguments separated by space>"; };
		options.printHelpFooter = ^{ return @"\nSwitches that don't accept value can use negative form with --no-<name> or --<name>=0 prefix."; };
		registerOptions(options);
		
		// Initialize command line parser and register it with all options from helper. Then parse command line.
		GBCommandLineParser *parser = [[GBCommandLineParser alloc] init];		
		[options registerOptionsToCommandLineParser:parser];
		__block BOOL commandLineValid = YES;
		[parser parseOptionsWithArguments:argv count:argc block:^(GBParseFlags flags, NSString *option, id value, BOOL *stop) {
			switch (flags) {
				case GBParseFlagUnknownOption:
					printf("Unknown command line option %s, try --help!\n", option.UTF8String);
					commandLineValid = NO;
					break;
				case GBParseFlagMissingValue:
					printf("Missing value for command line option %s, try --help!\n", option.UTF8String);
					commandLineValid = NO;
					break;
				case GBParseFlagArgument:
					[settings addArgument:value];
					break;
				case GBParseFlagOption:
					[settings setObject:value forKey:option];
					break;
			}
		}];
		if (!commandLineValid) return 1;
		
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
