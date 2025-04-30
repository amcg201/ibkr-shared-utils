from ib_insync import IB
import time
import smtplib
from email.message import EmailMessage

MAX_WAIT_SECONDS = 300
CHECK_INTERVAL = 5
EMAIL_FROM = 'amcg20@gmail.com'
EMAIL_TO = 'amcg20@gmail.com'
EMAIL_PASS = 'wadklbqbvttiyqih'  # ← Replace this securely

def send_failure_email():
    msg = EmailMessage()
    msg.set_content("❌ IB Gateway did not respond within 300 seconds.")
    msg['Subject'] = 'IB Gateway Connection Failure'
    msg['From'] = EMAIL_FROM
    msg['To'] = EMAIL_TO

    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(EMAIL_FROM, EMAIL_PASS)
        server.send_message(msg)
        server.quit()
        print("❌ Alert email sent.")
    except Exception as e:
        print(f"⚠️ Email failed: {e}")

def wait_for_ib():
    ib = IB()
    start_time = time.time()
    while time.time() - start_time < MAX_WAIT_SECONDS:
        try:
            ib.connect('127.0.0.1', 4002, clientId=99)
            print("✅ IB Gateway is ready.")
            ib.disconnect()
            return True
        except:
            print("⏳ IB Gateway not ready yet...")
            time.sleep(CHECK_INTERVAL)

    print("❌ Timeout reached. IB Gateway still not available.")
    send_failure_email()
    return False

if __name__ == '__main__':
    wait_for_ib()
