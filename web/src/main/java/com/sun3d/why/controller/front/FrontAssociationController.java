package com.sun3d.why.controller.front;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.operation.OperatFunction;
import com.culturecloud.model.bean.activity.CmsActivityDto;
import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.culturecloud.model.bean.association.CcpAssociationRes;
import com.culturecloud.model.request.association.AssociationActivityVO;
import com.culturecloud.model.request.association.AssociationResourceListVO;
import com.culturecloud.model.request.association.GetAssociationDetailVO;
import com.culturecloud.model.request.association.SaveCcpAssociationFlowerVO;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.dao.CcpAssociationResMapper;
import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRecruit;
import com.sun3d.why.model.CcpAssociationRecruitApply;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.CollectAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/frontAssn")
@Controller
public class FrontAssociationController {
	
    private Logger logger = Logger.getLogger(FrontAssociationController.class);
    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CollectAppService collectAppService;
    @Autowired
    private CcpAssociationService ccpAssociationService;
    @Autowired
    private CcpAssociationResMapper ccpAssociationResMapper;
    @Autowired
    private CmsActivityMapper cmsActivityMapper;

    /**社团列表页
     * @return
     */
    @RequestMapping("/toAssnList")
    @SysBusinessLog(remark = "跳转到社团列表页",operation = OperatFunction.WHST)
    public ModelAndView assnList(HttpServletRequest request,String searchAssnName){
        ModelAndView model = new ModelAndView();
        model.addObject("searchAssnName",searchAssnName);
        model.setViewName("index/association/assnList");
        return model;
    }
    
    /**
     * 返回社团列表数据
     * @return
	 * @throws UnsupportedEncodingException 
     */
    @RequestMapping(value = "/assnListLoad")
    public ModelAndView assntListLoad(Pagination page, Integer recruitStatus, String assnName) throws UnsupportedEncodingException {
        ModelAndView model = new ModelAndView(); 
        page.setRows(12);
        JSONObject voJson=new JSONObject();
        voJson.put("resultFirst", page.getFirstResult());
        voJson.put("resultSize", page.getRows());
        voJson.put("recruitStatus",recruitStatus);
        voJson.put("assnName","%"+assnName+"%");
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "association/getAssociationListPC", voJson);
		String test = res.getData();
		JSONObject object = JSONObject.parseObject(test);
	      JSONObject  dataJson=new JSONObject(object);
	      JSONObject object1 = JSONObject.parseObject(dataJson.get("data").toString());
	      JSONObject  dataJson1=new JSONObject(object1);
	      Integer total=dataJson1.getInteger("total");
	      JSONArray array = dataJson1.getJSONArray("list");
	      List<CcpAssociation> list = JSONArray.parseArray(array.toString(),CcpAssociation.class);
	      page.setTotal(total);
	      model.addObject("page",page);
	      model.addObject("assnList", list);
	      model.addObject("total", total);
	      model.setViewName("index/association/assnListLoad");
        return model;
    }
    
    /**社团详情页
     * @return
     */
    @RequestMapping("/toAssnDetail")
    public ModelAndView toAssnDetail(HttpServletRequest request, String assnId){
        request.setAttribute("assnId", assnId);
        ModelAndView model=new ModelAndView();
    	Map<String, Object> map=new HashMap<String,Object>();
    	map.put("assnId", assnId);
    	map.put("resType", 1);
    	int photoCount=ccpAssociationResMapper.getAssociationResCount(map);	//照片数量
    	map=new HashMap<String,Object>();
    	map.put("assnId", assnId);
    	map.put("resType", 2);
    	int videoCount=ccpAssociationResMapper.getAssociationResCount(map);//视频数量
    	map=new HashMap<String,Object>();
    	String nowDate = null;
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		nowDate = sf.format(date);
		map.put("activityEndTime", nowDate);
    	map.put("assnId", assnId);
    	int hisActCount = cmsActivityMapper.queryAssociationHistoryActivityCount(map);	//历史活动数量
    	model.addObject("assnId", assnId);
    	model.addObject("photoCount", photoCount);
    	model.addObject("videoCount", videoCount);
    	model.addObject("hisActCount", hisActCount);
    	model.setViewName("index/association/assnDetail");
        return model;
    }
      

    
    /**获取社团详情
     * @return
     */
    @RequestMapping("/getAssnDetail")
    public String getAssnDetail(HttpServletResponse response,GetAssociationDetailVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/getAssociationDetail",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
	/**
	 * 获取社团资源
	 * 
	 * @return
	 */
	@RequestMapping("/getAssnRes")
	public ModelAndView getAssnRes(HttpServletResponse response, Pagination page, AssociationResourceListVO vo)
			throws Exception {
		ModelAndView model = new ModelAndView();
		page.setRows(9);
		vo.setResultFirst(page.getFirstResult());
		vo.setResultSize(page.getRows());
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "associationRes/associationResourceListPC", vo);
		String test = res.getData();
		JSONObject object = JSONObject.parseObject(test);
		JSONObject dataJson = new JSONObject(object);
		JSONObject object1 = JSONObject.parseObject(dataJson.get("data").toString());
		JSONObject dataJson1 = new JSONObject(object1);
		Integer total = dataJson1.getInteger("total");
		JSONArray array = dataJson1.getJSONArray("list");
		List<CcpAssociationRes> list = JSONArray.parseArray(array.toString(), CcpAssociationRes.class);
		page.setTotal(total);
		model.addObject("page", page);
		model.addObject("resList", list);
		model.addObject("total", total);
		model.setViewName("index/association/assnResLoad");
		return model;
	}
    
    /**获取社团在线活动
     * @return
     */
    @RequestMapping("/getAssnActivity")
    public String getAssnActivity(HttpServletResponse response,AssociationActivityVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/associationActivity",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**获取社团历史活动
     * @return
     */
    @RequestMapping("/getAssnHistoryActivity")
    public ModelAndView getAssnHistoryActivity(HttpServletResponse response, Pagination page, AssociationActivityVO vo) throws Exception{
    	ModelAndView model = new ModelAndView();
		page.setRows(9);
		vo.setResultFirst(page.getFirstResult());
		vo.setResultSize(page.getRows());
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/associationHistoryActivityPC",vo);
		String test = res.getData();
		Integer total = 0;
		List<CmsActivityDto> list = null;
		JSONObject object = JSONObject.parseObject(test);
		JSONObject dataJson = new JSONObject(object);
		if(dataJson.get("data")!=null){
			JSONObject object1 = JSONObject.parseObject(dataJson.get("data").toString());
			JSONObject dataJson1 = new JSONObject(object1);
			total = dataJson1.getInteger("total");
			JSONArray array = dataJson1.getJSONArray("list");
			list = JSONArray.parseArray(array.toString(), CmsActivityDto.class);
		}		
		page.setTotal(total);
		model.addObject("page", page);
		model.addObject("actList", list);
		model.addObject("total", total);
		model.setViewName("index/association/assnResLoad");
        return model;
    }
    
    /**社团浇花
     * @return
     */
    @RequestMapping("/saveAssnFlower")
    public String saveAssnFlower(HttpServletResponse response,SaveCcpAssociationFlowerVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"associationFlower/saveCcpAssociationFlower",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 用户关注社团
     * @param userId     用户id
     * @param assnId 社团id
     * @throws Exception
     */
    @RequestMapping(value = "/wcCollectAssn")
    public String wcCollectAssn(HttpServletRequest request, HttpServletResponse response, String userId, String assnId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(assnId)) {
                json = collectAppService.addCollectAssociation(userId, assnId);
            } else {
                json = JSONResponse.commonResultFormat(10121, "用户或社团id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * 取消社团关注
     * @param userId     用户id
     * @param assnId 社团id
     * @throws Exception
     */
    @RequestMapping(value = "/wcDelCollectAssn")
    public String wcDelCollectAssn(HttpServletRequest request, HttpServletResponse response, String userId, String assnId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(assnId)) {
                json = collectAppService.delCollectAssociation(userId, assnId);
            } else {
                json = JSONResponse.commonResultFormat(10121, "用户或社团id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    
    
    /**
     * 申请社团
     * @param ccpAssociationApply
     * @return
     */
    @RequestMapping("/applyAssociation")
    @SysBusinessLog(remark = "申请社团")
    @ResponseBody
    public String applyAssociation(CcpAssociationApply ccpAssociationApply) {
        try {
        	ccpAssociationApply.setAssnId(UUIDUtils.createUUId());
        	ccpAssociationApply.setAssnState(0);
        	ccpAssociationApply.setCreateTime(new Date());
        	ccpAssociationApply.setUpdateTime(new Date());
        	boolean rsBoolean = ccpAssociationService.saveAssnApply(ccpAssociationApply);
        	if(rsBoolean){
        		return Constant.RESULT_STR_SUCCESS;
        	}else{
        		return Constant.RESULT_STR_FAILURE;
        	}
        } catch (Exception e) {
            logger.info("applyAssociation error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
    /**
     * 得到社团招募信息
     * @param 
     * @return
     */
    @RequestMapping("/getAssnRecruit")
    @ResponseBody
    public CcpAssociationRecruit getAssnRecruit(String assnId) {
    	CcpAssociationRecruit recruit = null;
        try {
        	recruit = ccpAssociationService.getAssnRecruitByAssnId(assnId);
        } catch (Exception e) {
            logger.info("applyAssociation error {}", e);
        }
        return recruit;
    }
    /**
     * 我要报名
     * @param ccpAssociationRecruitApply
     * @return
     */
    @RequestMapping("/applyRecruit")
    @SysBusinessLog(remark = "报名社团")
    @ResponseBody
    public String applyRecruit(CcpAssociationRecruitApply ccpAssociationRecruitApply) {
        try {
        	ccpAssociationRecruitApply.setRecruitApplyId(UUIDUtils.createUUId());
        	ccpAssociationRecruitApply.setApplyStatus(1);
        	ccpAssociationRecruitApply.setApplyTime(new Date());
        	String rsBoolean = ccpAssociationService.saveRecruitApplyPc(ccpAssociationRecruitApply);
        	return rsBoolean;
        } catch (Exception e) {
            logger.info("applyAssociation error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }
}
