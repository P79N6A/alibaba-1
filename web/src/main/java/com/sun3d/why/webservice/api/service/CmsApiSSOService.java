package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.util.Constant;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebService
public interface CmsApiSSOService {


    @WebMethod(operationName = "appUserRegister")
    @WebResult(name = "result")
    String appUserRegister(@WebParam(name="CheckKey") String CheckKey,@WebParam(name="LoginId") String LoginId);

    @WebMethod(operationName = "userInfoCheck")
    @WebResult(name = "result")
    int userInfoCheck(@WebParam(name="CheckKey") String CheckKey, @WebParam(name="LoginId")String LoginId ,@WebParam(name="PassWord")String PassWord);

}
