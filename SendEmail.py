import smtplib
import sys

gmail_user = argv[1]  
gmail_password = argv[2]

sent_from = gmail_user  
to = sys.argv[3]
subject = 'OMG Super Important Message'

email_text = """ From:%s
To: %s
Subject: %s
""" % (gmail_user,to, sys.argv[4])

try:  
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmail_user, gmail_password)
    server.sendmail(sent_from, to, email_text)
    server.close()

    print('Email sent!')
except:  
    print('Something went wrong...')