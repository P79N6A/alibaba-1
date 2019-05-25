package com.sun3d.why.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.culturecloud.model.bean.special.CcpSpecialYcode;
import com.sun3d.why.dao.dto.CcpSpecialYcodeDto;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpSpecialCustomerService;
import com.sun3d.why.service.CcpSpecialYcodeService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.NsExcelWriteUtils;
import com.sun3d.why.util.Pagination;

@RequestMapping("/specialYcode")
@Controller
public class CcpSpecialYcodeController {

	@Autowired
	private CcpSpecialYcodeService ccpSpecialYcodeService;

	@Autowired
	private CcpSpecialCustomerService ccpSpecialCustomerService;

	@RequestMapping("/index")
	public ModelAndView index(CcpSpecialYcode entity, Pagination page) {

		ModelAndView model = new ModelAndView();

		List<CcpSpecialYcodeDto> list = ccpSpecialYcodeService.queryByCondition(entity, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", entity);
		model.setViewName("admin/special/codeIndex");

		return model;
	}

	@RequestMapping("/saveCode")
	@ResponseBody
	public String saveCode(String customerId, Integer number) {

		try {

			int result = ccpSpecialYcodeService.saveCode(customerId, number);
			if (result > 0) {
				return Constant.RESULT_STR_SUCCESS;
			} else if (result == -1)
				return "toomuch";
			else {
				return Constant.RESULT_STR_FAILURE;
			}

		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping("/sendCode")
	@ResponseBody
	public String sendCode(String[] codeIds) {

		try {

			int result = ccpSpecialYcodeService.sendCode(codeIds);
			if (result >= 0) {
				return Constant.RESULT_STR_SUCCESS;
			} else {
				return Constant.RESULT_STR_FAILURE;
			}

		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping("/exportCode")
	@ResponseBody
	public void exportCode(CcpSpecialYcode entity, HttpServletRequest request, HttpServletResponse response) {

		String customerId = entity.getCustomerId();

		CcpSpecialCustomer customer = ccpSpecialCustomerService.findById(customerId);

		List<CcpSpecialYcodeDto> list = ccpSpecialYcodeService.queryByCondition(entity, null);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

		String fileName = sdf.format(new Date());

		File file;
		try {
			file = File.createTempFile(fileName, ".xls");

			NsExcelWriteUtils writer = new NsExcelWriteUtils(file.getPath());

			writer.createSheet(customer.getCustomerName() + "Y码导出");

			String[] title = new String[] { "Y码号码","状态" };

			writer.createRow(0);
			for (int i = 0; i < title.length; i++) {
				writer.createCell(i, title[i]);
			}
			
			for (int i = 0; i < list.size(); i++) {
				
				writer.createRow(i+1);
				
				CcpSpecialYcodeDto code=list.get(i);
            	
            	writer.createCell(0, code.getYcode());
            	
            	Integer codeStatus=code.getCodeStatus();
            	String codeStatusName="";
            	if(codeStatus!=null){
            		switch (codeStatus) {
					case 0:
						codeStatusName="未使用";
						break;
					case 1:
						codeStatusName="已发送";
						break;
					case 2:
						codeStatusName="已使用";
						break;
					}
            	}
            	
            	writer.createCell(1,codeStatusName);
			}
			
            
            writer.createExcel();
            
            
            NsExcelWriteUtils.downLoadFileByInputStream(file, fileName+".xls", response);

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
