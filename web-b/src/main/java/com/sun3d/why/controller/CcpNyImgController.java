package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpNyImgMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.service.CcpNyImgService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/ny")
@Controller
public class CcpNyImgController {

	@Autowired
	private CcpNyImgService ccpNyImgService;

	@Autowired
	private HttpSession session;
	
	@Autowired
	private CcpNyImgMapper ccpNyImgMapper;
	
	@Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	

	@RequestMapping("/nyImgIndex")
	public ModelAndView nyImgIndex(CcpNyImg ccpNyImg, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpNyImg> list = ccpNyImgService.queryNyImgByCondition(ccpNyImg, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpNyImg);
		model.setViewName("admin/newYear/nyImgIndex");
		return model;
	}

	/**
     * 删除图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteNyImg")
    @ResponseBody
    public String deleteNyImg(String nyImgId) {
    	return ccpNyImgService.deleteNyImg(nyImgId);
    }
    
    /**
     * 审核通过后，向广场插入数据
     * @param nyImgId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public String checkPass(String nyImgId){
    	try {
			String[] ImgId = nyImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpNyImg ccpNyImg = ccpNyImgMapper.selectNyImgList(new CcpNyImg(id)).get(0);
				if(ccpNyImg.getNyStatus() == 0 || ccpNyImg.getNyStatus() == 2){
					ccpNyImg.setNyStatus(1);
					rs=ccpNyImgService.update(ccpNyImg);
					if(rs>0){
						CmsCulturalSquare cmsCulturalSquare = new CmsCulturalSquare();
						cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
						cmsCulturalSquare.setHeadUrl(ccpNyImg.getUserHeadImgUrl());
						cmsCulturalSquare.setUserName(ccpNyImg.getUserName());
						cmsCulturalSquare.setContextDec("参与了一个<span style='color: #c49123;font-size: 24px;'># 活动 #</span>");
						cmsCulturalSquare.setPublishTime(ccpNyImg.getCreateTime());
						cmsCulturalSquare.setOutId(ccpNyImg.getNyImgId());
						cmsCulturalSquare.setType(2);
						cmsCulturalSquare.setExt0(ccpNyImg.getNyImgUrl());
						cmsCulturalSquare.setExt1(ccpNyImg.getNyImgContent());
						cmsCulturalSquare.setExt2("3");
						cmsCulturalSquareMapper.insert(cmsCulturalSquare);
			    	}
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
    
    /**
     * 审核不通过
     * @param nyImgId
     * @return
     */
    @RequestMapping("/checkNoPass")
    @ResponseBody
    public String checkNoPass(String nyImgId){
    	try {
			String[] ImgId = nyImgId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CcpNyImg ccpNyImg = ccpNyImgService.queryByNyImgId(id);
				ccpNyImg.setNyStatus(2);
				rs = ccpNyImgService.update(ccpNyImg);
				
				if(rs>0){
					//删除广场信息
			    	cmsCulturalSquareMapper.deleteByOutId(nyImgId);
				}
			}
			return "200";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
    }
}
