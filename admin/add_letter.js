function validateForm(){
    var all_semesters_choice=document.getElementById("all_semesters");
    if (all_semesters_choice[all_semesters_choice.selectedIndex].value=='int')
        document.getElementById('semester').value='08';
}
function selectSemester(){
    var all_semesters_choice=document.getElementById("all_semesters");
    if (all_semesters_choice[all_semesters_choice.selectedIndex].value=='X'){
        document.getElementById("semester").selectedIndex=0;
        document.getElementById("semester_div").style.display="none";
    }
    else if (all_semesters_choice[all_semesters_choice.selectedIndex].value==''){
        document.getElementById("semester_div").style.display="block";
    }
}