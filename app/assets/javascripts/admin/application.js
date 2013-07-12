// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ckeditor/init
function add_count_to_cart(cart_type){
//    var count_value = document.getElementById("quantity_1").innerHTML;
//    //console.log(count_value);
//    alert("liukai test test  test"+cart_type);
//    if(cart_type == "add"){
//        //alert("count_value==="+count_value);
//       count_value = Number(count_value) + 1;
//    }else if(cart_type == "cut"){
//       count_value = Number(count_value) - 1;
//    }
    //else{
    // count_value = cart_type
    //}
    //console.log(count_value);
    
    count_value_total = 0;
    var allElements = [];
    allElements = document.getElementsByTagName('input');
    for(var i = 0; i<allElements.length; i++){
        if (allElements[i].className == "quantity_value") {
           count_value_total += Number(allElements[i].value);
        }
    }
    document.getElementById("quantity_1").innerHTML = count_value_total;

}