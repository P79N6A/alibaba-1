package com.sun3d.why.controller.front;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping("/frontResource")
@Controller
public class FrontCmsResourceController {
    
	/**
	 * 资源库首页
	 * @return
	 */
	@RequestMapping("/resourceIndex")
	public ModelAndView resourceIndex(){
		ModelAndView model=new ModelAndView();
		model.setViewName("index/resource/resourceIndex");
		return model;
	}
	
}
