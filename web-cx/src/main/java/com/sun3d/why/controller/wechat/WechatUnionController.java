package com.sun3d.why.controller.wechat;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.league.CmsLeagueBO;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsCommentService;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.service.league.CmsLeagueService;
import com.sun3d.why.service.league.CmsMemberService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RequestMapping("/wechatUnion")
@Controller
public class WechatUnionController {

    @Autowired
    CmsLeagueService cmsLeagueService;
    @Autowired
    CmsMemberService cmsMemberService;
    @Autowired
    CmsActivityMapper cmsActivityMapper;
    @Autowired
    CmsVenueMapper cmsVenueMapper;
    @Autowired
    BpInfoService bpInfoService;
    @Autowired
    CmsCommentService cmsCommentService;
    @Autowired
    private CmsLeagueService leagueService;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private CmsCulturalOrderService culturalOrderService;

    @RequestMapping("/leagueIndex")
    public ModelAndView leagueIndex(CmsLeagueBO leagueBO,HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();
        //最新活动
        leagueBO.setRows(6);
        List<CmsActivity> list = leagueService.queryActivityByLeague(leagueBO);
        modelAndView.addObject("list", list);

        Map<String, String> sign = BindWS.sign(BindWS.getUrl(request), cacheService);
        modelAndView.addObject("sign", sign);
        modelAndView.setViewName("wechat/union/league_index");
        return modelAndView;
    }

    /**
     * 文化联盟首页
     * @return
     */
    @RequestMapping("/leagueForType")
    public ModelAndView leagueForType(CmsLeagueBO leagueBO,HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        List<CmsLeagueBO> list = leagueService.queryList(leagueBO);
        model.addObject("list",list);
        model.addObject("league",leagueBO);

        Map<String, String> sign = BindWS.sign(BindWS.getUrl(request), cacheService);
        model.addObject("sign", sign);
        model.setViewName("wechat/union/league_member");
        return model;
    }

    @RequestMapping("/index")
    public ModelAndView index(String member , HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();

        CmsMemberBO cmsMemberBO = cmsMemberService.selectByPrimaryKey(member);

        List<CmsActivity> cmsActivities = cmsActivityMapper.queryCmsActivityUnion(member,4);

        List<CmsVenue> cmsVenues = cmsVenueMapper.queryVenueUnion(member, 4);

        List<BpInfo> bpInfos = bpInfoService.queryCommendUnion(member, 4);


        String[] images = cmsMemberBO.getImages().split(",");
        modelAndView.addObject("member",cmsMemberBO);
        modelAndView.addObject("images",images);
        modelAndView.addObject("cmsActivities",cmsActivities);
        modelAndView.addObject("cmsVenues",cmsVenues);
        modelAndView.addObject("bpInfos",bpInfos);
        modelAndView.addObject("memberId",member);
        Map<String, String> sign = BindWS.sign(BindWS.getUrl(request), cacheService);
        modelAndView.addObject("sign", sign);
        modelAndView.setViewName("wechat/union/dhshIndex");

        return modelAndView;
    }

    @RequestMapping("/unionActivity")
    @ResponseBody
    public List UnionActivity(String name, String menberId, Integer pageIndex, CmsCulturalOrder order){
        List list=null;
        pageIndex=pageIndex*6;
        if(name!=null){
            switch (name){
                case "activity" :
                    list = cmsActivityMapper.queryCmsActivityUnionPage(menberId, pageIndex);
                    break;
                case "venue":
                    list = cmsVenueMapper.queryVenueUnionPage(menberId, pageIndex);
                    break;
                case "information":
                    list = bpInfoService.queryCommendUnionPage(menberId, pageIndex);
                    break;
               case "orders" :
                   Pagination page = new Pagination();
                   page.setRows(4);
                   page.setPage(pageIndex/6+1);
                   list = culturalOrderService.queryCulturalOrderList(order,page,2,menberId);
                   break;
            }
        }

        return list;
    }

}
