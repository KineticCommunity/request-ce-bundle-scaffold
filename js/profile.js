(function($){
    /*----------------------------------------------------------------------------------------------
     * DOM MANIPULATION AND EVENT REGISTRATION 
     *   This section is executed on page load to register events and otherwise manipulate the DOM.
     *--------------------------------------------------------------------------------------------*/
    $(function(){
        
        // Enable adding multiple profile attribute values for those with allowsMultiplt = true
        $("div.profile-content a.add-multiple-attribute").on("click", profile.addMultipleAttributeInput);   
        
        // Enable toggling of change password section
        $("#password-toggle").on("click", profile.enablePasswordToggle);
        
        // Save the user
        $("div.profile button.save-profile-btn").on("click", profile.saveUser);
        
    });
    
    /*----------------------------------------------------------------------------------------------
     * COMMON INIALIZATION 
     *   This code is executed when the Javascript file is loaded
     *--------------------------------------------------------------------------------------------*/
   
    // Private namespace for profile
    var profile = new Object();
    
    profile.addMultipleAttributeInput = function(e){
        $(this).closest("div").before(
            $("<input>", {
                name: "profileAttributes", 
                "data-attribute": $(this).data("attribute"), 
                class: "form-control"
            })
        );
    };
    
    profile.enablePasswordToggle = function(e){
        $("#password-section").toggle();
        $("#password-toggle span, #password-toggle-hr").toggle();
        $("#password-section input").val("");
        $(this).blur();
    };
    
    profile.saveUser = function(e){
        // If the passwords don't match, show error
        if ($("input[name=password]").val() !== $("input[name=passwordConfirmation]").val()){
            $("input[name=password]").notifie({
                anchor: "div",
                message: K.translate("bundle", "Passwords do not match."),
                exitEvents: "keyup"
            });
            return;
        }
        
        var user = {
            displayName: $("input[name=displayName]").val(),
            email: $("input[name=email]").val(),
            preferredLocale: $("select[name=preferredLocale]").val(),
            profileAttributes: new Array()
        };
        if ($("input[name=password]").val().length > 0){
            user.password = $("input[name=password]").val();
        }
        
        var profileAttributes = new Object();
        $("input[name=profileAttributes]").each(function(i, input){
            var name = $(input).data("attribute");
            var value = $(input).val();
            if (value.trim().length > 0){
                if (!profileAttributes[name]){
                    profileAttributes[name] = new Array();
                }
                profileAttributes[name].push(value.trim());
            }
        });
        $.each(profileAttributes, function(name, value){
            if (name && value && value.length > 0){
                user.profileAttributes.push({
                    name: name,
                    values: value
                });
            }
        });
        
        profile.updateMe(user);
    };
    
    profile.updateMe = function(data){
        // Update current user
        $.ajax({
            method: "put",
            dataType: "json",
            url: bundle.apiLocation()+"/me",
            data: JSON.stringify(data),
            beforeSend: function(jqXHR, settings){
                // Disable save button and close all notifications
                $("div.profile button.save-profile-btn").prop("disabled", true);
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
                    message: K.translate("bundle", "Failed to update user profile.")
                });
            },
            complete: function(jqXHR, settings){
                $("div.profile button.save-profile-btn").prop("disabled", false);
            }
        });
    };
    
    
})(jQuery);