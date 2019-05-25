package com.sun3d.why.controller;

import com.sun3d.why.model.CmsSensitiveWords;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsSensitiveWordsService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by yujinbing on 2015/6/10.
 */
@Controller
@RequestMapping(value = "/sensitiveWords")
public class CmsSensitiveWordsController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(CmsSensitiveWordsController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsSensitiveWordsService cmsSensitiveWordsService;

    /**
     * 后台敏感词列表页面
     * @param cmsSensitiveWords
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value = "/sensitiveWordsIndex")
    public ModelAndView sensitiveWordsIndex(CmsSensitiveWords cmsSensitiveWords, Pagination page, HttpServletRequest request) {
        try {
            String words=cmsSensitiveWords.getSensitiveWords();
            if(StringUtils.isNotBlank(words)){
                cmsSensitiveWords.setSensitiveWords("%"+words+"%");
            }else{
                cmsSensitiveWords.setSensitiveWords(null);
            }

            ModelAndView model = new ModelAndView();
            int total = cmsSensitiveWordsService.queryCmsSensitiveWordsCount(cmsSensitiveWords);
            page.setTotal(total);
            List<CmsSensitiveWords> list = cmsSensitiveWordsService.queryCmsSensitiveWordsList(cmsSensitiveWords, page);
            cmsSensitiveWords.setSensitiveWords(words);
            model.addObject("page", page);
            model.addObject("cmsSensitiveWords", cmsSensitiveWords);
            model.addObject("list", list);
            model.setViewName("admin/sensitiveWords/sensitiveWordsIndex");
            return model;
        } catch ( Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * 逻辑删除或启用敏感词
     * @param cmsSensitiveWords
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteSensitiveWords")
    public ModelAndView deleteSensitiveWords(CmsSensitiveWords cmsSensitiveWords, Pagination page, HttpServletRequest request) {
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            int status = cmsSensitiveWords.getWordsStatus();
            cmsSensitiveWords = cmsSensitiveWordsService.querySensitiveWordsBySid(cmsSensitiveWords.getSid());
            cmsSensitiveWords.setWordsStatus(status);
            cmsSensitiveWordsService.deleteSensitiveWords(cmsSensitiveWords,loginUser);
            cmsSensitiveWords = new CmsSensitiveWords();
            return sensitiveWordsIndex(cmsSensitiveWords,page,request);
        } catch ( Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
    @RequestMapping(value = "/preEditSensitiveWords")
    public String preEditSensitiveWords(String sid ,HttpServletRequest request) {
        try {
            CmsSensitiveWords cmsSensitiveWords = cmsSensitiveWordsService.querySensitiveWordsBySid(sid);
            request.setAttribute("cmsSensitiveWords",cmsSensitiveWords);
            return "admin/sensitiveWords/editSensitiveWords";
        } catch (Exception ex) {
            ex.printStackTrace();
            return  "admin/sensitiveWords/editSensitiveWords";
        }
    }

    @RequestMapping(value = "/preAddSensitiveWords")
    public String preAddSensitiveWords(String sid ,HttpServletRequest request) {
        try {
            return "admin/sensitiveWords/addSensitiveWords";
        } catch (Exception ex) {
            ex.printStackTrace();
            return  "admin/sensitiveWords/addSensitiveWords";
        }
    }

    @RequestMapping(value = "/saveSensitiveWords")
    @ResponseBody
    public String saveSensitiveWords(CmsSensitiveWords cmsSensitiveWords ,HttpServletRequest request) {
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            return cmsSensitiveWordsService.saveCmsSensitiveWords(cmsSensitiveWords,loginUser);
        } catch (Exception ex) {
            ex.printStackTrace();
            return  ex.toString();
        }
    }

    @RequestMapping(value = "/saveEditSensitiveWords")
    @ResponseBody
    public String saveEditSensitiveWords(String sid ,String sensitiveWords, HttpServletRequest request) {
        try {
            CmsSensitiveWords cmsSensitiveWords = cmsSensitiveWordsService.querySensitiveWordsBySid(sid);
            if (sensitiveWords.equals(cmsSensitiveWords.getSensitiveWords())) {
                return Constant.RESULT_STR_SUCCESS;
            } else {
                int count = cmsSensitiveWordsService.queryCmsSensitiveWordsByWords(sensitiveWords);
                if (count > 0) {
                        return Constant.RESULT_STR_REPEAT;
                } else {
                    cmsSensitiveWords.setSensitiveWords(sensitiveWords);
                    cmsSensitiveWordsService.editSensitiveWords(cmsSensitiveWords);
                }
            }
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            return  ex.toString();
        }
    }

}
