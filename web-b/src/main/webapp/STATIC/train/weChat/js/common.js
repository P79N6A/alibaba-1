// JavaScript Document
$(function(){
	
	//单选按钮 
    $(".train_radio").each(function(index, element) {
		 var parents=$(this).parents(".trains_select");
         $(this).click(function(){
			         if($(this).hasClass('notselect')){
			        	 return;
			         }else{
			        	 parents.find("input").prop("checked",false);
						 parents.find(".train_radio").removeClass("on");
						 $(this).addClass("on");
						 $(this).find("input").prop("checked",true);
			         }
			 })
    });   
   //多选按钮
   $(".train_check").each(function(index, element) {
		 var parents=$(this).parents(".trains_select");
         $(this).click(function(){
	        	 if($(this).hasClass('notselect')){
		        	 return;
		         }else{
				      if($(this).hasClass("on")){
					    $(this).removeClass("on");
						$(this).find("input").prop("checked",false);
					  }else{
						 $(this).addClass("on");
						 $(this).find("input").prop("checked",true);
						  }
		         }
			 })
    }); 
   $("#agreetip").on("click",function(){
	   
	   if($('#checkboxt').is(':checked')){
	    	 $(".submitS1").removeClass("submitNone");
	    	 $(".submitS1").attr("data-action",true)
	    	 
	     }else{
	    	 $(".submitS1").addClass("submitNone"); 
	    	 $(".submitS1").attr("data-action",false)
	     }
   })
   //下拉详情  
   $(".detailS").click(function(){
	      if($(this).hasClass("on")){
			    $(this).parents("li").find(".info").hide();
				$(this).removeClass("on");
			}else{
				$(this).parents("li").find(".info").show();
				$(this).addClass("on");  
				  }
	   
	   })
	})
		
		
function dialogConfirm(title, content, fn){
    var d = dialog({
        width:400,
        title:title,
        content:content,
        fixed: true,
		time:2,
        button:[{
            value: '确定',
            callback: function () {
                if(fn)  fn();
                //this.content('你同意了');
                //return false;
            },
            autofocus: true
        },{
            value: '取消'
        }]
    });
    d.showModal();
}

function dialogAlert(title, content, fn){
    var d = top.dialog({
        width: 400,
        title:title,
        content:content,
        fixed: true,
        okValue: '确 定',
        ok: function () {
            if(fn)  fn();
        }
    });
    d.showModal();
}

function dialogTip(title, content){
    var d = top.dialog({
        width:400,
        title:title,
        content:content,
        fixed: true
    });
    d.showModal();
}		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	 
	 

	
	
	
	
	