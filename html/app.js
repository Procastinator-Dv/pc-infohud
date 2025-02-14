$(function () {
    window.addEventListener('message', function (event) {
        var v = event.data;

        switch (v.action) {
            case "UpdateMoney":
                if (v.account === 'money') {
                    $(".dwallet").text(`${v.icon} ${v.money}`);
                    $('.wallet').fadeIn();
                    setTimeout(() => {
                        $('.wallet').fadeOut();
                    }, v.time);
                } else if (v.account === 'bank') {
                    $(".dbank").text(`${v.icon} ${v.money}`);
                    $('.bank').fadeIn();
                    setTimeout(() => {
                        $('.bank').fadeOut();
                    }, v.time);
                }
                break;

            case "playerLoggedIn":
                $(".allstatus").css("display", "grid");
                break;

            case "hideHUD":
                // Hide all elements, including the Discord link and logo
                $(".allstatus, .wallet, .bank, .job, .id, .discord, .discord-id").css("visibility", "hidden");
                $(".server-logo").addClass("hidden"); // Hide the logo when HUD is hidden
                console.log('Logo hidden');
                break;

            case "showHUD":
                // Show all elements, including the Discord link and logo
                $(".allstatus, .wallet, .bank, .job, .id, .discord, .discord-id").css("visibility", "visible");
                $(".server-logo").removeClass("hidden"); // Show the logo when HUD is visible
                console.log('Logo shown');
                break;
        }
    });

    window.addEventListener('message', function (event) {
        let wallet = event.data.wallet;
        let bank = event.data.bank;
        let id = event.data.id;
        let job = event.data.job;  // This will be the job name (e.g., "Police")
        let job_grade = event.data.job_grade;  // This will be the job grade (e.g., "Chief")
    
        // Update UI with both job and job grade
        $(".dbank").text(bank);
        $(".dwallet").text(wallet);
        $(".did").text(id);
        $(".djob").text(`${job} - ${job_grade}`); // Show both job and job grade (e.g., "Police - Chief")
    });
    
});
