var TableList
var BaseTable
var KillIntigator

function secondsToTime(timer) {
    var sec_num = parseInt(timer, 10);
    var hours   = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);

    // if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    // hours+':'+
    return minutes+':'+seconds;
}

function GetSortOrder(prop) {
    return function(a, b) {
        if (a[prop] > b[prop]) {
            return 1;
        } else if (a[prop] < b[prop]) {
            return -1;
        }
        return 0;
    }
}


Events.Subscribe("QUAKE_HUD_Players_Remaining", function(players) {
    document.querySelector("#hud_players").innerHTML = players;
});

Events.Subscribe("QUAKE_HUD_Timer", function(timer) {
    document.querySelector("#hud_time").innerHTML = secondsToTime(timer);
});

Events.Subscribe("QUAKE_HUD_Points", function(points) {
    document.querySelector("#hud_points").innerHTML = points;
});

Events.Subscribe("QUAKE_HUD_Advert_top_one", function(txt) {
    if (txt == null)
        return document.querySelector("#hud_advert_one").style.display = "none";
    document.querySelector("#hud_advert_one").innerHTML = txt;
    document.querySelector("#hud_advert_one").style.display = "block";
});

Events.Subscribe("QUAKE_HUD_Advert_important", function(txt) {
    if (txt == null)
        return document.querySelector("#advert_important").style.display = "none";
    document.querySelector("#advert_important").innerHTML = txt;
    document.querySelector("#advert_important").style.display = "block";
});

Events.Subscribe("QUAKE_HUD_Killed", function (instigator) {
    if (instigator == null)
        return KillIntigator.style.display = "none";
    document.querySelector("#hud-killed-instigator").innerHTML = instigator;
    KillIntigator.style.display = "block";
});

Events.Subscribe("QUAKE_HUD_Scoreboard", function (scores) {
    if (scores == null)
        return BaseTable.style.display = "none";
    DeleteScoreboardList()
    var resultScores = JSON.parse(scores)
    resultScores.sort(GetSortOrder("Points"))
    resultScores.reverse()
    for (var i = 0; i < resultScores.length && i < 5; i++) {
        AddPlayerScoreboard(resultScores[i]["Name"], resultScores[i]["Points"])
    }
    BaseTable.style.display = "block";
});

function AddPlayerScoreboard(player, point) {
    var newTR = document.createElement("tr");
    var newTH_player = document.createElement("th");
    var newTH_points = document.createElement("th");
    newTH_player.innerHTML = player
    newTH_points.innerHTML = point
    newTR.appendChild(newTH_player)
    newTR.appendChild(newTH_points)
    TableList.appendChild(newTR)
}

function DeleteScoreboardList() {
    TableList.querySelectorAll('*').forEach(n => n.remove());
}

function LoadEvents() {
    // ControlsDiv = document.getElementById("ControlRightOptionsDiv")
    TableList = document.getElementById("table_list")
    BaseTable = document.getElementById("base_table")
    KillIntigator = document.getElementById("hud-killed")
    // testun = document.getElementById("TopRightTitleSelected")
    // testun.onclick = DeleteScoreboardList
}

window.onload = LoadEvents