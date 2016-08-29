(function($){
    $(function(){
        /**
         * Handle click event to toggle visibility of chnage password section
         */
        $("#password-toggle").on("click", function(event){
            $("#password-section").toggle();
            $("#password-toggle span").toggle();
            $("#password-section input").val("");
            event.preventDefault();
        });
        
        /**
         * Handle click event to save profile
         */
        $("button.save-profile").on("click", function(e){
            // If the passwords don't match, show error
            if ($("input#password").val() !== $("input#passwordConfirmation").val()){
                $("input#password").notifie({
                    anchor: "div",
                    message: K.translate("bundle", "Passwords do not match."),
                    exitEvents: "focus"
                });
                return;
            }
            // Build data object to save
            var data = {
                displayName: $("input#displayName").val().trim(),
                email: $("input#email").val().trim(),
                preferredLocale: $("select#preferredLocale").val()
            };
            // If password is entered, add it to data object
            if ($("input#password").val().length > 0){
                data.password = $("input#password").val();
            }
            // Save the data
            $.ajax({
                method: "put",
                dataType: "json",
                url: bundle.apiLocation()+"/me",
                data: JSON.stringify(data),
                beforeSend: function(jqXHR, settings){
                    // Disable save button and close all notifications
                    $("button.save-profile").prop("disabled", true);
                    $("div.profile").notifie({
                        exit: true,
                        recurseExit: true
                    });
                },
                success: function(data, textStatus, jqXHR){
                    // Build success notification options
                    var notification = {
                        severity: "success",
                        message: K.translate("bundle", "Successfully updated user profile for NAME").replace("NAME", data.user.displayName)
                    };
                    // If locale changed reload page in 5 seconds
                    if(bundle.config.userLocale !== data.user.preferredLocale){
                        // Add message that page will reload
                        notification.message += "<br>" 
                            + K.translate("bundle", "The page will reload in NUMBER seconds due to the change in preferred language.")
                               .replace("NUMBER", "<span class='reload-timer'>5</span>");
                        // Call method on show that updates countdown timer and reloads after 5 seconds
                        notification.onShow = function(n){
                            (function countdown(remaining, span) {
                                if(remaining <= 0){
                                    location.reload(true);
                                }
                                $(span).text(remaining);
                                setTimeout(function(){ countdown(remaining - 1, span); }, 1000);
                            })(5, n.find("span.reload-timer"));
                        };
                    }
                    // Otherwise, expire success notification after 5 seconds
                    else {
                        notification.expire = 5000;
                    }
                    // Show notification
                    $("div.profile").notifie(notification);
                },
                error: function(jqXHR, textStatus, errorThrown){
                    $("div.profile").notifie({
                        message: K.translate("bundle", "Failed to save changes.")
                    });
                },
                complete: function(jqXHR, settings){
                    $("button.save-profile").prop("disabled", false);
                }
            });
        });
    });
})(jQuery);