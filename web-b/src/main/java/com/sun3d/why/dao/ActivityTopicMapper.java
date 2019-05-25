package com.sun3d.why.dao;

import com.sun3d.why.model.topic.*;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/28.
 */
public interface ActivityTopicMapper
{

    int delActivityTopic(int topicid);

    int insertActivityTopic(ActivityTopic obj);

    int updateActivityTopic(ActivityTopic obj);

    ActivityTopic selectActivityTopic(int id);

    List<ActivityTopic> selectActivityTopicList();


    int delActivityTopicContent(int aid);

    int insertActivityTopicContent(Activity obj);

    int updateActivityTopicContent(Activity obj);

    Activity selectActivityTopicContent(int id);

    List<Activity> selectActivityTopicContentList(int tid);


    int delBlockContent(int id);

    int insertBlockContent(BlockContent obj);

    int delBlock(int id);

    int insertTopicBlock(Block obj);

    int updateBlockContent(BlockContent obj);

    BlockContent selectBlockContent(int id);

    Block  selectBlock(int id);

    List<Block> selectBlockList(int tid);

    List<BlockContent> selectBlockContentListByTopic(int tid);

    List<BlockContent> selectBlockContentList(int tid);


    List<Template> selectActivityTopicBlockTemplate();

    int updateBlockOrder(Map<String,String> map);

    int updateActivityOrder(Map<String,String> map);

    int updateBlockDetailTitle(Map<String,String> map);


}
