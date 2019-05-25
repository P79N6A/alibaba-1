$(function(){
	
	var shift = false,capslock = false;
	var id_S="";
	$(".showPlaceholder .inputs").each(function() {
        $(this).focus(function(e){
			e.stopPropagation();
			var id=$(this).attr("id");
			id_S=$("#"+id);
			var $this = $(this);
			var par_this=$(this).parent("dd").parent("dl");
			var top = par_this.position().top;
			var left = par_this.position().left;
			$("#keyboard").css({"top": top+50, "left": left-20}).show();
		});
		$(this).click(function(e){
			e.stopPropagation();
		});
    });
	$("#keyboard").click(function(e){
		valUserMobile();
		e.stopPropagation();
	});
	
   

	$(document).click(function(e){
		valUserMobile();
		$("#keyboard").hide();
	});


	$('#keyboard li').click(function(){
		  name_input(id_S,$(this));
					
		});
	function name_input(obj,key){
		  var $write = obj; 
		  var $this = key,
			character = $this.html(); // If it's a lowercase letter, nothing happens to this variable
	
		
		// Shift keys
		if ($this.hasClass('left-shift') || $this.hasClass('right-shift')) {
			$('.letter').toggleClass('uppercase');
			$('.symbol span').toggle();
			
			shift = (shift === true) ? false : true;
			capslock = false;
			return false;
		}
		
		// Caps lock
		if ($this.hasClass('capslock')) {
			$('.letter').toggleClass('uppercase');
			capslock = true;
			return false;
		}
		
		// Delete
		if ($this.hasClass('delete')) {
			var html = $write.val();
			
			$write.val(html.substr(0, html.length - 1));
			return false;
		}
		
		// Special characters
		if ($this.hasClass('symbol')) character = $('span:visible', $this).html();
		if ($this.hasClass('space')) character = ' ';
		if ($this.hasClass('tab')) character = "\t";
		if ($this.hasClass('return')) character = "\n";
		
		// Uppercase letter
		if ($this.hasClass('uppercase')) character = character.toUpperCase();
		
		// Remove shift once a key is clicked.
		if (shift === true) {
			$('.symbol span').toggle();
			if (capslock === false) $('.letter').toggleClass('uppercase');
			
			shift = false;
		}
		// Add the character
		$write.val($write.val() + trim(character));
	}
});
function trim(str){ //删除左右两端的空格
	if(str == " "){
		return str;
	}else{
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}
}


















