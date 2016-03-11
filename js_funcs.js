function validateRadio (radios)
{
    /*for (i = 0; i < radios.length; ++ i)
    {
        if (radios [i].checked) return true;
    }*/
    if (document.getElementById("gsu").checked) return true;
    if (document.getElementById("gpc").checked) return true;
    alert("Please choose a status  to view.")
    return false;
}