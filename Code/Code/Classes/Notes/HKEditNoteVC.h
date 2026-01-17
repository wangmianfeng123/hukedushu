//
//  HKEditNoteVC.h
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class DetailModel ,HKNotesModel;

@interface HKEditNoteVC : HKBaseVC
@property (nonatomic , strong) UIImage * img;
@property (nonatomic , strong) DetailModel * videoModel;
@property (nonatomic , assign) NSInteger currentTime ;
@property (nonatomic , strong)  HKNotesModel* noteModel;
@property (nonatomic , strong) void(^editNoteBlock)(HKNotesModel* noteModel);

@end

NS_ASSUME_NONNULL_END
