from zarinpal import ZarinPal
from core.config import Config
from fastapi.responses import RedirectResponse, JSONResponse

authority = "Your Authority"    
status = "OK"

def initiate_payment(amount, callback_url,description):
    try:
        config = Config()
        zarinpal = ZarinPal(config)
        response = zarinpal.payments.create({
            "amount": int(amount), 
            "callback_url": callback_url, 
            "description": description, 
        })

        # print("Payment created successfully:", response)
        
        if "data" in response and "authority" in response["data"]:
            authority = response["data"]["authority"]
            payment_url = zarinpal.payments.generate_payment_url(authority)
            return RedirectResponse(payment_url)
        else:
            return JSONResponse({"error": "Authority not found in response."})


    except Exception as e:
        print("Error during payment creation:", e)

def verify_payment(authority, amount, status):
    if status == "OK":
        if amount:
            try:
                config = Config()
                zarinpal = ZarinPal(config)    
                response = zarinpal.verifications.verify({
                    "amount": int(amount),
                    "authority": authority,
                })

                if response["data"]["code"] == 100:
                    return {
                        'status' : 'ok',
                        'ref_id' : response["data"]["ref_id"],
                        'code' : '',
                        'error' : ''
                    }
                elif response["data"]["code"] == 101:
                    return {
                        'status' : 'already',
                        'ref_id' : '',
                        'code' : '',
                        'error' : ''
                    }
                else:
                    return {
                        'status' : 'failed',
                        'ref_id' : '',
                        'code' : response["data"]["code"],
                        'error' : ''
                    }
            except Exception as e:
                return {
                    'status' : 'failed_payment',
                    'ref_id' : '',
                    'code' : '',
                    'error' : e
                }
        else:
            return {
                'status' : 'not_transaction',
                'ref_id' : '',
                'code' : '',
                'error' : ''
            }
    else:
        return {
            'status' : 'cancelled_or_failed',
            'ref_id' : '',
            'code' : '',
            'error' : ''
        }

