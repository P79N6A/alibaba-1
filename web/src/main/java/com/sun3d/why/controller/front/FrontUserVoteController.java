package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsUserVote;
import com.sun3d.why.service.CmsUserVoteService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by niubiao on 2016/2/18.
 */
@Controller
@RequestMapping("/userVote")
public class FrontUserVoteController {

    @Autowired
    private CmsUserVoteService cmsUserVoteService;

    @RequestMapping(value = "/addVote",method = RequestMethod.POST)
    @ResponseBody
    private Map<String,Object> addVote(CmsUserVote cmsUserVote){
        Map<String,Object> result = new HashMap<>();
        cmsUserVote.setUserVoteId(UUIDUtils.createUUId());
        cmsUserVote.setVoteTime(new Date());
        try{
            cmsUserVoteService.insert(cmsUserVote);
            result.put("code",200);
        }catch (Exception e){
            e.printStackTrace();
            result.put("code",500);
        }
        return  result;
    }


    @RequestMapping(value = "/isVote",method = RequestMethod.POST)
    @ResponseBody
    private Map<String,Object> isVote(String userId,String voteId){
        Map<String,Object> result = new HashMap<>();
        if(StringUtils.isBlank(userId)||StringUtils.isBlank(voteId)){
            result.put("code",500);
            return  result;
        }
        Map<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("voteId",voteId);
        try{
            CmsUserVote extData = cmsUserVoteService.queryByMap(params);
            if(extData!=null){
                result.put("code",200);
                result.put("data",extData);
            }else{
                result.put("code",404);
            }
            return  result;
        }catch (Exception e){
            e.printStackTrace();
            result.put("code",500);
        }
        return  result;
    }

}
