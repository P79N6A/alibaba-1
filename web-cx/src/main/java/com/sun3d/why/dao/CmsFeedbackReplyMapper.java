package com.sun3d.why.dao;

import com.sun3d.why.model.CmsFeedbackReply;

public interface CmsFeedbackReplyMapper {
    int deleteByPrimaryKey(String replyId);
    int addFeedbackReply(CmsFeedbackReply record);
    CmsFeedbackReply queryFeedbackReplyById(String replyId);
    CmsFeedbackReply queryFeedbackReplyByFeedBackId(String feedBackId);
    int editFeedbackReply(CmsFeedbackReply record);
}