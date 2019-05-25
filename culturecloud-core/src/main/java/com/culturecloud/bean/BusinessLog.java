package com.culturecloud.bean;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;


/********************************************
 * 该类用于记录系统日常业务日志
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 * 
 ********************************************/
@Table(value = "sys_business_log")
public class BusinessLog implements BaseEntity{
	
	@Id(name="id")
	@Column(name="id")
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Integer id;
	
	/**记录业务开始执行时间点*/
	@Column(name="create_time")
	private Date createTime;
	/**业务执行所需时间，单位：毫秒*/
	@Column(name="execute_time")
	private Long executeTime;
	/**业务日志描述*/
	@Column(name="log_remark")
	private String logRemark;
	/**用户访问类的全名*/
	@Column(name="class_full_name")
	private String classFullName;
	/**用户所访问的方法名*/
	@Column(name="method_name")
	private String methodName;
	/** 请求参数*/
	@Column(name="request_content")
	private String requestContent;
	/** 请求来源*/
	@Column(name="source")
	private String source;
	/** 请求参数*/
	@Column(name="reponse_content")
	private String reponseContent;

	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
	public Long getExecuteTime() {
		return executeTime;
	}
	public void setExecuteTime(Long executeTime) {
		this.executeTime = executeTime;
	}

	public String getLogRemark() {
		return logRemark;
	}
	public void setLogRemark(String logRemark) {
		this.logRemark = logRemark;
	}
	
	public String getClassFullName() {
		return classFullName;
	}
	public void setClassFullName(String classFullName) {
		this.classFullName = classFullName;
	}
	
	public String getMethodName() {
		return methodName;
	}
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}
	public String getRequestContent() {
		return requestContent;
	}
	public void setRequestContent(String requestContent) {
		this.requestContent = requestContent;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getReponseContent() {
		return reponseContent;
	}
	public void setReponseContent(String reponseContent) {
		this.reponseContent = reponseContent;
	}
	
	
	
}
