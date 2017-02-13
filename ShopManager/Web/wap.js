
$(document).ready(function() {
//head 菜单
	$(".header-txt").click(function(){
		$(".pop-menu").toggle();
	});
	
	$(".header-more").click(function(){
		$(".pop-menu1,.pop-menu2").toggle();
	});
	
//标签切换	
	function changeTab (tabName,contentName,tabActive) {
		$("."+tabName).each(function  () {
			$(this).find("li").eq(0).addClass(tabActive);
			//$("."+contentName).css("display","none");
			//$("."+contentName).eq(0).css("display","block");
		})
		$("."+tabName+" li").click(function  () {
			$(this).parent().find("li").removeClass(tabActive);
			$(this).addClass(tabActive);
			$("."+contentName).css("display","none").eq($(this).index()).css("display","block");
		})
	}
	changeTab("tab1","content","tab1-act");
	changeTab("list2","list2-sub","");
	
});





