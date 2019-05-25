package com.sun3d.why.controller;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/ccpAdvert")
@Controller
public class CcpAdvertRecommendController {
    private Logger logger = LoggerFactory.getLogger(CcpAdvertRecommendController.class);

    @Autowired
    private CcpAdvertRecommendService ccpAdvertRecommendService;

    @Autowired
    private HttpSession session;

    /**
     * 运营列表查询
     *
     * @param advert
     * @return
     */
    @RequestMapping("/advertIndex")
    public ModelAndView advertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            advert.setAdvertPostion(1);
            advert.setAdvertType("A");
            List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("list", list);
            model.setViewName("admin/advert/ccpAdvertIndex");
        } catch (Exception e) {
            logger.error("advertIndex error {}", e);
        }
        return model;
    }

    /**
     * 运营位置添加页面
     *
     * @param advert
     * @return
     */
    @RequestMapping("/addAdvertIndex")
    public ModelAndView addAdvertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(advert.getAdvertId())) {
                List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
                if (list.size() > 0) {
                    advert = list.get(0);
                }
            }
            model.addObject("advert", advert);
            model.setViewName("admin/advert/ccpAddAdvert");
        } catch (Exception e) {
            logger.error("addAdvertIndex error {}", e);
        }
        return model;
    }

    /**
     * 运营列表查询
     *
     * @param advert
     * @return
     */
    @RequestMapping("/frontAdvertIndex")
    public ModelAndView frontAdvertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            model.setViewName("admin/advert/ccpFrontAdvertIndex");
        } catch (Exception e) {
            logger.error("advertIndex error {}", e);
        }
        return model;
    }


    /**
     * 首页栏目添加页面
     *
     * @param advert
     * @return
     */
    @RequestMapping("/addFrontAdvertIndex")
    public ModelAndView addFrontAdvertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(advert.getAdvertType())) {
                advert.setAdvertPostion(1);
                List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
                model.addObject("list", list);
                model.addObject("advert", advert);
                model.setViewName("admin/advert/ccpAddFrontAdvert");
            }
        } catch (Exception e) {
            logger.error("addAdvertIndex error {}", e);
        }
        return model;
    }

    /**
     * 运营位置添加
     *
     * @param advert
     * @return
     */
    @RequestMapping(value = "/addAdvert", method = RequestMethod.POST)
    @ResponseBody
    public String addAdvert(CcpAdvertRecommend advert) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (StringUtils.isBlank(sysUser.getUserId())) {
                return "noLogin";
            }
            int result = 0;
            if (StringUtils.isBlank(advert.getAdvertId())) {
                result = ccpAdvertRecommendService.insertAdvert(advert, sysUser);
            } else {
                result = ccpAdvertRecommendService.updateAdvert(advert, sysUser);
            }
            if (result > 0) {
                return Constant.RESULT_STR_SUCCESS;
            }

        } catch (Exception e) {
            logger.error("addAdvert error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 运营位置添加
     *
     * @param advert
     * @return
     */
    @RequestMapping(value = "/addAdvertList", method = RequestMethod.POST)
    @ResponseBody
    public String addAdvertList(CcpAdvertRecommend advert) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser == null) {
                return "noLogin";
            }
            int result = 0;
            int sort = 1;
            String[] ids = advert.getAdvertUrl().split(",");
            result = ccpAdvertRecommendService.deleteAdvert(advert);
            for (String id : ids) {
                advert.setAdvertUrl(id);
                advert.setAdvertSort(sort++);
                result = ccpAdvertRecommendService.insertAdvert(advert, sysUser);
            }
            if (result > 0) {
                return Constant.RESULT_STR_SUCCESS;
            }

        } catch (Exception e) {
            logger.error("addAdvert error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 运营位置修改
     *
     * @param advert
     * @return
     */
    @RequestMapping("/editAdvert")
    @ResponseBody
    public String editAdvert(CcpAdvertRecommend advert) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (StringUtils.isBlank(sysUser.getUserId())) {
                return "noLogin";
            }
            int result = ccpAdvertRecommendService.updateAdvert(advert, sysUser);
            if (result > 0)
                return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("editAdvert error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }
    /**
     * 运营位置删除
     *
     * @param advert
     * @return
     */
    @RequestMapping("/delAdvert")
    @ResponseBody
    public String delAdvert(CcpAdvertRecommend advert) {
        try {
            String[] id=advert.getAdvertId().split("_");
            advert.setAdvertId(null);
            advert.setAdvertPostion(Integer.parseInt(id[0]));
            advert.setAdvertType(id[1]);
            advert.setAdvertSort(Integer.parseInt(id[2]));
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser==null||StringUtils.isBlank(sysUser.getUserId())) {
                return "noLogin";
            }
            int result = ccpAdvertRecommendService.deleteAdvert(advert);
            if (result > 0)
                return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("editAdvert error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }
    /**
     * 运营位置添加页面
     *
     * @param advert
     * @return
     */
    @RequestMapping("/loadAdvertIndex")
    @ResponseBody
    public List<CcpAdvertRecommend> loadAdvertIndex(CcpAdvertRecommend advert) {
        List<CcpAdvertRecommend> list=null;
        try {
            list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
        } catch (Exception e) {
            logger.error("addAdvertIndex error {}", e);
        }
        return list;

    }

    /**
     * 运营列表查询
     *
     * @param advert
     * @return
     */
    @RequestMapping("/appFrontAdvertIndex")
    public ModelAndView appFrontAdvertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            advert.setAdvertPostion(2);
            advert.setAdvertType("A");
            List<CcpAdvertRecommend> listA = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listA", listA);
            advert.setAdvertType("B");
            List<CcpAdvertRecommend> listB = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listB", listB);
            advert.setAdvertType("C");
            List<CcpAdvertRecommend> listC = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listC", listC);
            advert.setAdvertType("D");
            List<CcpAdvertRecommend> listD = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listD", listD);
            model.setViewName("admin/advert/appFrontAdv");
        } catch (Exception e) {
            logger.error("advertIndex error {}", e);
        }
        return model;
    }

    /**
     * 运营列表查询
     *
     * @param advert
     * @return
     */
    @RequestMapping("/appSpaceAdvertIndex")
    public ModelAndView appSpaceAdvertIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            advert.setAdvertPostion(3);
            advert.setAdvertType("A");
            List<CcpAdvertRecommend> listA = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listA", listA);
            advert.setAdvertType("B");
            List<CcpAdvertRecommend> listB = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listB", listB);
            model.setViewName("admin/advert/appSpaceAdv");
        } catch (Exception e) {
            logger.error("advertIndex error {}", e);
        }
        return model;
    }

    /**
     * app运营位置添加页面
     *
     * @param advert
     * @return
     */
    @RequestMapping("/addAppAdvertIndex")
    public ModelAndView addAppAdvertIndex(CcpAdvertRecommend advert,String imgSize) {
        ModelAndView model = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(advert.getAdvertId())) {
                String[] id=advert.getAdvertId().split("_");
                advert.setAdvertId(null);
                advert.setAdvertPostion(Integer.parseInt(id[0]));
                advert.setAdvertType(id[1]);
                advert.setAdvertSort(Integer.parseInt(id[2]));
                List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
                if (list.size() > 0) {
                    advert = list.get(0);
                }
            }
            model.addObject("advert", advert);
            if(StringUtils.isNotBlank(imgSize)){
                String[] size=imgSize.split("_");
                model.addObject("width", size[1]);
                model.addObject("height", size[2]);
                model.addObject("imgSize", imgSize);
            }
            model.setViewName("admin/advert/ccpAddAppAdvert");
        } catch (Exception e) {
            logger.error("addAdvertIndex error {}", e);
        }
        return model;
    }

    /**
     * 热门词汇列表查询
     *
     * @param advert
     * @return
     */
    @RequestMapping("/appHotWordIndex")
    public ModelAndView appHotWordIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            advert.setAdvertPostion(4);
            advert.setAdvertType("A");
            List<CcpAdvertRecommend> listA = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listA", listA);
            advert.setAdvertType("B");
            List<CcpAdvertRecommend> listB = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
            model.addObject("listB", listB);
            model.setViewName("admin/advert/ccpHotWordIndex");
        } catch (Exception e) {
            logger.error("advertIndex error {}", e);
        }
        return model;
    }
    /**
     * 热门词汇加页面
     *
     * @param advert
     * @return
     */
    @RequestMapping("/addHotWordIndex")
    public ModelAndView addHotWordIndex(CcpAdvertRecommend advert) {
        ModelAndView model = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(advert.getAdvertId())) {
                String[] id=advert.getAdvertId().split("_");
                advert.setAdvertId(null);
                advert.setAdvertPostion(Integer.parseInt(id[0]));
                advert.setAdvertType(id[1]);
                advert.setAdvertSort(Integer.parseInt(id[2]));
                List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
                if (list.size() > 0) {
                    advert = list.get(0);
                }
            }
            model.addObject("advert", advert);
            model.setViewName("admin/advert/ccpAddHotWordAdvert");
        } catch (Exception e) {
            logger.error("addAdvertIndex error {}", e);
        }
        return model;
    }
}
