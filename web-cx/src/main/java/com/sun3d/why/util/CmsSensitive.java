package com.sun3d.why.util;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsSensitiveWords;
import com.sun3d.why.service.CmsSensitiveWordsService;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

/**
 * 敏感词评论公共方法
 */
public class CmsSensitive {

    public static String sensitiveWords(CmsComment comment, CmsSensitiveWordsMapper cmsSensitiveWordsMapper) {
         List<CmsSensitiveWords> cmsSensitiveWordsList=cmsSensitiveWordsMapper.queryAppSensitiveWordsList();
        if (cmsSensitiveWordsList!=null && cmsSensitiveWordsList.size() > 0) {
            for (CmsSensitiveWords sensitiveWords : cmsSensitiveWordsList) {
                if (comment.getCommentRemark().toLowerCase().contains(sensitiveWords.getSensitiveWords().toLowerCase())) {
                    return Constant.SensitiveWords_EXIST;
                }
            }
        }
                   return Constant.SensitiveWords_NOT_EXIST;
    }
}