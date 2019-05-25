package com.sun3d.why.controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysNearSynonymService;
import com.sun3d.why.util.NsExcelReadUtils;
import com.sun3d.why.util.NsExcelReadXUtils;

@RequestMapping("/nearSynonym")
@Controller
public class SysNearSynonymController {
	
	@Autowired
	private SysNearSynonymService sysNearSynonymService;
	
	@Autowired
	private HttpSession session;

	@RequestMapping(value = "/nearSynonymIndex")
	public ModelAndView nearSynonymIndex() {
		ModelAndView model = new ModelAndView();

		model.setViewName("admin/nearSynonym/nearSynonymIndex");

		return model;
	}

	@RequestMapping(value = "/upload")
	public void upload(@RequestParam("file") MultipartFile mulFile, HttpServletResponse response) {
		
		JSONObject jsonResult = new JSONObject();

		try {
			
			 SysUser sysUser = (SysUser) session.getAttribute("user");
			 
			 if(sysUser==null)
			 {
				 jsonResult.put("status", 2);
					
				jsonResult.put("errorMessage","请先登录");
				
				response.getWriter().write(jsonResult.toString());
				
				return ;
			 }

			String originalFilename=mulFile.getOriginalFilename();
			
			InputStream is=mulFile.getInputStream();
			
			 List<String> errorList=new ArrayList<String>();
			
			if(originalFilename.endsWith(".xls"))
			{
				NsExcelReadUtils read=new NsExcelReadUtils(is, 0);
				
				int rowNumber=read.getRowNumber();
				
				List<List<String>> dataList= read.getLists(1, rowNumber, 2);
				
				errorList=sysNearSynonymService.importSysNearSynonym(sysUser, dataList);
				
			}
			else if (originalFilename.endsWith(".xlsx"))
			{
				NsExcelReadXUtils read=new NsExcelReadXUtils(is, 0);
				
				 List<List<String>> dataList= read.getLists(1, 2);
				 
				 errorList=sysNearSynonymService.importSysNearSynonym(sysUser, dataList);
				
			}

			jsonResult.put("status", 1);
			
			jsonResult.put("errorList", errorList);
			
			response.getWriter().write(jsonResult.toString());
			
		} catch (IOException e) {
			jsonResult = new JSONObject();

			jsonResult.put("status", 0);
			
			jsonResult.put("errorMessage", e.getMessage());
			
			try {
				response.getWriter().write(jsonResult.toString());
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		
	}
}
