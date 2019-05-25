function showVenueData(province , city , town) {
	var title	= ['所属区县' , '场馆类型' , '场馆名称'];
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
		loadingVenueData('loc_category' , $('#loc_area').val());
		$('#loc_category').change();
		//$('input[@name=location_id]').val($(this).val());
	})
	
	$('#loc_category').change(function() {
		$('#loc_venue').empty();
		$('#loc_venue').append(title[2]);
		loadingVenueData('loc_venue' , $('#loc_area').val()+ '-' +$('#loc_category').val());
	})
	
	$('#loc_venue').change(function() {
		$('input[name=location_id]').val($(this).val());
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

function setVenueDataUrl(id){
	if(typeof(id) == "undefined" || id == ''){
		return "area.json";
	}else{
		if(id.toString().split('-').length == 1){
			//return "area.json?areaid=" + id.split('-')[0];
			return "area-cate.json";
		}
		if(id.toString().split('-').length > 1 && id.split('-')[1] == '') {
			return false;
		}else{
			return "area-venues.json";
			//return "area.json?areaid=" + id.split('-')[0] + id.split('-')[1] + "&type=" + id.split('-')[1];
		}
	}
}

function loadingVenueData(el_id , loc_id , selected_id){
	var el	= $('#'+el_id);
	var url = setVenueDataUrl(loc_id);
	if(url) {
		$.post(url, {}, function (result) {
			data = result.data;
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
			el.select2("val", selected_id);   /*赋默认值*/
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
