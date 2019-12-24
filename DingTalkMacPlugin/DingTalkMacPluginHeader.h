//
//  DingTalkMacPluginHeader.h
//  DingTalkMacPlugin
//
//  Created by TozyZuo on 2018/9/25.
//  Copyright (c) 2018年 TozyZuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UnknownBlockType id

@interface DTEmotionViewController : NSObject

@end

@interface DTMojoServiceBase : NSObject
@property (strong) NSMutableArray *observers;
- (id)init;
- (void)addObserver:(id)arg1;
- (void)removeObserver:(id)arg1;

@end

@interface DTEmotionService : DTMojoServiceBase

@property (strong) NSMutableArray *defaultEmotionAll;
@property (strong) NSMutableArray *defaultEmotions;
@property (strong) id defaultEmotionPackage;

+ (id)sharedService;
- (BOOL)useDownloadDefaultEmotions;
- (id)defaultEmotionListForAll:(BOOL)arg1;
- (id)defaultEmotionsPackage;
- (id)getRecommendEmotionNames;
- (id)recentDefaultEmotion;
- (id)searchHistory;
- (void)checkDownloadDefaultEmotion:(BOOL)arg1;
- (void)checkRecommendEmotionVersion;
- (void)clearSearchHistory;
- (void)fetchDefaultEmotion;
- (void)loadBundleDefaultEmotion;
- (void)saveMyEmotionPackage:(id)arg1;
- (void)saveRecentDefaultEmotion:(id)arg1;
- (void)saveSearchHistory:(id)arg1;
- (void)sendMyPackageEmotionMessage:(id)arg1 mediaId:(id)arg2 emotionName:(id)arg3 emotionId:(long long)arg4 packageId:(long long)arg5;
- (void)sendRecommendEmotionMessage:(id)arg1 mediaId:(id)arg2 emotionName:(id)arg3;
- (void)updateRecommendEmotion;
- (void)updateTopicList;
@end

@interface DTEmotionPackage : NSObject
{
    NSArray *_emotions;
    NSString *_name;
    NSString *_packageId;
    NSImage *_packageImage;
    NSString *_packageImageMediaId;
}

@property (strong) NSArray *emotions;
@property (strong) NSString *name;
@property (strong) NSString *packageId;
@property (strong) NSImage *packageImage;
@property (strong) NSString *packageImageMediaId;

+ (void)initialize;
- (id)init;
- (BOOL)isEqual:(id)arg1;
- (id)defaultImage;
- (void)loadCustomEmotionImages;
- (void)loadDefaultEmotionImages;
- (void)loadDownloadDefaultEmotionImages;
- (void)loadEmotionImages;
- (void)loadLatestEmotionImages;
- (void)loadOtherEmotionImages;

@end

@interface DTEmotionInfo : NSObject
{
    BOOL _bShow;
    BOOL _isPraise;
    NSString *_activityComment;
    NSString *_emotionId;
    NSString *_emotionUrl;
    NSImage *_image;
    NSString *_localPath;
    NSString *_mediaId;
    NSString *_name;
    NSDictionary *_nameMulti;
    NSString *_packageId;
    NSString *_previewAuthMediaId;
}

@property BOOL bShow;
@property BOOL isPraise;
@property (strong) NSString *activityComment;
@property (strong) NSString *emotionId;
@property (strong) NSString *emotionUrl;
@property (strong) NSImage *image;
@property (strong) NSString *localPath;
@property (strong) NSString *mediaId;
@property (strong) NSString *name;
@property (strong) NSDictionary *nameMulti;
@property (strong) NSString *packageId;
@property (strong) NSString *previewAuthMediaId;

+ (id)emotionWithId:(id)arg1 name:(id)arg2 mediaId:(id)arg3;
- (BOOL)isEqual:(id)arg1;

@end

@interface DTChatInputTextView : NSTextView
{
    BOOL _bTypingUpdate;
    BOOL _isEditing;
    long long _replyAnswerId;
    long long _replyMid;
    NSAttributedString *_myPlaceholderString;
    NSString *_replyDingId;
    NSString *_replyMessageContent;
    NSString *_sourceMessageNickName;
    NSCache *_textLineMetricsCache;
}

@property (nonatomic) BOOL bTypingUpdate;
@property (nonatomic) BOOL isEditing;
@property long long replyAnswerId;
@property long long replyMid;
@property (copy) NSAttributedString *myPlaceholderString;
@property (copy) NSString *replyDingId;
@property (copy) NSString *replyMessageContent;
@property (copy) NSString *sourceMessageNickName;
@property (strong) NSCache *textLineMetricsCache;

@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (readonly, copy) NSString *debugDescription;
@property (readonly, copy) NSString *description;

+ (id)defaultFontAttributes;
- (BOOL)becomeFirstResponder;
- (BOOL)canSendTypingStatus;
- (unsigned long long)enabledTextCheckingTypes;
- (BOOL)getDraftDataForRichTextEditor:(id *)arg1 atList:(id *)arg2;
- (BOOL)isAutomaticQuoteSubstitutionEnabled;
- (BOOL)isAutomaticSpellingCorrectionEnabled;
- (BOOL)isAutomaticTextReplacementEnabled;
- (BOOL)isCopyFileFromPastboard;
- (BOOL)isCopyFilePathString;
- (BOOL)isCopyNumbersFromPastboard;
- (BOOL)isFileFromSouce:(id)arg1 sourceType:(id)arg2;
- (BOOL)isvalidEmojoFile:(id)arg1;
- (BOOL)layoutManager:(id)arg1 shouldSetLineFragmentRect:(inout struct CGRect *)arg2 lineFragmentUsedRect:(inout struct CGRect *)arg3 baselineOffset:(inout double *)arg4 inTextContainer:(id)arg5 forGlyphRange:(struct _NSRange)arg6;
- (BOOL)performDragOperation:(id)arg1;
- (BOOL)readSelectionFromPasteboard:(id)arg1 type:(id)arg2;
- (BOOL)sendLongTextAsFileMessage:(id)arg1;
- (BOOL)shouldNotDrawInTextViewWithPasteboard:(id)arg1;
- (BOOL)shouldShowAlertDialogForSafeConversation:(id)arg1;
- (BOOL)shouldShowPastContentDialog:(id)arg1 type:(id)arg2;
- (BOOL)textView:(id)arg1 doCommandBySelector:(SEL)arg2;
- (BOOL)textView:(id)arg1 writeCell:(id)arg2 atIndex:(unsigned long long)arg3 toPasteboard:(id)arg4 type:(id)arg5;
- (BOOL)validateUserInterfaceItem:(id)arg1;
- (BOOL)writeSelectionToPasteboard:(id)arg1 type:(id)arg2;
- (id)font;
- (id)getPlaceholderString;
- (id)imageBitMapDataFromPasteboard;
- (id)imagePathWithCell:(id)arg1 attachment:(id)arg2;
- (id)menuForEvent:(id)arg1;
- (id)sortFilesArrayBySize:(id)arg1;
- (id)textView:(id)arg1 menu:(id)arg2 forEvent:(id)arg3 atIndex:(unsigned long long)arg4;
- (id)textView:(id)arg1 writablePasteboardTypesForCell:(id)arg2 atIndex:(unsigned long long)arg3;
- (void)appendAtMember:(id)arg1 uid:(id)arg2;
- (void)awakeFromNib;
- (void)checkDefaultEmotions;
- (void)checkPasteboardIsWorking;
- (void)checkStringLengthAndSend:(id)arg1 option:(id)arg2;
- (void)clearReplyContent;
- (void)dealloc;
- (void)didChangeText;
- (void)doApplyFixedPasteboard;
- (void)draftChangedByExternNotification:(id)arg1;
- (void)draggingEnded:(id)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (void)handleAnnexForImageFile:(id)arg1;
- (void)handleAnnexForSelection:(id)arg1;
- (void)handleAtuserCell:(id)arg1 withDictionary:(id)arg2 attrString:(id)arg3 locValue:(unsigned long long)arg4 endValue:(unsigned long long *)arg5;
- (void)handleEmojoForSelection:(id)arg1 completionHandler:(id)arg2;
- (void)handleEmojoSelectResult:(id)arg1 completionHandler:(id)arg2;
- (void)handleEmotionCell:(id)arg1 attrString:(id)arg2 locValue:(unsigned long long)arg3 endValue:(unsigned long long *)arg4;
- (void)handleFixPasteboard:(id)arg1;
- (void)handleSelectResult:(int)arg1 openPanel:(id)arg2 needConfirmation:(BOOL)arg3 completionHandler:(id)arg4;
- (void)handleSendMessge:(id)arg1;
- (void)handleSendMessgeLoigc:(id)arg1;
- (void)insertAtMember:(id)arg1 uid:(id)arg2;
- (void)insertAtMember:(id)arg1 uid:(id)arg2 append:(BOOL)arg3;
- (void)insertAtMembers:(id)arg1;
- (void)insertAttributedString:(id)arg1;
- (void)insertAttributedString:(id)arg1 atRange:(struct _NSRange)arg2;
- (void)insertDefaultEmotion:(id)arg1 emotionId:(id)arg2;
- (void)insertDefaultEmotion:(id)arg1 emotionId:(id)arg2 packageId:(id)arg3;
- (void)insertImage:(id)arg1 withPath:(id)arg2 isGif:(BOOL)arg3;
- (void)insertMessageImage:(id)arg1;
- (void)insertNewline:(id)arg1;
- (void)insertQuoteMessage:(id)arg1 nick:(id)arg2 uid:(id)arg3 isSingleConversation:(BOOL)arg4;
- (void)insertReEditMessage:(id)arg1 atOpenIds:(id)arg2;
- (void)keyDown:(id)arg1;
- (void)makeReplyAnswerId:(long long)arg1;
- (void)makeReplyContent:(id)arg1 mid:(long long)arg2 dingId:(id)arg3 sourceName:(id)arg4;
- (void)mouseDown:(id)arg1;
- (void)notifyTextChanged;
- (void)paste:(id)arg1;
- (void)plainAttributedString:(id)arg1 completion:(UnknownBlockType)arg2;
- (void)plainMessageString:(UnknownBlockType)arg1;
- (void)pressDelete;
- (void)readSelectionFromAttributedString:(id)arg1;
- (void)resetReplyStatus;
- (void)resetTypingUpdateStatus;
- (void)restoreDraftForConversation:(id)arg1;
- (void)restoreReplyForConversation:(id)arg1;
- (void)saveDraftForConversation:(id)arg1;
- (void)saveImageAndInsertToInputTextView:(id)arg1;
- (void)saveImageAs:(id)arg1;
- (void)saveReplyForConversation:(id)arg1;
- (void)scrollToBeginningOfDocument:(id)arg1;
- (void)scrollToEndOfDocument:(id)arg1;
- (void)scrollToEndOfInputTextView;
- (void)sendFile:(int)arg1 withDelegate:(id)arg2 completionHandler:(UnknownBlockType)arg3;
- (void)sendFileByPath:(id)arg1;
- (void)sendFileMessageWithPath:(id)arg1 toConvModel:(id)arg2;
- (void)sendFileWithPath:(id)arg1;
- (void)sendImageAsNormalFile:(id)arg1;
- (void)sendImageMessage:(id)arg1;
- (void)sendImageMessageWithOption:(id)arg1;
- (void)sendImageWithPath:(id)arg1;
- (void)sendLinkCardMessage:(id)arg1;
- (void)sendMessage;
- (void)sendMessageByType:(int)arg1 body:(id)arg2 attrString:(id)arg3;
- (void)sendMessageByType:(int)arg1 body:(id)arg2 attrString:(id)arg3 toConversationModel:(id)arg4;
- (void)sendOrdinaryMessage:(id)arg1;
- (void)sendReplyMessageWithOriginMid:(long long)arg1 originMsg:(id)arg2 replyMsg:(id)arg3 atOpenIds:(id)arg4;
- (void)sendReplyMessageWithOriginMid:(long long)arg1 originMsg:(id)arg2 replyMsg:(id)arg3 option:(id)arg4;
- (void)sendSpaceFolderMessage:(id)arg1;
- (void)sendTextMessage:(id)arg1 option:(id)arg2;
- (void)sendTxtMessageWithOption:(id)arg1 attrString:(id)arg2;
- (void)setTypingAttributes:(id)arg1;
- (void)showAlertDialogForSafeConversation:(id)arg1 completation:(UnknownBlockType)arg2;
- (void)showMaxsizeErrorInfo:(id)arg1;
- (void)startTimerUpdateTypingStatus;
- (void)textDidBeginEditing:(id)arg1;
- (void)textDidEndEditing:(id)arg1;
- (void)translateInputText;
- (void)updateDraggingItemsForDrag:(id)arg1;
- (void)updateTypingStatus:(id)arg1;

@end

