package com.sun3d.why.region.cd.service;

import com.sun3d.why.region.cd.model.CdTrainingSign;


public interface CdTrainingSignService {
	
	String checkSignLimit(CdTrainingSign vo);
	
	String addSign(CdTrainingSign vo);
    
}