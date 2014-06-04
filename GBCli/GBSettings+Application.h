//
//  GBSettings+Application.h
//  GBCli
//
//  Created by Tomaž Kragelj on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GBSettings.h"

/** This GBSettings category simplifies application settings.
 
 It basically maps all application specific settings to simple property based API. It's not required, but makes the rest of the application simpler - instead of using keys, we can use properties. Note that there's also custom initializer - it takes care of registering metadata such as keys that should be treated as arrays.
 */
@interface GBSettings (Application)

#pragma mark - Initialization & disposal

+ (instancetype)mySettingsWithName:(NSString *)name parent:(GBSettings *)parent;

#pragma mark - Project information

@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *projectVersion;

#pragma mark - Paths

@property (nonatomic, strong) NSArray *inputPaths;
@property (nonatomic, strong) NSArray *outputPaths;

#pragma mark - Debugging aid

@property (nonatomic, assign) BOOL printSettings;
@property (nonatomic, assign) BOOL printVersion;
@property (nonatomic, assign) BOOL printHelp;

@end

#pragma mark - 

/** This GBSettings category adds methods for dealing with common values.
 
 For this example tool, it only provides single line interface for applying factory defaults, but in real tool, it can easily be extended with other common behavior such as reading settings from a file etc.
 
 @warning **Note:** The whole functionality could also be implemented in GBSettings(Application) category, but as it can grow substantially for more complex tools, it might result in a large and hard to maintain file, so I prefer to split into two distinct categories. But feel free to do it whatever way works for you.
 */
@interface GBSettings (Helpers)

- (void)applyFactoryDefaults;

@end

#pragma mark - 

/** Defines all the keys so we can access them programmatically and still have compiler check our typos.
 
 Instead of using namespaced constants, you can also use `const NSString *` declarations, but I prefer this way - it's faster with code sense...
 */
extern const struct GBSettingKeys {
	__unsafe_unretained NSString *projectName;
	__unsafe_unretained NSString *projectVersion;
	__unsafe_unretained NSString *inputPaths;
	__unsafe_unretained NSString *outputPaths;
	__unsafe_unretained NSString *printSettings;
	__unsafe_unretained NSString *printVersion;
	__unsafe_unretained NSString *printHelp;
} GBSettingKeys;
