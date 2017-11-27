//
//  AttachmentModel.h
//  QiDongYinQing
//
//  Created by chenglei on 17/7/21.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachmentModel : NSObject

@property (nonatomic, strong) AttachmentModel *attachments;

@property(nonatomic,copy)NSString *fillFilePath;
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,copy)NSString *id;

@end
