package com.sun3d.why.controller;

//import com.github.pagehelper.Page;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.topic.*;
import com.sun3d.why.service.ActivityTopicService;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.http.HttpRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/22.
 */

@Controller
@RequestMapping(value = "/template")
public class CmsActivityTopicController
{
    @Autowired
    ActivityTopicService topicService;


    @Autowired
    private StaticServer staticServer;

    @Autowired
    private CacheService cacheService;
    /*
    insert into sys_module (module_name,module_url,module_parent_id,module_state,module_sort,module_create_user)
    values('模版管理','${path}/template/templateIndex.do','d3b1fb632c9248b1a69d814778f9e3da',1,121,1)


    insert into sys_role_module(role_id,module_id)
    value('340156d716bc49f58105a8ed626ebd75','fc4d07a280a811e693946c92bf2cdc21')
    */
    
    /**
     * 新年专题封面页
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("newYearWelcome")
    public String templateWelcome(HttpServletRequest request,ModelMap model){
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        model.put("WCHATSIGN", sign);

        ActivityTopic ac = topicService.selectActivityTopic(41);
        model.put("IMGURL", staticServer.getStaticServerUrl());
        model.put("ActivityTopic", ac);

        return  "admin/template/newYearWelcome";
    }

    @RequestMapping("activityTopicDetail")
    public String activityTopicDetail(@RequestParam(defaultValue = "0",required = false) Integer topicid,
                                      HttpServletRequest request,
                                      ModelMap model)
    {

        try
        {
            String url = BindWS.getUrl(request);
            Map<String, String> sign = BindWS.sign(url, cacheService);
            model.put("WCHATSIGN", sign);

            ActivityTopic ac = topicService.selectActivityTopic(topicid);
            model.put("IMGURL", staticServer.getStaticServerUrl());
            model.put("ActivityTopic", ac);
            model.put("topicid", topicid);
        }catch (Exception e)
        {
            System.out.println("--------activityTopicDetail---------");
            e.printStackTrace();
        }
        return  "admin/template/activityTopicDetail";

    }



    @RequestMapping("templateIndex")
    public String templateIndex(@RequestParam(defaultValue = "1",required = false) Integer page,
                                ModelMap model)
    {
        //com.sun3d.why.model.CmsTerminalUser user = null;
        //user.getUserId();
        List<ActivityTopic>  topicList = topicService.selectActivityTopicList(page);
        model.put("ActivityTopicList",topicList);
        model.put("IMGURL",staticServer.getStaticServerUrl());
        PageInfo p = new PageInfo(topicList);
        model.put("Page",p);
        return "admin/template/index";
    }

    @RequestMapping("templatedetail")
    public  String templateDetail(@RequestParam(defaultValue = "0",required = true) Integer id,
            ModelMap model)
    {

        try
        {
            if (id > 0) {
                ActivityTopic atopic = topicService.selectActivityTopic(id);
                model.put("ActivityTopic", atopic);

                List<Activity> activityList = topicService.selectActivityTopicContentList(id);
                model.put("ActivityList", activityList);


                List<Block> blockList = topicService.selectBlockList(id);
                model.put("BlockList", blockList);

            }
            model.put("IMGURL", staticServer.getStaticServerUrl());
        }catch (Exception e)
        {
            System.out.println("--------templatedetail---------");
            e.printStackTrace();
        }
        return "admin/template/detail";
    }

    @RequestMapping("activitydetail")
    public String activitydetail(@RequestParam(defaultValue = "0",required = false) Integer aid,
                                 ModelMap model)
    {


        Activity ac = topicService.selectActivityTopicContent(aid);
        model.put("Activity",ac);
        model.put("IMGURL",staticServer.getStaticServerUrl());
        return "admin/template/activitydetail";
    }

    @RequestMapping("updateTopic")
    @ResponseBody
    public String updateActivityTopic(@RequestParam(defaultValue = "0",required = false) Integer topicid,
                                      @RequestParam(defaultValue = "",required = false) String topictitle,
                                      @RequestParam(defaultValue = "",required = false) String sharetitle,
                                      @RequestParam(defaultValue = "",required = false) String shareheadimg,
                                      @RequestParam(defaultValue = "",required = false) String sharedesc,
                                      @RequestParam(defaultValue = "",required = false) String headimg)
    {

        ActivityTopic at = new ActivityTopic();
        at.setTitle(topictitle);
        at.setHeadimg(headimg);
        at.setSharedesc(sharedesc);
        at.setShareimg(shareheadimg);
        at.setSharetitle(sharetitle);
        try
        {
            if (topicid == 0)
            {
                topicService.insertActivityTopic(at);
            } else
            {
                at.setId(topicid);
                topicService.updateActivityTopic(at);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return "-1";
        }
        return ""+at.getId();
    }

    @RequestMapping("updateTopicActivity")
    @ResponseBody
    public String updateTopicActivity(@RequestParam(defaultValue = "0",required = false) Integer topicid,
                                      @RequestParam(defaultValue = "0",required = false) Integer aid,
                                      @RequestParam(defaultValue = "",required = false) String hname,
                                      @RequestParam(defaultValue = "",required = false) String headImgUrl,
                                      @RequestParam(defaultValue = "",required = false) String title,
                                      @RequestParam(defaultValue = "",required = false) String addr,
                                      @RequestParam(defaultValue = "",required = false) String duration,
                                      @RequestParam(defaultValue = "",required = false) String activityid,
                                      @RequestParam(defaultValue = "",required = false) String linktitle,
                                      @RequestParam(defaultValue = "0",required = false) Integer aord,
                                      @RequestParam(defaultValue = "0",required = false) String linkisblue

    )
    {

        Activity at = new Activity();
        at.setTid(topicid);
        at.setHname(hname);
        at.setImage(headImgUrl);
        at.setTitle(title);
        at.setAddr(addr);
        at.setAord(aord);
        at.setDuration(duration);
        at.setActivityid(activityid);
        if(linkisblue.equals("on"))
            at.setLinkisblue(1);
        else
            at.setLinkisblue(0);
        at.setLinktitle(linktitle);
        try
        {
            if (aid == 0)
            {
                topicService.insertActivityTopicContent(at);
            } else
            {
                at.setId(aid);
                topicService.updateActivityTopicContent(at);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return "-1";
        }
        return ""+at.getId();

    }


    @RequestMapping("blockdetail")
    public String blockdetail(@RequestParam(defaultValue = "0",required = false) Integer bid,
                              @RequestParam(defaultValue = "0",required = false) Integer topicid,
                              ModelMap model)
    {

        List<Template> templateList = topicService.selectActivityTopicBlockTemplate();
        model.put("TemplateList",templateList);
        if(bid > 0)
        {

            Block block = topicService.selectBlock(bid);
            model.put("Block",block);

            List<BlockContent> blockContentList = topicService.selectBlockContentList(bid);
            model.put("BlockContentList",blockContentList);

        }
        model.put("IMGURL",staticServer.getStaticServerUrl());
        return "admin/template/blockdetail";
    }

    @RequestMapping("updateBlockDetailTitle")
    @ResponseBody
    public  String updateBlockDetailTitle(@RequestParam(defaultValue = "0",required = false) Integer id,
                                     @RequestParam(defaultValue = "",required = false) String bname

    )
    {
        if(id > 0)
        {

            HashMap<String,String> map = new HashMap<>();
            map.put("id",id+"");
            map.put("bname",bname);
            topicService.updateBlockDetailTitle(map);
        }
        return "1";
    }


    @RequestMapping("updateblock")
    @ResponseBody
    public  String updateblock(@RequestParam(defaultValue = "0",required = false) String blockname,
                               @RequestParam(defaultValue = "0",required = false) Integer topicid,
                               @RequestParam(defaultValue = "1",required = false) Integer showname,
                               @RequestParam(defaultValue = "0",required = false) Integer templateid,
                               @RequestParam(defaultValue = "0",required = false) Integer aord
                               )
    {
        if(topicid > 0)
        {
            Block b = new Block();
            b.setTid(topicid);
            b.setBname(blockname);
            b.setShowname(showname);
            b.setTemplateid(templateid);
            b.setAord(aord);
            try
            {
                topicService.insertTopicBlock(b);
                return b.getId()+"";
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

        }


        return "-1";


    }

    @RequestMapping("updateBlockContent")
    @ResponseBody
    public String updateBlockContent(@RequestParam(defaultValue = "0",required = false) Integer bid,
                                     @RequestParam(defaultValue = "0",required = false) Integer topicid,
                                     @RequestParam(defaultValue = "0",required = false) Integer bcid,
                                     @RequestParam(defaultValue = "0",required = false) String attr)
    {
        BlockContent bc = new BlockContent();
        bc.setTid(topicid);
        bc.setBid(bid);
        bc.setAttr(attr);
        if(bcid > 0)
        {
            bc.setId(bcid);
            topicService.updateBlockContent(bc);
        }
        else
        {
            topicService.insertBlockContent(bc);
        }

        return bc.getId()+"";
    }

    @RequestMapping("delblock")
    @ResponseBody
    public String delblock(@RequestParam(defaultValue = "0",required = false) Integer bid)
    {

        try
        {
            topicService.delBlock(bid);
        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }

    @RequestMapping("delActivityContent")
    @ResponseBody
    public String delActivityContent(@RequestParam(defaultValue = "0",required = false) Integer aid)
    {

        try
        {
            topicService.delActivityTopicContent(aid);
        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }

    @RequestMapping("delTopic")
    @ResponseBody
    public String delTopic(@RequestParam(defaultValue = "0",required = false) Integer topicid)
    {
        try
        {
            topicService.delActivityTopic(topicid);
        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }

    @RequestMapping("delblockContent")
    @ResponseBody
    public String delblockContent(@RequestParam(defaultValue = "0",required = false) Integer bcid)
    {

        try
        {
            topicService.delBlockContent(bcid);
        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }

    @RequestMapping("updateBlockOrder")
    @ResponseBody
    public String updateBlockOrder(@RequestParam(defaultValue = "0",required = false) Integer bid,
                                   @RequestParam(defaultValue = "0",required = false) Integer aord)
    {
        try
        {
            if (bid > 0)
            {
                HashMap<String,String> map = new HashMap<>();
                map.put("id",bid+"");
                map.put("aord",aord+"");
                topicService.updateBlockOrder(map);
            }

        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }


    @RequestMapping("updateActivityOrder")
    @ResponseBody
    public String updateActivityOrder(@RequestParam(defaultValue = "0",required = false) Integer aid,
                                   @RequestParam(defaultValue = "0",required = false) Integer aord)
    {
        try
        {
            if (aid > 0)
            {
                HashMap<String,String> map = new HashMap<>();
                map.put("id",aid+"");
                map.put("aord",aord+"");
                topicService.updateActivityOrder(map);
            }

        }
        catch (Exception e)
        {
            return "0";
        }
        return "1";
    }



}
