(function (window, $, moment) {
    // Ensure the locking namespace is prepared
    window.bundle.ext = window.bundle.ext || {};
    window.bundle.ext.locking = window.bundle.ext.locking || {
        config: {
            lockDuration: 60,
            timeoutInterval: 55
        }
    };
    
    // Create un-namespaced variables to simplify code
    var bundle = window.bundle;
    var locking = window.bundle.ext.locking;
    
    /**
     * 
     * @param {type} kineticForm
     * @param {type} config
     * @returns {undefined}
     */
    locking.observe = function(kineticForm, config) {
        // Determine the configuration options
        config = config || {};
        var lockDuration = config.lockDuration || locking.config.lockDuration;
        var timeoutInterval = config.timeoutInterval || locking.config.timeoutInterval;
        // Calculate the url parameters
        var id = kineticForm.submission.id;
        var until = moment().add(lockDuration, 'seconds').toISOString();
        // Make the AJAX call
        $.ajax({
            method: "GET",
            url: bundle.kappLocation()+'?page=lock&id='+id+'&until='+until,
            contentType: "application/json",
            headers: {
                'X-HTTP-Method-Override': 'PUT'
            },
            timeout: timeoutInterval*1000,
            success: function(content) {
                // Initialize 
                config.element = config.element || $('<div>').prependTo(kineticForm.element());
                // Write the content
                $(config.element).html(content);
                // Recall lock after the timeout interval
                setTimeout(function() {
                    locking.observe(kineticForm, config);
                }, timeoutInterval*1000);
            }
        });
    };
})(window, $, moment);