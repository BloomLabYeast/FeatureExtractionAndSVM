function SendEmailSkeleton(purpose,emailaddress,string)
    gmail_user =
    gmail_password = 
    string = purpose + ": " + string;
    system(sprintf('python SendEmail.py %s %s %s "%s"', gmail_user, gmail_password, emailaddress, string));
end