from zarinpal import ZarinPal
from core.config import Config

authority = "Your Authority"    
status = "OK"

def initiate_payment():
    try:
        zarinpal = ZarinPal(Config)

        response = zarinpal.payments.create({
            "amount": 20000, 
            "callback_url": "https://zarinpal.com/", 
            "description": "Payment creat", 
        })

        print("Payment created successfully:", response)
        
        if "data" in response and "authority" in response["data"]:
            authority = response["data"]["authority"]
            payment_url = zarinpal.payments.generate_payment_url(authority)
            print("Payment URL:", payment_url)
        else:
            print("Authority not found in response.")


    except Exception as e:
        print("Error during payment creation:", e)

def get_amount_from_database(authority):
    return 20000

def verify_payment(authority, status):
    if status == "OK":
        amount = get_amount_from_database(authority)

        if amount:
            try:
                config = Config(
                    merchant_id= "Your merchant code", 
                    sandbox=True, 
                )
                zarinpal = ZarinPal(config)    
                response = zarinpal.verifications.verify({
                    "amount": amount,
                    "authority": authority,
                })

                if response["data"]["code"] == 100:
                    print("Payment Verified:")
                    print("Reference ID:", response["data"]["ref_id"])
                    print("Card PAN:", response["data"]["card_pan"])
                    print("Fee:", response["data"]["fee"])
                elif response["data"]["code"] == 101:
                    print("Payment already verified.")
                else:
                    print("Transaction failed with code:", response["data"]["code"])

            except Exception as e:
                print("Payment Verification Failed:", e)
        else:
            print("No Matching Transaction Found For This Authority Code.")
    else:
        print("Transaction was cancelled or failed.")
if __name__ == "__main__":
    initiate_payment()
    verify_payment(authority, status)
