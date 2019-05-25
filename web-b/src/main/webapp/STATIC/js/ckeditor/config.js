/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.removePlugins='elementspath';
	config.toolbar = 'my';//把默认工具栏改为‘MyToolbar’
	config.image_previewText=' '; //预览区域显示内容
	config.filebrowserImageUploadUrl = '../upload/uploadImg.do';
	config.enterMode = CKEDITOR.ENTER_P;
	config.shiftEnterMode = CKEDITOR.ENTER_BR;
	config.allowedContent = true;
	config.format_p = { element: 'p', attributes: { 'class': 'normalPara' } };
	config.pasteFromWordRemoveStyles = false;
	config.toolbar ="Mybar";
	config.forcePasteAsPlainText =true;
	config.toolbar_Mybar = [

		['Source','-','NewPage','Preview','-','Templates'],

		['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],

		['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],

		['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],

		'/',

		['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],

		['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],

		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],

		['Link','Unlink','Anchor'],

		['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],

		'/',

		['Styles','Format','Font','FontSize'],

		['TextColor','BGColor']

	];
	/*[
	['Preview','-'],
	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	['BidiLtr', 'BidiRtl'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['Link','Unlink','Anchor'],
	['Table','HorizontalRule','SpecialChar','PageBreak'],
	'/',
	['Styles','Format','Font','FontSize'],
	['TextColor','BGColor'],
	['Image'],
	['Maximize']
	];*/
};
