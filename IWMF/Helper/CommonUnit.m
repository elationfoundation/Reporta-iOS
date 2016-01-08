//
//  CommonUnit.m
//  IWMF
//
//
//
//

#import "IWMF-Swift.h"
#import "CommonUnit.h"

@implementation CommonUnit

+(void)encryptFile:(NSString *)filePath EncryptionKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    [data encryptWithKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    NSError * error;
    [data writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&error];
    data = nil;
}

+(void)decryptFile:(NSString *)filePath DecryptionKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    [data decryptWithKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    NSError * error;
    [data writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
    data = nil;
}

+(NSData *)getDataFromEncryptedFile:(NSString*)dirName fileName:(NSString*)fileName decryptionKey:(NSString *)key
{
    NSData *responseData = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [docDirectory stringByAppendingFormat:@"%@%@",dirName,fileName];
    NSString *dirPath = [docDirectory stringByAppendingFormat:@"%@",dirName];    
    BOOL isDir = YES;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];    
    if (fileExists)
    {
        if ([[NSFileManager defaultManager]fileExistsAtPath:fullPath])
        {
            [self decryptFile:fullPath DecryptionKey:key];
            responseData = [[NSData alloc] initWithContentsOfFile:fullPath];
            [self encryptFile:fullPath EncryptionKey:key];
            return responseData;
        }
        else
        {
            return responseData;
        }
    }
    else
    {
        return responseData;
    }
}

+(NSString *)getStingFromArray:(NSMutableArray *)arr join:(NSString *)str
{
    NSString *joinedString = [arr componentsJoinedByString:str];
    return joinedString;
}

+(BOOL)isIphone4
{
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f) {
        return true;
    }
    else{
        return false;
    }
}

+(BOOL)isIphone5
{
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
        return true;
    }
    else{
        return false;
    }
}

+(BOOL)isIphone6
{
    if ([[UIScreen mainScreen] bounds].size.height == 667.0f) {
        return true;
    }
    else{
        return false;
    }
}
+(BOOL)isIphone6plus
{
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f) {
        return true;
    }
    else{
        return false;
    }
}

+(NSBundle *)setLanguage:(NSString*)language
{
    NSString *strTemp = @"en";
    if ([language isEqualToString:@"ES"])
    {
        strTemp = @"es";
    }
    else if ([language isEqualToString:@"AR"])
    {
        strTemp = @"ar";
    }
    else if ([language isEqualToString:@"TR"])
    {
        strTemp = @"tr";
    }

    else if ([language isEqualToString:@"FR"])
    {
        strTemp = @"fr";
    }
    else if ([language isEqualToString:@"IW"])
    {
        strTemp = @"he";
    }
    else
    {
        strTemp = @"en";
    }

    NSBundle *currentLanguageBundle= [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:strTemp ofType:@"lproj"]];
    return  currentLanguageBundle;
}

#pragma mark -Archived File Funtions
+(void)saveDataWithKey:(NSString *)key InFile:(NSString *)file List:(NSMutableArray *)list
{
    @autoreleasepool {
        @synchronized(self)
        {
            NSFileManager *filemgr;
            NSString *docsDir;
            NSArray *dirPaths;
            
            filemgr = [NSFileManager defaultManager];
            
            // Get the documents directory
            dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            docsDir = [dirPaths objectAtIndex:0];
            
            // Build the path to the data file
            NSString * dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:file]];
            
            // Check if the file already exists
            if ([filemgr fileExistsAtPath: dataFilePath] == NO)
                [[NSFileManager defaultManager] createFileAtPath:dataFilePath contents:nil attributes:[NSDictionary dictionaryWithObject: NSFileProtectionComplete forKey: NSFileProtectionKey]];
            NSMutableDictionary *sessions = nil;
            sessions = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath];
            if (sessions == nil)
                sessions = [[NSMutableDictionary alloc] init];
            [sessions setObject:list forKey:key];
            [NSKeyedArchiver archiveRootObject:sessions toFile:dataFilePath];
            dataFilePath = nil;
        }
    }
}

+(void)appendDataWithKey:(NSString *)key InFile:(NSString *)file List:(NSMutableArray *)list
{
    @autoreleasepool {
        @synchronized(self)
        {
            NSMutableArray * vod = nil;
            NSFileManager *filemgr;
            NSString *docsDir;
            NSArray *dirPaths;
            filemgr = [NSFileManager defaultManager];
            // Get the documents directory
            dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            docsDir = [dirPaths objectAtIndex:0];
            // Build the path to the data file
            
            NSString * dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:file]];
            // Check if the file already exists
            if ([filemgr fileExistsAtPath: dataFilePath])
            {
                NSMutableDictionary *sessions;
                sessions = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
                vod = [NSMutableArray arrayWithArray:[sessions objectForKey:key]];
                [vod addObjectsFromArray:list];
                [sessions setObject:vod forKey:key];
                [NSKeyedArchiver archiveRootObject:sessions toFile:dataFilePath];
            }
            else
            {
                [CommonUnit saveDataWithKey:key InFile:file List:list];
                
            }
            dataFilePath = nil;
        }
    }
}

+(NSMutableArray *)getDataFroKey:(NSString *)key FromFile:(NSString *)file
{
    @autoreleasepool {
        @synchronized(self)
        {
            NSMutableArray * vod = nil;
            
            NSFileManager *filemgr;
            NSString *docsDir;
            NSArray *dirPaths;
            
            filemgr = [NSFileManager defaultManager];
            
            // Get the documents directory
            dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            
            docsDir = [dirPaths objectAtIndex:0];
            
            // Build the path to the data file
            
            NSString * dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:file]];
            // Check if the file already exists
            if ([filemgr fileExistsAtPath: dataFilePath])
            {
                NSDictionary *sessions;
                sessions = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
                vod = [NSMutableArray arrayWithArray:[sessions objectForKey:key]];
            }
            else
            {
                
            }
            dataFilePath = nil;
            return vod;
        }
        
    }
}

+(void)removeDataForKey:(NSString *)key FromFile:(NSString *)file
{
    @autoreleasepool {
        @synchronized(self)
        {
            NSFileManager *filemgr;
            NSString *docsDir;
            NSArray *dirPaths;
            
            filemgr = [NSFileManager defaultManager];
            
            // Get the documents directory
            
            dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            
            docsDir = [dirPaths objectAtIndex:0];
            
            // Build the path to the data file
            
            NSString * dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:file]];
            // Check if the file already exists
            if ([filemgr fileExistsAtPath: dataFilePath])
            {
                NSMutableDictionary *sessions;
                sessions = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
                [sessions removeObjectForKey:key];
                [NSKeyedArchiver archiveRootObject:sessions toFile:dataFilePath];
            }
            else
            {
            }
            dataFilePath = nil;
        }
        
    }
}

+(void)removeFile:(NSString *)mideaName ForKey:(NSString *)key FromFile:(NSString *)file
{
    @autoreleasepool {
        @synchronized(self)
        {
            NSMutableArray * vod = nil;
            NSFileManager *filemgr;
            NSString *docsDir;
            NSArray *dirPaths;
            filemgr = [NSFileManager defaultManager];
            
            // Get the documents directory
            
            dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            
            docsDir = [dirPaths objectAtIndex:0];
            
            // Build the path to the data file
            
            NSString * dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:file]];
            // Check if the file already exists
            if ([filemgr fileExistsAtPath: dataFilePath])
            {
                NSMutableDictionary *sessions;
                sessions = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
                vod = [NSMutableArray arrayWithArray:[sessions objectForKey:key]];
                for (Media *media in [vod copy]){
                    if ([media.name isEqualToString:mideaName]){
                        [vod removeObject:media];
                        break;
                    }
                }
                [sessions setObject:vod forKey:key];
                [NSKeyedArchiver archiveRootObject:sessions toFile:dataFilePath];
            }
            else
            {
            }
            dataFilePath = nil;
        }
    }
}


+(void)deleteSingleFile:(NSString *)strFileName FromDirectory:(NSString*)dirName{    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *dirPath = [docDirectory stringByAppendingFormat:@"%@",dirName];
    NSString *fullPath = [dirPath stringByAppendingPathComponent:strFileName];
    [fileMgr removeItemAtPath:fullPath error:NULL];
}
+(void)deleteSingleAudioFile:(NSString *)strFileName{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:strFileName error:NULL];
}

+(UIImage *)getImageStoredLocallyName:(NSString *)imageName dir:(NSString *)dir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];    
    NSString *filePath = [docDirectory stringByAppendingFormat:@"%@",imageName];
    NSError *err;
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingUncached
                                            error:&err];
    return [UIImage imageWithData:data];
}

+(NSData*)readFileDataFromDirectory:(NSString*)dirName fileName:(NSString*)fileName
{
    NSData *responseData = nil;    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [docDirectory stringByAppendingFormat:@"%@%@",dirName,fileName];
    NSString *dirPath = [docDirectory stringByAppendingFormat:@"%@",dirName];    
    BOOL isDir = YES;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];    
    if (fileExists)
    {
        if ([[NSFileManager defaultManager]fileExistsAtPath:fullPath])
        {
            responseData = [[NSData alloc] initWithContentsOfFile:fullPath];
            return responseData;
        }
        else
        {
            return responseData;
        }
    }
    else
    {
        return responseData;
    }
}
+(void)storeVideo:(NSString *)strName urlstring:(NSString *)stringURL dirName:(NSString *)dirName encryptionKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];    
    docDirectory = [docDirectory stringByAppendingFormat:@"%@",dirName];
    NSString *filePath = [docDirectory stringByAppendingFormat:@"%@",strName];
    BOOL isDir = YES;
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:docDirectory isDirectory:&isDir];    
    if (dirExists)
    {
        /////// folder exist
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath])
        {
            NSData *videoData = [NSData dataWithContentsOfFile:stringURL];
            
            NSError * error;
            [videoData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&error];
            
            [self encryptFile:filePath EncryptionKey:key];
            
        }
        else
        {
            [CommonUnit deleteSingleFile:strName FromDirectory:dirName];
            NSData *videoData = [NSData dataWithContentsOfFile:stringURL];
            NSError * error;
            [videoData writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
            [self encryptFile:filePath EncryptionKey:key];
            
        }
    }
    else
    {
        NSData *videoData = [NSData dataWithContentsOfFile:stringURL];
        NSError *err = nil;
        [[NSFileManager defaultManager]createDirectoryAtPath:docDirectory withIntermediateDirectories:YES attributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey: NSFileProtectionKey] error:&err];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:[NSDictionary dictionaryWithObject: NSFileProtectionComplete forKey: NSFileProtectionKey]];
        NSError * error;
        [videoData writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
        [self encryptFile:filePath EncryptionKey:key];
    }
}

+(void)storeImage:(UIImage *)Image withName:(NSString *)fileName inDirectory:(NSString *)dirName encryptionKey:(NSString *)key;
{
    UIImage *targetImage = [CommonUnit getImageDataWithSaclingComprasion:Image];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    docDirectory = [docDirectory stringByAppendingFormat:@"%@",dirName];
    BOOL isDir = YES;
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:docDirectory isDirectory:&isDir];
    if (!dirExists)
    {
        NSError *err = nil;
        [[NSFileManager defaultManager]createDirectoryAtPath:docDirectory withIntermediateDirectories:YES attributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey] error:&err];
    }
    NSString *filePath = [docDirectory stringByAppendingFormat:@"%@",fileName];
    NSError * error;
    [UIImageJPEGRepresentation(targetImage, 1.0) writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
    [self encryptFile:filePath EncryptionKey:key];
}

+(void)storeAudio:(NSString *)strName urlstring:(NSString *)stringURL dirName:(NSString *)dirName encryptionKey:(NSString *)key
{    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];    
    docDirectory = [docDirectory stringByAppendingFormat:@"%@",dirName];
    NSString *filePath = [docDirectory stringByAppendingFormat:@"%@",strName];
    BOOL isDir = YES;
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:docDirectory isDirectory:&isDir];
    NSError * error;
    if (dirExists)
    {
        /////// folder exist
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath])
        {
            NSData *audioData = [NSData dataWithContentsOfFile:stringURL];
            [audioData writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
            [self encryptFile:filePath EncryptionKey:key];
        }
        else
        {
            [CommonUnit deleteSingleFile:strName FromDirectory:dirName];
            NSData *audioData = [NSData dataWithContentsOfFile:stringURL];
            [audioData writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
            [self encryptFile:filePath EncryptionKey:key];
        }
    }
    else
    {
        NSData *audioData = [NSData dataWithContentsOfFile:stringURL];
        NSError *err = nil;
        [[NSFileManager defaultManager]createDirectoryAtPath:docDirectory withIntermediateDirectories:YES attributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey] error:&err];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:[NSDictionary dictionaryWithObject: NSFileProtectionComplete forKey: NSFileProtectionKey]];
        [audioData writeToFile:filePath  options:NSDataWritingFileProtectionComplete error:&error];
        [self encryptFile:filePath EncryptionKey:key];
    }
}
+(UIImage *)getImageDataWithSaclingComprasion:(UIImage *)img
{    
    if(img.size.width > 2000 || img.size.height>2000)
    {
        img =[CommonUnit compressForUpload:0.2 image:img];
        
    }
    else if(img.size.width > 1500 || img.size.height>1500)
    {
        img =[CommonUnit compressForUpload:0.3 image:img];
        
    }
    else if(img.size.width > 1000 || img.size.height>1000)
    {
        img =[CommonUnit compressForUpload:0.4 image:img];
        
    }
    else if(img.size.width > 750 || img.size.height>750)
    {
        img =[CommonUnit compressForUpload:0.5 image:img];
        
    }
    else if(img.size.width > 500 || img.size.height > 500)
    {
        img =[CommonUnit compressForUpload:0.6 image:img];
        
    }
    else if(img.size.width > 400 || img.size.height > 400)
    {
        img =[CommonUnit compressForUpload:0.7 image:img];
        
    }    
    NSData* imageData;
    imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((img),1.0)];    
    long imageSize = imageData.length;    
    if (imageSize > 900000) {
        imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.1)];
        img = [UIImage imageWithData:imageData];
        imageSize = imageData.length;
    }
    if (imageSize > 600000) {
        imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.3)];
        img = [UIImage imageWithData:imageData];
        
        imageSize = imageData.length;
    }
    if (imageSize > 400000) {
        imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.4)];
        img = [UIImage imageWithData:imageData];
        imageSize = imageData.length;
    }
    if (imageSize > 150000) {
        imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.4)];
        img = [UIImage imageWithData:imageData];
        imageSize = imageData.length;
    }
    if (imageSize > 50000) {
        imageData = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.6)];
        img = [UIImage imageWithData:imageData];
        
        imageSize = imageData.length;
    }
    return img;
}


+(UIImage *)compressForUpload:(CGFloat)scale image:(UIImage *)img
{
    // Calculate new size given scale factor.
    CGSize originalSize = img.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImage;
}
+( NSMutableDictionary  *)getSectionFromDictionary:(NSArray *)arr isAllConact:(BOOL)IsAllcontact
{
    NSMutableArray *sectionArray  = [[NSMutableArray alloc]init];
    NSMutableDictionary *dictContact=[[NSMutableDictionary alloc]init];    
    if (arr!=NULL && ![arr isKindOfClass:[NSNull class]])
    {
        for (NSDictionary *dict in arr)
        {
            NSString *str;
            if (IsAllcontact == true)
            {
                str = [dict valueForKey:@"lastname"];
                if (str.length != 0)
                {
                    str = [dict valueForKey:@"lastname"];
                }
                else
                {
                    str = [dict valueForKey:@"firstname"];
                }
            }
            else
            {
                str = [dict valueForKey:@"lastName"];
                if (str.length != 0)
                {
                    str = [dict valueForKey:@"lastName"];
                }
                else
                {
                    str = [dict valueForKey:@"firstName"];
                }
            }
            str = str.uppercaseString;
            
            if (str.length>0)
            {
                if (sectionArray.count>0)
                {
                    NSInteger i = [sectionArray indexOfObject:[[str substringToIndex:1] uppercaseString]];
                    if (i<sectionArray.count && i>=0)
                    {
                        NSMutableArray *temp = [NSMutableArray arrayWithArray:[dictContact valueForKey:[str substringToIndex:1].uppercaseString]];
                        [temp addObject:dict];
                        [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                    }
                    else
                    {
                        [sectionArray addObject:[str substringToIndex:1].uppercaseString];
                        NSMutableArray *temp = [[NSMutableArray alloc]initWithObjects:dict, nil];
                        [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                        
                    }
                }
                else
                {
                    [sectionArray addObject:[str substringToIndex:1].uppercaseString];
                    NSMutableArray *temp = [[NSMutableArray alloc]initWithObjects:dict, nil];
                    [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                }
            }
        }
    }
    return dictContact;
}

+( NSDictionary *)getSectionForCircleList:(NSArray *)arr
{
    NSMutableArray *sectionArray  = [[NSMutableArray alloc]init];
    NSMutableDictionary *dictContact=[[NSMutableDictionary alloc]init];    
    if (arr!=NULL && ![arr isKindOfClass:[NSNull class]])
    {
        for (NSDictionary *dict in arr)
        {
            NSString *str = [dict valueForKey:@"listname"];
            str = str.uppercaseString;
            if (str.length>0)
            {
                if (sectionArray.count>0)
                {
                    NSInteger i = [sectionArray indexOfObject:[str substringToIndex:1].uppercaseString];
                    if (i<sectionArray.count && i>=0)
                    {
                        NSMutableArray *temp = [NSMutableArray arrayWithArray:[dictContact valueForKey:[str substringToIndex:1].uppercaseString]];
                        [temp addObject:dict];
                        [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                    }
                    else
                    {
                        [sectionArray addObject:[str substringToIndex:1].uppercaseString];
                        NSMutableArray *temp = [[NSMutableArray alloc]initWithObjects:dict, nil];
                        [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                    }
                }
                else
                {
                    [sectionArray addObject:[str substringToIndex:1].uppercaseString];
                    NSMutableArray *temp = [[NSMutableArray alloc]initWithObjects:dict, nil];
                    [dictContact setObject:temp forKey:[str substringToIndex:1].uppercaseString];
                }
            }
        }
    }
    return dictContact;
}
+(NSMutableArray *)GetCountryList:(NSString *)LanguageCode
{
    NSString *filePath;
    if([LanguageCode isEqualToString:@"ES"]) {
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_es" ofType:@"txt"];
    }else if([LanguageCode isEqualToString:@"AR"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_ar" ofType:@"txt"];
    }else if([LanguageCode isEqualToString:@"TR"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_tr" ofType:@"txt"];
    }else if([LanguageCode isEqualToString:@"FR"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_fr" ofType:@"txt"];
    }else if([LanguageCode isEqualToString:@"IW"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_iw" ofType:@"txt"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"countrylist_en" ofType:@"txt"];
    }    
    NSMutableArray *arrCountry = [[NSMutableArray alloc]init];
    NSError* error = nil;
    NSData *responseObject = [NSData dataWithContentsOfFile:filePath];
    id jsonobject = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableLeaves error:&error];    
    arrCountry = (NSMutableArray *)jsonobject;
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"Title" ascending: YES];
    arrTemp = (NSMutableArray *)[arrCountry sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    return arrTemp;
}

+(NSMutableAttributedString *) boldSubstring:(NSString *)boldSubstring string:(NSString *)string fontName:(UIFont *)font{    
    UIColor *color = [UIColor blackColor];    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string] ;
    [attributedText setAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont boldSystemFontOfSize:font.pointSize]} range:[boldSubstring rangeOfString:boldSubstring]];
    return attributedText;
}

+(BOOL)isDeviceJailbroken
{    
#if !TARGET_IPHONE_SIMULATOR    
    //Apps and System check list
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Cyd", @"ia.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"bla", @"ckra1n.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Fake", @"Carrier.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Ic", @"y.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Inte", @"lliScreen.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"MxT", @"ube.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Roc", @"kApp.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"SBSet", @"ttings.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Wint", @"erBoard.a", @"pp"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/a", @"pt/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/c", @"ydia/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/mobile", @"Library/SBSettings", @"Themes/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/t", @"mp/cyd", @"ia.log"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/s", @"tash/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"us", @"r/b",@"in", @"s", @"shd"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"us", @"r/sb",@"in", @"s", @"shd"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/sftp-", @"server"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@",@"/Syste",@"tem/Lib",@"rary/Lau",@"nchDae",@"mons/com.ike",@"y.bbot.plist"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@%@",@"/Sy",@"stem/Lib",@"rary/Laun",@"chDae",@"mons/com.saur",@"ik.Cy",@"@dia.Star",@"tup.plist"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/Libr",@"ary/Mo",@"bileSubstra",@"te/MobileSubs",@"trate.dylib"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/va",@"r/c",@"ach",@"e/a",@"pt/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"ib",@"/apt/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"ib/c",@"ydia/"] isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"og/s",@"yslog"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/bi",@"n/b",@"ash"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/b",@"in/",@"sh"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/et",@"c/a",@"pt/"]isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/etc/s",@"sh/s",@"shd_config"]]
        || [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/us",@"r/li",@"bexe",@"c/ssh-k",@"eysign"]])
        
    {
        return YES;
    }    
    // SandBox Integrity Check
    int pid = fork();
    if(!pid){
        exit(0);
    }
    if(pid>=0)
    {
        return YES;
    }    
    //Symbolic link verification
    struct stat s;
    if(lstat("/Applications", &s) || lstat("/var/stash/Library/Ringtones", &s) || lstat("/var/stash/Library/Wallpaper", &s)
       || lstat("/var/stash/usr/include", &s) || lstat("/var/stash/usr/libexec", &s)  || lstat("/var/stash/usr/share", &s) || lstat("/var/stash/usr/arm-apple-darwin9", &s))
    {
        if(s.st_mode & S_IFLNK){
            return YES;
        }
    }    
    //Try to write file in private
    NSError *error;    
    [[NSString stringWithFormat:@"Jailbreak test string"]
     writeToFile:@"/private/test_jb.txt"
     atomically:YES
     encoding:NSUTF8StringEncoding error:&error];    
    if(nil==error){
        //Wrote?: JB device
        //cleanup what you wrote
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/test_jb.txt" error:nil];
        return YES;
    }
#endif
    return NO;
}
@end
