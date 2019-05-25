package com.sun3d.why.model;

import java.util.Date;

public class CmsQuestionAnwser {

    private String anwserId;	
    
    private String anwserImgUrl;	//问答封面图片URL

    private String anwserQuestion;		//互动问答题目
    
    private String anwserAllCode;	//所有题目(A图书馆*/*B群艺馆*/*C美术馆)

    private String anwserCode;		//正确答案编号(A/B/C/D)
    
    private Date anwserCreateTime;		//问题创建时间
    
    private String anwserCreateUser;		//后台创建用户ID
    
    private Date anwserUpdateTime;		//问题更新时间
    
    private String anwserUpdateUser;		//后台更新用户ID

    
	public String getAnwserId() {
		return anwserId;
	}

	public void setAnwserId(String anwserId) {
		this.anwserId = anwserId;
	}

	public String getAnwserImgUrl() {
		return anwserImgUrl;
	}

	public void setAnwserImgUrl(String anwserImgUrl) {
		this.anwserImgUrl = anwserImgUrl;
	}

	public String getAnwserQuestion() {
		return anwserQuestion;
	}

	public void setAnwserQuestion(String anwserQuestion) {
		this.anwserQuestion = anwserQuestion;
	}

	public String getAnwserCode() {
		return anwserCode;
	}

	public void setAnwserCode(String anwserCode) {
		this.anwserCode = anwserCode;
	}

	public Date getAnwserCreateTime() {
		return anwserCreateTime;
	}

	public void setAnwserCreateTime(Date anwserCreateTime) {
		this.anwserCreateTime = anwserCreateTime;
	}

	public String getAnwserCreateUser() {
		return anwserCreateUser;
	}

	public void setAnwserCreateUser(String anwserCreateUser) {
		this.anwserCreateUser = anwserCreateUser;
	}

	public String getAnwserAllCode() {
		return anwserAllCode;
	}

	public void setAnwserAllCode(String anwserAllCode) {
		this.anwserAllCode = anwserAllCode;
	}

	public Date getAnwserUpdateTime() {
		return anwserUpdateTime;
	}

	public void setAnwserUpdateTime(Date anwserUpdateTime) {
		this.anwserUpdateTime = anwserUpdateTime;
	}

	public String getAnwserUpdateUser() {
		return anwserUpdateUser;
	}

	public void setAnwserUpdateUser(String anwserUpdateUser) {
		this.anwserUpdateUser = anwserUpdateUser;
	}
    
}