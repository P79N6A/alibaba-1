function showVenueData(province , city , town) {
	var title	= ['所有区县' , '场馆类型' , '所有场馆'];
	$.each(title , function(k , v) {
		title[k]	= '<option value="">'+v+'</option>';
	});

	$('#loc_area').append(title[0]);
	$('#loc_category').append(title[1]);
	$('#loc_venue').append(title[2]);

	$("#loc_area,#loc_category,#loc_venue").select2();
	$('#loc_area').change(function() {
		$('#loc_category').empty();
		$('#loc_category').append(title[1]);
		if($('#loc_area').val() != undefined && $('#loc_area').val() != ""){
			//$('#loc_category').append('<option value=1>区级自建活动</option>');
			loadingVenueData('loc_category' , $('#loc_area').val());
			//$('input[@name=location_id]').val($(this).val());
		}
		$('#loc_category').change();
	})

	$('#loc_category').change(function() {
		if($(this).val()==1){
			$("#notBook").removeAttr("disabled");
			$("#notBook").trigger("click");
			$("#onlineSelectLabel").hide();
			$("#loc_q").css("display", 'none');
			$("#createActivityCode").val("2");
			$('#venueId').val("");

		}else{
			$("#onlineSelect").show();
			$("#onlineSelectLabel").show();
			$("#loc_q").css("display", 'block');
			$("#createActivityCode").val("0");
		}
		$('#loc_venue').empty();
		$('#loc_venue').append(title[2]);
		loadingVenueData('loc_venue' , $('#loc_area').val()+ '-' +$('#loc_category').val());
	})

	$('#loc_venue').change(function() {
		$('input[name=location_id]').val($(this).val());

		//地图坐标
		$.post("../venue/getVenue.do?id="+$(this).val(), function(data) {
			$('#activityLon').val(data.venueLon);
			$("#activityLat").val(data.venueLat);
		});
	})

	if (province) {
		loadingVenueData('loc_area','',  province);
		if (city) {
			loadingVenueData('loc_category', province, city);
			if (town) {
				loadingVenueData('loc_venue', province+'-'+city , town);
			}
		}
	} else {
		loadingVenueData('loc_area');
	}
}
var areaData;
var venueData;
var venueName;
function setVenueDataUrl(id){
	if(typeof(id) == "undefined" || id == ''){
		return "../venue/getActivityArea.do";
		//return "${path}/STATIC/area.json";
	}else{
		if(id.toString().split('-').length == 1){
			return '../venue/getVenueType.do?areaId='+id.split('-')[0];
			//return "area-cate.json";
		}
		if(id.toString().split('-').length > 1 && id.split('-')[1] == '') {
			return false;
		}else{
			return '../venue/getVenueName.do?areaId='+id.split('-')[0] + "&venueType=" + id.split('-')[1];
			//return "area-venues.json";
			//return "area.json?areaid=" + id.split('-')[0] + id.split('-')[1] + "&type=" + id.split('-')[1];
		}
	}
}

function loadingVenueData(el_id , loc_id , selected_id){
	var el	= $('#'+el_id);
	//var url = loc_id ? ("area.json?areaid=" + loc_id.split('-')[0] + (loc_id.split('-')[1] ? "&type=" + loc_id.split('-')[1] : '')) : ("area.json");
	var url = setVenueDataUrl(loc_id);
	if(url) {
		/*$.get(url,function (result) {
		 var json = $.parseJSON(result);
		 var data = json.data;

		 if (data) {

		 var index = 1;
		 var selected_index = 0;
		 $.each(data, function (k, v) {
		 var option = '<option value="' + data[k].id + '">' + data[k].text + '</option>';
		 el.append(option);

		 if (data[k].id == selected_id) {

		 selected_index = index;
		 }
		 index++;
		 });
		 //el.attr('selectedIndex' , selected_index);
		 }
		 }).success(function(){
		 alert(selected_id);
		 el.select2("val", selected_id);
		 });*/
		$.ajax({
			type:"get",
			url:url,
			dataType: "json",
			cache:false,//缓存不存在此页面
			async: true,//异步请求
			success: function (result) {
				var json = eval(result);
				var data = json.data;

				if (data) {

					var index = 1;
					var selected_index = 0;
					$.each(data, function (k, v) {
						var option = '<option value="' + data[k].id + '">' + data[k].text + '</option>';
						el.append(option);

						if (data[k].id == selected_id) {

							selected_index = index;
						}
						index++;
					});
					if(el_id == "loc_category"){
						el.append('<option value="1">市级自建活动</option>');
						//$("#notBook").trigger("click");
					}
					//el.attr('selectedIndex' , selected_index);
				}

				el.select2("val", selected_id);
			}
		});
	}
	el.select2("val", "");
}

$(function(){
	//showLocation();
	$('#btnval').click(function(){
		alert($('#loc_area').val() + ' - ' + $('#loc_category').val() + ' - ' +  $('#loc_venue').val())
	});
	$('#btntext').click(function(){
		alert($('#loc_area').select2('data').text + ' - ' + $('#loc_category').select2('data').text + ' - ' +  $('#loc_venue').select2('data').text)
	})
});