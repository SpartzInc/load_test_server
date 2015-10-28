$(document).ready(function () {
    var $switches = $('.switch')

    if ( $switches.length ) {
        //alert('looks like ' + $switches.length + ' switches');
        //var activateGhost = function () {},
            deactivateGhost = function () {};

        $switches.on('click', function (e) {
            debugger;
        })


        $switches.bootstrapSwitch();


        $switches.on('switchChange.bootstrapSwitch', function(event, state) {
            var $this = $(this),
                id = $this.attr('data-host-id'),
                switchSuccess = function (data, status) {
                    //debugger;
                    console.log('ajax request succeeded');
                    $this.bootstrapSwitch('state', state);
                    $('pre#ghost-list').html(data.ghostList);
                },
                switchError = function (xhr, textStatus, errorThrown) {
                    console.log('ajax request failed :(');
                    console.log(textStatus + errorThrown);
                    $this.bootstrapSwitch('state', !state, 'skip');
                };

            console.log('host trying to turn ' + (state ? "on" : "off"));
            $(this).bootstrapSwitch('toggleIndeterminate')
            //debugger;

            $.ajax({
                method: 'patch',
                url: '/custom_hosts/' + id,
                data: {custom_host: {active: state}},
                success: switchSuccess,
                error: switchError
            });

        });
    }
})

