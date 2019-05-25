package com.sun3d.why.service.impl;

//import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageHelper;
import com.sun3d.why.dao.ActivityTopicMapper;
import com.sun3d.why.model.topic.*;
import com.sun3d.why.service.ActivityTopicService;
import com.sun3d.why.util.Pagination;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.print.DocFlavor;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/28.
 */
@Service
public class ActivityTopicServiceImpl   implements ActivityTopicService
{
    @Autowired
    ActivityTopicMapper mapper;


    @Override
    public int delActivityTopic(int topicid)
    {
        return mapper.delActivityTopic(topicid);
    }


    @Override
    public int insertActivityTopic(ActivityTopic obj) {
        return mapper.insertActivityTopic(obj);
    }

    @Override
    public int updateActivityTopic(ActivityTopic obj) {
        return mapper.updateActivityTopic(obj);
    }

    @Override
    public ActivityTopic selectActivityTopic(int id)
    {

        String s1 = "|!!|";
        String s2 = "＄";

        ActivityTopic ac = mapper.selectActivityTopic(id);

        List<Activity> aclist = this.selectActivityTopicContentList(id);

        List<Block> blockList = this.selectBlockList(id);

        List<BlockContent> bclist =  this.selectBlockContentListByTopic(id);
        //一次性拿出所有板块内容,代码中区分
        for(Block b :blockList)
        {
            List<BlockContent> a = new ArrayList<BlockContent>();
            b.setShowContent(b.getTemplateContainer().replaceAll("\\$\\{blockname\\}",b.getBname()));
            String cc = "";
            for(BlockContent bc : bclist)
            {
                if(bc.getBid() == b.getId())
                {
                    String[] t = StringUtils.split(bc.getAttr(),s1);

                    if(t.length == 2)
                    {

                        String[] plist = StringUtils.splitByWholeSeparator(t[0],s2);
                        String[] ulist = StringUtils.splitByWholeSeparator(t[1],s2);
                        String cotent = b.getTemplateContent();
                        System.out.println(b.getId());
//                        System.out.println(t[0]);
//                        System.out.println(t[1]);
//                        System.out.println("getFieldnum="+b.getFieldnum()+"-"+plist.length+"-"+ulist.length);
                        for (int xx = 0;xx<b.getFieldnum();xx++)
                        {


                            if(xx < plist.length)
                            {
                                plist[xx] = plist[xx].replaceAll("~~","&");
                                cotent = cotent.replaceAll("\\$\\{param" + (xx + 1) + "\\}", plist[xx]);
                            }
                            if(xx < ulist.length)
                            {
                                ulist[xx] = ulist[xx].replaceAll("~~","&");
                                cotent = cotent.replaceAll("\\$\\{param"+(xx+1)+"_url\\}",ulist[xx]);
                            }

                        }
                        cc += cotent;
                    }


                    a.add(bc);
                }
            }
            String c1 = b.getShowContent().replaceAll("\\$\\{content\\}",cc);
            b.setShowContent(c1);
            b.setContent(a);
        }

        ac.setActivytList(aclist);
        ac.setBlockList(blockList);

        return ac;
    }

    @Override
    public List<ActivityTopic> selectActivityTopicList(int page)
    {
        PageHelper.startPage(page, 10);
        return mapper.selectActivityTopicList();
    }




    @Override
    public int insertActivityTopicContent(Activity obj) {
        return mapper.insertActivityTopicContent(obj);
    }


    @Override
    public  int  insertTopicBlock(Block obj)
    {
        return mapper.insertTopicBlock(obj);
    }


    @Override
    public int delActivityTopicContent(int aid)
    {
        return mapper.delActivityTopicContent(aid);
    }

    @Override
    public int updateActivityTopicContent(Activity obj) {
        return mapper.updateActivityTopicContent(obj);
    }

    @Override
    public Activity selectActivityTopicContent(int id) {
        return mapper.selectActivityTopicContent(id);
    }

    @Override
    public List<Activity> selectActivityTopicContentList(int tid) {
        return mapper.selectActivityTopicContentList(tid);
    }

    @Override
    public int insertBlockContent(BlockContent obj) {
        return mapper.insertBlockContent(obj);
    }

    @Override
    public int updateBlockContent(BlockContent obj) {
        return mapper.updateBlockContent(obj);
    }

    @Override
    public BlockContent selectBlockContent(int id) {
        return mapper.selectBlockContent(id);
    }

    @Override
    public Block  selectBlock(int id)
    {
        return mapper.selectBlock(id);
    }

    @Override
    public int delBlock(int id)
    {
        return mapper.delBlock(id);
    }

    @Override
    public int delBlockContent(int id)
    {
        return mapper.delBlockContent(id);
    }

    @Override
    public List<Block> selectBlockList(int tid) {
        return mapper.selectBlockList(tid);
    }

    @Override
    public List<BlockContent> selectBlockContentListByTopic(int tid) {
        return mapper.selectBlockContentListByTopic(tid);
    }


    @Override
    public List<BlockContent> selectBlockContentList(int bid) {
        return mapper.selectBlockContentList(bid);
    }

    @Override
    public List<Template> selectActivityTopicBlockTemplate() {
        return mapper.selectActivityTopicBlockTemplate();
    }

    @Override
    public int updateBlockOrder(Map<String,String> map)
    {
        return mapper.updateBlockOrder(map);
    }


    @Override
    public int updateActivityOrder(Map<String,String> map)
    {
        return mapper.updateActivityOrder(map);
    }

    @Override
    public int updateBlockDetailTitle(Map<String, String> map)
    {
        return mapper.updateBlockDetailTitle(map);
    }


}
